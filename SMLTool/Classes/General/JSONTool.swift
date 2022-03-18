//
//  JsonString.swift
//  SMLTool
//
//  Created by SongMenglong on 2019/6/19.
//  Copyright © 2019 magnum. All rights reserved.
//

import UIKit

/// JSON字符串转换类
public class JSONTool: NSObject {
        
    /// JSON字符串转数组
    /// - Parameter jsonStirng: JSON字符串
    /// - Returns: 数组(类型[Any])
    @objc public static func translationJsonToArray(from jsonStirng: String) -> [Any]? {
        return translationJsonToObjc(from: jsonStirng) as? [Any]
    }

    /// JSON字符串转字典
    /// - Parameter jsonStirng: JSON字符串
    /// - Returns: 字典(类型[String : Any])
    @objc public static func translationJsonToDic(from jsonStirng: String) -> [String : Any]? {
        guard let data = translationJsonToObjc(from: jsonStirng)  else {
            return nil
        }
        return data as? [String : Any]
    }
        
    /// JSON字符串转对象
    /// - Parameter jsonStirng: JSON字符串
    /// - Returns: 对象(类型Any)
    @objc public static func translationJsonToObjc(from jsonStirng: String) -> Any? {
        guard let data = jsonStirng.data(using: .utf8) else {
            return nil
        }
        do {
            let obj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return obj
        } catch {
            debugPrint("error: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    /// 任意类型对象转JSON字符串
    /// - Parameter obj: 任意类型对象
    /// - Returns: JSON字符串
    @objc public static func translationObjToJson(from obj: Any) -> String?{
        if JSONSerialization.isValidJSONObject(obj) == false {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: obj, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            let jsonString = String.init(data: data, encoding: .utf8)
            return jsonString
        } catch {
            debugPrint("error: \(error.localizedDescription)")
            return nil
        }
    }
}
