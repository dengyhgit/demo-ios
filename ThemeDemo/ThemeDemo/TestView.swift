//
//  text.swift
//  ThemeDemo
//
//  Created by 邓永豪 on 2017/8/23.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

import UIKit

class TestView: UIView, ThemeProtocol {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addThemeObserver()
        self.backgroundColor = UIColor("bg_testview")
    }
    
    override func updateTheme() {
        super.updateTheme()
        self.backgroundColor = UIColor("bg_testview")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeThemeObserver()
    }
}
