//
//  ModelConvert.swift
//  SMLTool
//
//  Created by SongMenglong on 2021/6/29.
//

import CleanJSON

/// 字典转换model工具类
public struct ModelDecoder {
    
        
    /// 字典解析返回模型
    /// - Parameters:
    ///   - type: 模型类名
    ///   - param: 字典
    /// - Throws: 泛型
    /// - Returns: 返回模型
    public static func decode<T>(_ type: T.Type, param: [String: Any]) throws -> T where T: Decodable {
        // 初始化变量
        var model: T?
//        do {
//            let jsonData = self.getJsonData(with: param)
//            model = try JSONDecoder().decode(type, from: jsonData!)
//        } catch {
//            model = nil
//            swiftDebug("参数内容~~~:", param)
//        }
        let decoder = CleanJSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        // 值为 null 或类型不匹配时解码策略
        //decoder.valueNotFoundDecodingStrategy = .custom(CustomAdapter())
        // JSON 字符串转对象解码策略
        decoder.jsonStringDecodingStrategy = .all
              
        let jsonData = self.getJsonData(with: param)
        
        model = try decoder.decode(type, from: jsonData!)
        
        return model!
    }
    
    
    /// 字典数组解析返回模型数组
    /// - Parameters:
    ///   - type: 模型名字
    ///   - array: 字典数组
    /// - Throws: 泛型
    /// - Returns: 模型数组
    public static func decode<T>(_ type: T.Type, array: [[String: Any]]) throws -> [T] where T: Decodable {
        let data = self.getJsonData(with: array)
        
        let models = try JSONDecoder().decode([T].self, from: data!)
        
        return models
    }
    
    
    /// 获取JSON Data数据
    /// - Parameter param: 任意类型
    /// - Returns: Data数据
    private static func getJsonData(with param: Any) -> Data? {
        if !JSONSerialization.isValidJSONObject(param) {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else { return nil }
        
        return data
    }
}

/// 模型转字典/字符串
public struct ModelEncoder {
    /*
     https://www.jianshu.com/p/b058369efd09
     */
    
    
    /// 模型转字符串
    /// - Parameter model: 模型
    /// - Returns: 字符串
    public static func encoder<T>(toString model: T) -> String? where T: Encodable {
        let encoder = JSONEncoder()
        // //输出格式好看点
        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(model) else { return nil }
        
        guard let jsonStr = String(data: data, encoding: String.Encoding.utf8) else { return nil }
        
        // 返回json字符串
        return jsonStr
    }
        
    
    /// 模型转字典
    /// - Parameter model: 模型
    /// - Returns: 字典
    public static func encoder<T>(toDictionary model: T) -> [String: Any]? where T: Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = JSONEncoder.OutputFormatting.prettyPrinted
        
        guard let data = try?encoder.encode(model) else { return nil }
        
        guard let dict = ((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any]) as [String : Any]??) else { return nil }
        
        // 返回字典
        return dict
    }
    
    
    /// 模型数组转字典数组
    /// - Parameter models: 模型数组
    /// - Returns: 字典数组
    public static func encoder<T>(toDictionaryArray models: [T]) -> [[String: Any]]? where T: Encodable {
        var arrayDict: [[String: Any]] = [[String: Any]]()
        for model in models {
            arrayDict.append(self.encoder(toDictionary: model)!)
        }
        // 返回字典
        return arrayDict
    }
}

extension KeyedDecodingContainer {
    // 重新实现decodeIfPresent，在解析失败时返回nil而不是抛出错误导致整个解析失败：
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        return try? decode(type, forKey: key)
    }
}
