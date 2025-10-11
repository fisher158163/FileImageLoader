//
//  ViewController.swift
//  FileImageLoader
//
//  Created by Fisher on 2025/10/11.
//

import UIKit

class ViewController: UIViewController {
    
    let imageView = UIImageView()
    let imageLoader = FileImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let button = UIButton(type: .system)
        button.setTitle("从文件选择图片", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 240),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func selectImage() {
        imageLoader.pickImage(from: self) { [weak self] result in
            switch result {
            case .success(let image):
                self?.imageView.image = image
                print("成功加载图片，尺寸: \(image.size)")
                
            case .failure(let error):
                print("加载失败: \(error.localizedDescription)")
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
