//
//  DataExtension.swift
//  SMLTool
//
//  Created by SongMenglong on 2022/2/14.
//

import UIKit

extension Data {
    
    /// 转十六进制字符串
    /// Create hexadecimal string representation of `Data` object.
    ///
    /// - returns: `String` representation of this `Data` object.
    func hexadecimal() -> String {
        return map { String(format: "%02x", $0)}.joined(separator: "")
    }
}
