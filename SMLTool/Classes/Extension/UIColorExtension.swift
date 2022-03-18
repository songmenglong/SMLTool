//
//  UIColorExtension.swift
//  SMLTool
//
//  Created by SongMenglong on 2020/6/8.
//  Copyright © 2020 magnum. All rights reserved.
//

import UIKit

/// 颜色的扩展
public extension UIColor {

    /// 十六进制颜色
    convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    /// 初始化方法
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    /// 颜色
    @objc class func colorFromRGB(_ rgbValue: Int) -> UIColor{
        let red: CGFloat = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let green: CGFloat = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
        let blue: CGFloat = CGFloat(rgbValue & 0xFF)/255.0
        return UIColor(red:red , green: green, blue: blue, alpha: 1.0)
    }
}
