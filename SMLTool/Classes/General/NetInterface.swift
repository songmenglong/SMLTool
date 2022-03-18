//
//  NetInterface.swift
//  SMLTool
//
//  Created by SongMenglong on 2019/7/9.
//  Copyright © 2019 magnum. All rights reserved.
//

import SystemConfiguration.CaptiveNetwork

// 网络接口
/*
 获取Wi-Fi名字信息
 网关 本机地址 子网掩码等
 */
/*
 [Swift3,Swift4 获取IP地址] https://blog.csdn.net/zxw_xzr/article/details/78225716
 [Swift3.0 Swift2.3 获取IP地址 获取网关地址] https://blog.csdn.net/zhang5690800/article/details/51984291
 [iOS开发，获取WIFI配置信息，WIFI名称、网关（路由器地址）、本机IP地址、DNS等] https://blog.csdn.net/u011439689/article/details/79571023
 */
/// 获取Wi-Fi相关信息
public class NetInterface: NSObject {
        
    /// 获取Wi-Fi信息
    @objc public static func getWifiInfo() -> [String: Any]? {
        
        if let ifs = CNCopySupportedInterfaces() as? [CFString] {
            for x in ifs {
                if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(x)) {
                    return dict as? [String : Any]
                }
            }
        }
        return nil
    }
            
    /// 获取Wi-Fi名字
    @objc public static func getSsid() -> String? {
        
        guard self.getWifiInfo() != nil else {
            return nil
        }
        // 返回Wi-Fi的名字信息
        return self.getWifiInfo()![String(kCNNetworkInfoKeySSID)] as? String
    }
    
    
    /// 获取Wi-Fi的当前地址
    @objc public static func getCurrent_IP_Address() -> String? {
                
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }
    
    //MARK: 获取当前Wi-Fi的SSID信息
    /// 获取当前Wi-Fi的SSID信息
    @objc public static func fetchSSIDInfo() -> String {
        let interfaces = CNCopySupportedInterfaces()
        var ssid = ""
        if interfaces != nil {
            let interfacesArray = CFBridgingRetain(interfaces) as! Array<AnyObject>
            if interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as! CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                    ssid = interfaceData["SSID"]! as! String
                }
            }
        }
        return ssid
    }
    
    /// 获取当前地址
    @objc public static func getCurrent_Mac() -> String {
        let interfaces = CNCopySupportedInterfaces()
        var bssid = ""
        if interfaces != nil {
            let interfacesArray = CFBridgingRetain(interfaces) as! Array<AnyObject>
            if interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as! CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                    bssid = interfaceData["BSSID"]! as! String
                }
            }
        }
        return bssid
    }
    
    //MARK: 获取当前默认网关gateway
    /// 获取当前默认gateway
    @objc public static func getDefaultGateway() -> String {
        // 摄像头配网 获取当前网关:192.168.1.1
        // 摄像头配网 获取当前IP地址:192.168.1.108
        
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        //swiftDebug("\(addresses)")
        
        let address = addresses.first
        var ad = address?.components(separatedBy: ".")
        if ad!.count >= 3 {
            ad![3] = "1" // 把最后一个元素改成1 变成192.168.1.1
        }
        return ad!.joined(separator: ".")
    }
    
    

    
    
    /// 获取bssid
    ///
    /// - Returns: bssid
    @objc public static func getWifiBssid() -> String? {
        return getWifiInfo()?[kCNNetworkInfoKeyBSSID as String] as? String
    }
    
    
    /// 获取wifi ssid
    ///
    /// - Returns: wifi的ssid
    @objc public static func getWifiSsid() -> String? {
        
        return getWifiInfo()?[kCNNetworkInfoKeySSID as String] as? String
    }
}
