//
//  ReachableTool.swift
//  SMLTool
//
//  Created by SongMenglong on 2020/11/25.
//  Copyright © 2020 magnum. All rights reserved.
//

import UIKit
import RealReachability

/// 网络状态判断工具
public class ReachableTool: NSObject {

    /// 创建单例
    @objc public static let share: ReachableTool = {
        let share = ReachableTool()
        return share
    }()
    /// 工具类
    private var reachability: RealReachability = {
        let reachability: RealReachability = RealReachability.sharedInstance()
        reachability.hostForPing = "baidu.com"
        reachability.hostForCheck = "captive.apple.com"
        reachability.pingTimeout = 1.0
        reachability.autoCheckInterval = 0.3
        return reachability
    }()
    /// 是否网络可达 默认有网
    @objc public var reachable: Bool = true
    /// 当前网络类型
    @objc public var netType: String = String()
    
    /// 初始化方法
    override init() {
        super.init()

    }

    /// 开始监听网络
    @objc public func startNotifier() -> Void {
        // 开始Ping网络请求
        self.pingTimer()
        
        // 当前网络状态
        self.reachability.reachability { (status) in
            switch status {
            case ReachabilityStatus.RealStatusNotReachable:
                debugPrint("当前网络状态 网络不可用")
                self.reachable = false
                self.netType = ReachableType.unable
                break
            case ReachabilityStatus.RealStatusUnknown:
                debugPrint("当前网络状态 网络未知")
                self.reachable = false
                self.netType = ReachableType.unknown
                break
            case ReachabilityStatus.RealStatusViaWWAN:
                debugPrint("当前网络状态 蜂窝煤网络")
                self.reachable = true
                self.netType = ReachableType.wwan
                break
            case ReachabilityStatus.RealStatusViaWiFi:
                debugPrint("当前网络状态 Wi-Fi网络")
                self.reachable = true
                self.netType = ReachableType.wifi
                break
            default:
                debugPrint("当前网络状态 其他状态")
                self.reachable = false
                //self.netType = ReachableType.unable
                break
            }
        }
        // 添加网络状态通知通知
        // kRealReachabilityChangedNotification
        NotificationCenter.default.addObserver(self, selector: #selector(netStatuschanged(_:)), name: NSNotification.Name.realReachabilityChanged, object: self.reachability)
        // kRRVPNStatusChangedNotification
        NotificationCenter.default.addObserver(self, selector: #selector(vpnStatusChanged(_:)), name: NSNotification.Name.rrvpnStatusChanged, object: self.reachability)
        // 开始监听
        self.reachability.startNotifier()
    }

    /// 停止监听
    @objc public func stopNotifier() -> Void {
        // 停止监听
        self.reachability.stopNotifier()
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }

    /// 网络状态判断
    @objc func netStatuschanged(_ noti: Notification) -> Void {
        let reachability = noti.object as! RealReachability
        let status = reachability.currentReachabilityStatus()
        
        switch status {
        case ReachabilityStatus.RealStatusNotReachable:
            debugPrint("网络状态改变::: 不可用")
            // 清空局域网设备列表
            self.reachable = false
            self.netType = ReachableType.unable
            break
        case ReachabilityStatus.RealStatusViaWiFi:
            debugPrint("网络状态改变::: Wi-Fi")
            self.reachable = true
            self.netType = ReachableType.wifi
            break
        case ReachabilityStatus.RealStatusViaWWAN:
            debugPrint("网络状态改变::: 蜂窝煤网络")
            // 清空局域网设备列表
            self.reachable = true
            self.netType = ReachableType.wwan
            break
        case ReachabilityStatus.RealStatusUnknown:
            debugPrint("网络状态改变::: 未知状态")
            self.reachable = false
            self.netType = ReachableType.unknown
            break
        default:
            self.reachable = false
            debugPrint("网络状态改变::: 其他状态")
            break
        }

    }

    /// VPN网络状态判断
    @objc func vpnStatusChanged(_ noti: Notification) -> Void {
        debugPrint("VPN状态变化:::", noti.object as Any)

        let reachability = noti.object as! RealReachability
        debugPrint("当前网络状态:: ", reachability.currentReachabilityStatus())
    }
    
    /// 单独PING网络请求
    private func pingTimer() -> Void {
        // 创建定时器多线程
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        var count = 0 // 0/-1时 定时器不停止
        timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: 20)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                // Ping网络请求
                self.pingRequest()
            }
            if count == 0 {
                timer.cancel()
            }
        })
        // 启动定时器
        timer.resume()
    }
    
    /// 开始ping网络请求
    private func pingRequest() -> Void {
        
        if let pingUrl = URL(string: "https://www.baidu.com") {
            let request = URLRequest(url: pingUrl)
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            let task = session.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    //swiftDebug("请求错误::: ", error as Any)
                    DispatchQueue.main.async {
                        // 网络异常
                        self.reachable = false
                        self.netType = ReachableType.unable
                    }
                    return
                }
                //swiftDebug("请求内容数据: ", data as Any, response as Any, error as Any)
                DispatchQueue.main.async {
                    // 网络正常
                    self.reachable = true
                    // 默认Wi-Fi模式
                    self.netType = ReachableType.wifi
                }
            }
            // 启动请求任务
            task.resume()
        }
    }
}

/// 当前网络状态类型
struct ReachableType {
    /// Wi-Fi类型
    static let wifi = "wifi"
    /// 蜂窝煤
    static let wwan = "wwan"
    /// 不可用
    static let unable = "unable"
    /// 未知类型
    static let unknown = "unknown"
}
