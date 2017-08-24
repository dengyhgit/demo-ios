//
//  ThemeManager.swift
//  ThemeDemo
//
//  Created by 邓永豪 on 2017/8/23.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

import UIKit

let kUpdateTheme = "kUpdateTheme"
let kThemeStyle = "kThemeStyle"

final class ThemeManager: NSObject {
    
    var style: ThemeStyle {
        return themeStyle
    }
    
    static var instance = ThemeManager()
    
    private var themeBundleName: String {
        switch themeStyle {
        case .black:
            return "blackTheme"
        default:
            return "defaultTheme"
        }
    }
    
    private var themeStyle: ThemeStyle = .default
    private var themeColors: NSDictionary?
    
    private override init() {
        super.init()
        if let style = UserDefaults.standard.object(forKey: kThemeStyle) as? Int {
            themeStyle = ThemeStyle(rawValue: style)!
        } else {
            UserDefaults.standard.set(themeStyle.rawValue, forKey: kThemeStyle)
            UserDefaults.standard.synchronize()
        }
        
        themeColors = getThemeColors()
    }
    
    private func getThemeColors() -> NSDictionary? {
        
        let bundleName = themeBundleName
        
        guard let themeBundlePath = Bundle.path(forResource: bundleName, ofType: "bundle", inDirectory: Bundle.main.bundlePath) else {
            return nil
        }
        guard let themeBundle = Bundle(path: themeBundlePath) else {
            return nil
        }
        guard let path = themeBundle.path(forResource: "themeColor", ofType: "txt") else {
            return nil
        }
        
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions(rawValue: 0)]) as? NSDictionary
        } catch {
            return nil
        }

    }
    
    func updateThemeStyle(_ style: ThemeStyle) {
        if themeStyle.rawValue == style.rawValue {
            return
        }
        themeStyle = style
        UserDefaults.standard.set(style.rawValue, forKey: kThemeStyle)
        UserDefaults.standard.synchronize()
        themeColors = getThemeColors()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateTheme), object: nil)
    }
    
    func themeColor(_ colorName: String) -> Int {
        guard let hexString = themeColors?.value(forKey: colorName) as? String else {
            assert(true, "Invalid color key")
            return 0
        }
        let colorValue = Int(strtoul(hexString, nil, 16))
        return colorValue
    }
}

