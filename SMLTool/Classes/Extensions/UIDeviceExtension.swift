//
//  UIDeviceExtension.swift
//  SMLTool
//
//  Created by SongMenglong on 2020/10/23.
//  Copyright © 2020 magnum. All rights reserved.
//

import UIKit
import CoreTelephony

/// 系统手机设备信息 扩展
public extension UIDevice {

    /// 获取设备型号
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":     return "iPod Touch 1"
        case "iPod2,1":     return "iPod Touch 2"
        case "iPod3,1":     return "iPod Touch 3"
        case "iPod4,1":     return "iPod Touch 4"
        case "iPod5,1":     return "iPod Touch (5 Gen)"
        case "iPod7,1":     return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":   return "iPhone 4s"
        case "iPhone5,1":   return "iPhone 5"
        case "iPhone5,2":   return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":   return "iPhone 5c (GSM)"
        case "iPhone5,4":   return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":   return "iPhone 5s (GSM)"
        case "iPhone6,2":   return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":   return "iPhone 6"
        case "iPhone7,1":   return "iPhone 6 Plus"
        case "iPhone8,1":   return "iPhone 6s"
        case "iPhone8,2":   return "iPhone 6s Plus"
        case "iPhone8,4":   return "iPhone SE"
        case "iPhone9,1":   return "国行、日版、港行iPhone 7"
        case "iPhone9,2":   return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":   return "美版、台版iPhone 7"
        case "iPhone9,4":   return "美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":     return "iPhone 8"
        case "iPhone10,2","iPhone10,5":     return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":     return "iPhone X"
        case "iPhone11,2":  return "iPhone XS"
        case "iPhone11,6":  return "iPhone XS MAX"
        case "iPhone11,8":  return "iPhone XR"
        case "iPhone12,1":  return "iPhone 11"
        case "iPhone12,3":  return "iPhone 11 Pro"
        case "iPhone12,5":  return "iPhone 11 Pro Max"
        case "iPhone12,8":  return "iPhone SE (2nd generation)"
        case "iPhone13,1":  return "iPhone 12 mini"
        case "iPhone13,2":  return "iPhone 12"
        case "iPhone13,3":  return "iPhone 12 Pro"
        case "iPhone13,4":  return "iPhone 12 Pro Max"
            
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":   return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
            
            
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":   return "Apple TV 4"
            
        case "i386", "x86_64":   return "Simulator"
            
        default:  return identifier
        }
    }
    
    /// 判断当前手机是否刘海屏幕
    var is_iPhoneXSerious: Bool {
        if #available(iOS 11.0, *) {
            if let keyWindow = UIApplication.shared.keyWindow, keyWindow.safeAreaInsets.bottom > 0.0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    
    /// 当前手机是否有sim卡
    var isSIMInstalled: Bool {
        let networkInfo: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        if (carrier!.isoCountryCode != nil) == false {
            return false
        } else {
            return true
        }
    }
    
    /// 判断当前手机有多少张手机卡
    var simCardNumInPhone: Int {
        let networkInfo: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            if let ctDict: [String: Any] = networkInfo.serviceSubscriberCellularProviders {
                if ctDict.count > 1 {
                    // 判断两张卡
                    let values = Array(ctDict.values) // values转数组
                    let carrier1: CTCarrier = values.first as! CTCarrier
                    let carrier2: CTCarrier = values.last as! CTCarrier
                    
                    if let code1 = carrier1.mobileCountryCode, code1.count != 0, let code2 = carrier2.mobileCountryCode, code2.count != 0 {
                        return 2
                    } else if let code1 = carrier1.mobileCountryCode, code1.count == 0, let code2 = carrier2.mobileCountryCode, code2.count == 0 {
                        return 0
                    } else {
                        return 1
                    }
                } else if ctDict.count == 1 {
                    // 判断是否含有1张卡
                    let values = Array(ctDict.values)
                    let carrier1: CTCarrier = values.first as! CTCarrier
                    if let code1 = carrier1.mobileCountryCode, code1.count != 0 {
                        return 1
                    } else {
                        return 0
                    }
                } else {
                    
                    return 0
                }
            } else {
                // 没有获取到信息
                return 0
            }
        } else {
            if let carrier: CTCarrier = networkInfo.subscriberCellularProvider, let code: String = carrier.mobileCountryCode, code.count > 0 {
                return 1
            } else {
                return 0
            }
        }
    }
    
    
    /// 获取当前SIM信息(运行商名字)
    var operatorName: String  {
        let info = CTTelephonyNetworkInfo()
        
        if #available(iOS 12.0, *) {
            if let carrierDic = info.serviceSubscriberCellularProviders {
                var operatorName = ""
                let values = Array(carrierDic.values)
                for carrier: CTCarrier in values {
                    let code = carrier.mobileCountryCode
                    
                    if code == nil {
                        operatorName = "不能识别"
                    }
                    
                    if code == "00" || code == "02" || code == "04" || code == "07" || code == "08" {
                        operatorName = "移动运营商"
                    } else if code == "01" || code == "06" || code == "09" {
                        operatorName = "联动运营商"
                    } else if code == "03" || code == "05" || code == "11" {
                        operatorName = "电信运营商"
                    } else if code == "20" {
                        operatorName = "铁通运营商"
                    }
                }
                debugPrint("运营商名字:: ", operatorName)
            }
        } else {
            // Fallback on earlier versions
        }
        return "移动"
    }
    
}
