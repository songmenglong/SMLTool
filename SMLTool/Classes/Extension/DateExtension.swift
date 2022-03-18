//
//  DateExtension.swift
//  SMLTool
//
//  Created by SongMenglong on 2020/12/10.
//  Copyright © 2020 magnum. All rights reserved.
//

import UIKit

//MARK: 时间日期的扩展方法
/// 获取当前日期
public extension Date {
    /// 格式化的时间字符串
    func formatDate(_ format: String = "yyyy-MM-dd") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = format
        let date = formatter.string(from: self)
        //swiftDebug("格式化时间字符串", date)
        return date.components(separatedBy: " ").first!
    }
    
    /// 格式化字符串
    func formatNowZone(_ format: String = "yyyy-MM-dd") -> String {
        let timeZone = TimeZone.current
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.current
        formatter.dateFormat = format
        let date = formatter.string(from: self)
        //swiftDebug("格式化时间字符串", date)
        return date.components(separatedBy: " ").first!
        //return ""
    }
    
    
    /// 时间字符串转Date
    static func stringConvertDate(dateStr: String, dateFormat:String="yyyy-MM-dd") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.init(identifier: "zh_GB")
        formatter.timeZone = TimeZone.current
        // 转换成当前时间
        if let date = formatter.date(from: dateStr) {
            return date
        } else {
            return Date()
        }
    }
    
    
    /// 时间转换字符串
    static func dateFullConvertString(date:Date, dateFormat:String="yyyy-MM-dd") -> String {
        //let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        //formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_GB")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
    
    
}
