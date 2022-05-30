//
//  UIViewExtension.swift
//  SMLTool
//
//  Created by SongMenglong on 2021/7/2.
//

import UIKit

public extension UIView {
    
    /// 屏幕截图
    var snapshot: UIImage? {
        // usage: let myImage = view?.snapshot
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

