//
//  Extensions.swift
//  ThemeDemo
//
//  Created by 邓永豪 on 2017/8/24.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func loadImage(_ imageName: String) -> UIImage? {
        return loadImage(imageName, style: ThemeManager.instance.style)
    }
    
    // 如果明确资源不受 theme 变化而变化，使用这个接口会更快
    static func loadDefaultImage(_ imageName: String) -> UIImage? {
        return loadImage(imageName, style: .default)
    }
    
    static func loadImage(_ imageName: String, style: ThemeStyle) -> UIImage? {
        
        if imageName.isEmpty || imageName.characters.count == 0 {
            return nil
        }
        
        var bundleName = "defaultTheme"
        switch style {
        case .black:
            bundleName =  "blackTheme"
        default:
            bundleName = "defaultTheme"
        }

        guard let themeBundlePath = Bundle.path(forResource: bundleName, ofType: "bundle", inDirectory: Bundle.main.bundlePath) else {
            return nil
        }
        guard let themeBundle = Bundle(path: themeBundlePath) else {
            return nil
        }
        
        var isImageUnder3x = false
        var nameAndType = imageName.components(separatedBy: ".")
        var name = nameAndType.first!
        let type = nameAndType.count > 1 ? nameAndType[1] : "png"
        var imagePath  =  themeBundle.path(forResource: "image/" + name, ofType: type)
        let nameLength = name.characters.count
        
        if imagePath == nil && name.hasSuffix("@2x") && nameLength > 3 {
            let index = name.index(name.endIndex, offsetBy: -3)
            name = name.substring(with: Range<String.Index>(name.startIndex ..< index))
        }
        
        if imagePath == nil && !name.hasSuffix("@2x") {
            let name2x = name + "@2x";
            imagePath = themeBundle.path(forResource: "image/" + name2x, ofType: type)
            if imagePath == nil && !name.hasSuffix("3x") {
                let name3x = name + "@3x"
                imagePath = themeBundle.path(forResource: "image/" + name3x, ofType: type)
                isImageUnder3x = true
            }
        }
        
        var image: UIImage?
        if let imagePath = imagePath {
            image = UIImage(contentsOfFile: imagePath)
        } else {
            // 如果当前 bundle 里面不存在这张图片的路径，那就去默认的 bundle 里面找，
            // 为什么要这样做呢，因为部分资源在不同 theme 中是一样的，就不需要导入重复的资源，使应用包的大小变大
            image = UIImage.loadDefaultImage(imageName)
        }
        if #available(iOS 8, *) {
            return image
        }
        if !isImageUnder3x {
            return image
        }
        return image?.scaledImageFrom3x()
    }
    
    private func scaledImageFrom3x() -> UIImage {
        let theRate: CGFloat = 1.0 / 3.0
        let oldSize = self.size
        let scaleWidth = CGFloat(oldSize.width) * theRate
        let scaleHeight = CGFloat(oldSize.height) * theRate
        var scaleRect = CGRect.zero
        scaleRect.size.width = scaleWidth
        scaleRect.size.height = scaleHeight
        UIGraphicsBeginImageContextWithOptions(scaleRect.size, false, UIScreen.main.scale)
        draw(in: scaleRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(_ colorName: String) {
        let  netHex = ThemeManager.instance.themeColor(colorName)
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
}
