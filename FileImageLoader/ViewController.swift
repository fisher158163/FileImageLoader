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
        runAllTests()
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

// MARK: - 测试C语言函数
extension ViewController {
    func runAllTests() {
        testMathUtils()
        testStringUtils()
    }
    
    func testMathUtils() {
        print("------- 测试数学工具 -------")
        
        // 加法
        let sum = add(10, 20)
        print("10 + 20 = \(sum)")
        
        // 乘法
        let product = multiply(5, 6)
        print("5 × 6 = \(product)")
        
        // 阶乘
        let fact = factorial(5)
        print("5! = \(fact)")
        
        // 质数判断
        let num = 17
        let prime = isPrime(Int32(num))
        print("\(num) 是质数: \(prime)")
        
        // 斐波那契数列
        let fib = fibonacci(10)
        print("斐波那契数列第10项: \(fib)")
    }
    
    func testStringUtils() {
        print("\n------- 测试字符串工具 -------")
        
        // 字符串长度
        let str = "Hello World"
        let cStr = (str as NSString).utf8String
        let length = stringLength(cStr)
        print("字符串 '\(str)' 长度: \(length)")
        
        // 字符串反转
        let reverseStr = "Swift"
        reverseStr.withCString { ptr in
            let mutablePtr = UnsafeMutablePointer(mutating: ptr)
            reverseString(mutablePtr)
            let reversed = String(cString: mutablePtr)
            print("反转 'Swift': \(reversed)")
        }
        
        // 统计字符
        let countStr = "Hello"
        let count = countChar((countStr as NSString).utf8String, Int8(UInt8(ascii: "l")))
        print("'Hello' 中 'l' 出现次数: \(count)")
    }
}
