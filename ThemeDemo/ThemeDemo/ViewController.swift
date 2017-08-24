//
//  ViewController.swift
//  ThemeDemo
//
//  Created by 邓永豪 on 2017/8/23.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addThemeObserver()
        view.backgroundColor = UIColor("bg_main")
    }
    
    deinit {
        removeThemeObserver()
    }
    
    
    @IBAction func defaultTheme(_ sender: Any) {
        ThemeManager.instance.updateThemeStyle(.default)
    }
    
    @IBAction func blackTheme(_ sender: Any) {
        ThemeManager.instance.updateThemeStyle(.black)
    }
    
    @IBAction func onlineTheme(_ sender: Any) {
        ThemeManager.instance.updateThemeStyle(.online)
    }
    
    @IBAction func push(_ sender: Any) {
        present(TestViewController(), animated: true, completion: nil)
    }
}

extension ViewController: ThemeProtocol {
    override func updateTheme() {
        super.updateTheme()
        view.backgroundColor = UIColor("bg_main")
    }
}
