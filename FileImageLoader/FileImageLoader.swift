//
//  FileImageLoader.swift
//  FileImageLoader
//
//  Created by Fisher on 2025/10/11.
//

import UIKit
import UniformTypeIdentifiers

class FileImageLoader: NSObject {
    
    typealias ImagePickerCompletion = (Result<UIImage, Error>) -> Void
    
    private var completion: ImagePickerCompletion?
    private weak var presentingViewController: UIViewController?
    
    enum ImageLoaderError: Error {
        case cancelled
        case invalidImage
        case accessDenied
        
        var localizedDescription: String {
            switch self {
            case .cancelled:
                return "用户取消了选择"
            case .invalidImage:
                return "无效的图片文件"
            case .accessDenied:
                return "无法访问文件"
            }
        }
    }
    
    // 打开文件选择器
    func pickImage(from viewController: UIViewController, completion: @escaping ImagePickerCompletion) {
        self.completion = completion
        self.presentingViewController = viewController
        
        let documentPicker: UIDocumentPickerViewController
        
        // 支持的图片格式
        var contentTypes: [UTType] = [.image, .png, .jpeg, .heic, .heif, .gif, .tiff,
                                      .bmp, .ico, .icns, .svg, .webP, .rawImage]
        
        // iOS 18+支持heics
        if #available(iOS 18.0, *) {
            contentTypes.append(.heics)
        }
        
        documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: contentTypes, asCopy: true)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.shouldShowFileExtensions = true
        
        viewController.present(documentPicker, animated: true)
    }
    
    // 从URL加载图片
    private func loadImage(from url: URL) -> Result<UIImage, Error> {
        guard url.startAccessingSecurityScopedResource() else {
            return .failure(ImageLoaderError.accessDenied)
        }
        
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        
        do {
            let imageData = try Data(contentsOf: url)
            
            guard let image = UIImage(data: imageData) else {
                return .failure(ImageLoaderError.invalidImage)
            }
            
            return .success(image)
            
        } catch {
            return .failure(error)
        }
    }
    
    // 复制文件到应用文档目录
    func copyToDocuments(from url: URL, fileName: String? = nil) -> Result<URL, Error> {
        guard url.startAccessingSecurityScopedResource() else {
            return .failure(ImageLoaderError.accessDenied)
        }
        
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        
        do {
            let fileManager = FileManager.default
            guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                throw ImageLoaderError.accessDenied
            }
            
            let destinationName = fileName ?? url.lastPathComponent
            let destinationURL = documentsDirectory.appendingPathComponent(destinationName)
            
            // 如果文件已存在，先删除
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            
            try fileManager.copyItem(at: url, to: destinationURL)
            return .success(destinationURL)
            
        } catch {
            return .failure(error)
        }
    }
}

// MARK: - UIDocumentPickerDelegate
extension FileImageLoader: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURL = urls.first else {
            completion?(.failure(ImageLoaderError.invalidImage))
            return
        }
        
        let result = loadImage(from: selectedURL)
        completion?(result)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        completion?(.failure(ImageLoaderError.cancelled))
    }
}
