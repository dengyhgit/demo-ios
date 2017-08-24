//
//  TestViewController.swift
//  ThemeDemo
//
//  Created by 邓永豪 on 2017/8/24.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var otherImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
    }
    
    deinit {
        // deinit 时一定要移除监听，否则可能 crash
        removeThemeObserver()
    }
    
    private func _init() {
        addThemeObserver()
        view.backgroundColor = UIColor("bg_main")
        let testView = TestView(frame: CGRect(x: (view.frame.size.width - 150) / 2, y: 150, width: 150, height: 150))
        view.addSubview(testView)
        
        imageView.image = UIImage.loadImage("icon")
        // 如果在所有 theme 中都是一样的，使用 loadDefault 会更快
//        otherImageView.image = UIImage.loadImage("icon2")
        otherImageView.image = UIImage.loadDefaultImage("icon2")
    }
    
    @IBAction func defaultTheme(_ sender: Any) {
        ThemeManager.instance.updateThemeStyle(.default)
    }
    
    @IBAction func blackTheme(_ sender: Any) {
        ThemeManager.instance.updateThemeStyle(.black)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension TestViewController: ThemeProtocol {
    override func updateTheme() {
        super.updateTheme()
        view.backgroundColor = UIColor("bg_main")
        imageView.image = UIImage.loadImage("icon")
        // 如果在所有 theme 中都是一样的，就不必要写在这里
//        otherImageView.image = UIImage.loadImage("icon2")
    }
}
