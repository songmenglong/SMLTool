//
//  StringExtension.swift
//  SMLTool
//
//  Created by SongMenglong on 2020/6/4.
//  Copyright © 2020 magnum. All rights reserved.
//

import UIKit

//MARK: 字符串的扩展方法
/// 字符串的扩展方法
public extension String {
    
    /// 字符串是否是电话号码
    var isTelNumber: Bool {
        /*
         中国电信
         133、149、153、173、177、180、181、189、199
         中国联通号段
         130、131、132、145、155、156、166、175、176、185、186
         中国移动号段
         134(0-8)、135、136、137、138、139、147、150、151、152、157、158、159、178、182、183、184、187、188、198
         
         其他号段
         14号段以前为上网卡专属号段，如中国联通的是145，中国移动的是147等等。
         虚拟运营商
         电信：1700、1701、1702
         移动：1703、1705、1706
         联通：1704、1707、1708、1709、171
         */
        // 手机号码
        let mobile = "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$"
        /*
         中国移动：China Mobile
         134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         */
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        /*
         中国联通：China Unicom
         130,131,132,152,155,156,183,185,186,176
         */
        let  CU = "^1(3[0-2]|5[256]|7[56]|8[356])\\d{8}$"
        /*
         中国电信：China Telecom
         133,1349,153,180,189,177,181
         */
        let  CT = "^1((33|53|8[019]|77)[0-9]|349)\\d{7}$"
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: self) == true)
            || (regextestcm.evaluate(with: self)  == true)
            || (regextestct.evaluate(with: self) == true)
            || (regextestcu.evaluate(with: self) == true)) {
            // 是手机号
            return true
        } else {
            // 非手机号
            return false
        }
    }
    
    /// 字符串是否为邮箱
    var isEmail: Bool {
        if self.count == 0 {
            return false
        }
        // 邮箱正则表达式
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    /// 是否为车牌号
    var isCarNumber: Bool {
        debugPrint("检测车牌号::: ", self)
        if self.count == 7 {
            // 普通汽车，7位字符，不包含I和O，避免与数字1和0混淆
            // let carRegex: String = "^[\\u4e00-\\u9fa5]{1}[a-hj-np-zA-HJ-NP-Z]{1}[a-hj-np-zA-HJ-NP-Z0-9]{4}[a-hj-np-zA-HJ-NP-Z0-9\\u4e00-\\u9fa5]$"
            let carRegex: String = "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[a-hj-np-zA-HJ-NP-Z]{1}[a-hj-np-zA-HJ-NP-Z0-9]{4}[a-hj-np-zA-HJ-NP-Z0-9挂学警港澳]$"
            let carTest =  NSPredicate(format: "SELF MATCHES %@", carRegex)
            return carTest.evaluate(with: self)
        } else if self.count == 8 {
            //新能源车,8位字符，第一位：省份简称（1位汉字），第二位：发牌机关代号（1位字母）;
            //小型车，第三位：只能用字母D或字母F，第四位：字母或者数字，后四位：必须使用数字;([DF][A-HJ-NP-Z0-9][0-9]{4})
            //大型车3-7位：必须使用数字，后一位：只能用字母D或字母F。([0-9]{5}[DF])
            //let carRegex: String = "^[\\u4e00-\\u9fa5]{1}[a-hj-np-zA-HJ-NP-Z]{1}([0-9]{5}[d|f|D|F]|[d|f|D|F][a-hj-np-zA-HJ-NP-Z0-9][0-9]{4})$"
            let carRegex: String = "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[a-hj-np-zA-HJ-NP-Z]{1}([0-9]{5}[d|f|D|F]|[d|f|D|F][a-hj-np-zA-HJ-NP-Z0-9][0-9]{4})$"
            let carTest =  NSPredicate(format: "SELF MATCHES %@", carRegex)
            return carTest.evaluate(with: self)
        } else {
            return false
        }
    }
    
    
    /// 日期字符串转Date类型
    /// - Parameter string: 日期字符串
    /// - Parameter dateFormat: 格式化样式，默认为“yyyy-MM-dd HH:mm:ss”
    static func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    
    /// 使用下标截取字符串 例: "示例字符串"[0..<2] 结果是 "示例"
    ///
    /// - Parameter r: 区间
    subscript (r: Range<Int>) -> String? {
        get {
            if (r.lowerBound > count) || (r.upperBound > count) {
                return nil
            }
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    
    
    /// 在字符串中查找另一字符串首次出现的位置（或最后一次出现位置）
    ///
    /// - Parameters:
    ///   - sub: 要查找的字符串
    ///   - backwards: true，则返回最后出现的位置
    /// - Returns: 出现的位置 (如果没有找到就返回-1)
    func positionOf(sub:String, backwards:Bool = false) -> Int {
        // 如果没有找到就返回-1
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    
    
    /// 截取第一个到第任意位置
    ///
    /// - Parameter end: 结束的位值
    /// - Returns: 截取后的字符串
    func stringCut(end: Int) ->String{
        if !(end < self.count) { return "截取超出范围" }
        let sInde = index(startIndex, offsetBy: end)
        return String(self[...sInde])
    }
    
    
    /// 截取第任意位置到结束
    ///
    /// - Parameter end:
    /// - Returns: 截取后的字符串
    func stringCutToEnd(start: Int) -> String {
        if !(start < count) { return "截取超出范围" }
        let sRang = index(startIndex, offsetBy: start)
        return String(self[sRang...])
    }
    
    
    /// 字符串任意位置插入
    /// /// - Parameters:
    /// - content: 插入内容
    /// - locat: 插入的位置
    /// - Returns: 添加后的字符串
    func stringInsert(content: String,locat: Int) -> String {
        if !(locat < count) { return "截取超出范围" }
        let str1 = stringCut(end: locat)
        let str2 = stringCutToEnd(start: locat+1)
        return str1 + content + str2
    }
    
    
    /// 十六进制字符串转Data
    /// Create `Data` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    func hexadecimal() -> Data? {
        var data = Data(capacity: self.count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        guard data.count > 0 else { return nil }

        return data
    }

}
