//
//  GCDTools.swift
//  SMLTool
//
//  Created by SongMenglong on 2019/4/28.
//  Copyright © 2019 magnum. All rights reserved.
//

import UIKit

///  GCD功能
class GCDTools: NSObject {
    
    // MARK: GCD定时器循环操作
    /// GCD定时器循环操作
    ///
    /// - Parameters:
    ///   - timeInterval: 循环时间间隔
    ///   - repeatCount: 重复次数 -1或0时永远重复
    ///   - handler: 循环事件, 闭包参数： 1. timer， 2. 剩余执行次数
    static func DispatchTimer(timeInterval: Double, repeatCount:Int, handler:@escaping (DispatchSourceTimer?, Int)->()) {
        // 当次数为小于等于0 返回
        //if repeatCount <= 0 {
            //return
        //}
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        var count = repeatCount
        timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: timeInterval)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                handler(timer, count)
            }
            if count == 0 {
                timer.cancel()
            }
        })
        timer.resume()
    }
    
    
    // MARK: GCD延时操作
    /// GCD延时操作
    ///
    /// - Parameters:
    ///   - after: 延迟的时间
    ///   - handler: 事件
    static func DispatchAfter(after: Double, handler:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + after) {
            handler()
        }
    }
}
