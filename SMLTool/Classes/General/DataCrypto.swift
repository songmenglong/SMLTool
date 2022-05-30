//
//  DataCrypto.swift
//  SMLTool
//
//  Created by SongMenglong on 2019/5/7.
//  Copyright © 2019 magnum. All rights reserved.
//

import CommonCrypto

/// AES数据加密错误枚举类型
enum SymmetricCryptorError: Error {
    case missingIV
    case cryptOperationFailed
    case wrongInputData
    case unknownError
}

/*
 * 数据加密工具
 */
class DataCrypto: NSObject {
    /// 加密的key值 设置密钥值
    @objc public static let myKey = "test_crypto_key"
    
    /// AES数据加密
    @objc public static func aesEcbEncode( _ originalStr: String) -> String {
        let data = try! DataCrypto.crypt(string: originalStr, key: self.myKey)
        
        return data.base64EncodedString()
    }
    
    /// AES数据解密
    @objc public static func aesEcbDecode( _ encryptedStr: String) -> String {
        
        if let deData = Data(base64Encoded: encryptedStr) {
            let data = try! DataCrypto.decrypt(deData, key: self.myKey)
            
            if let decodeStr = String(data: data, encoding: String.Encoding.utf8) {
                //debugPrint("AES解密后的字符串内容:", decodeStr)
                if decodeStr.contains("\0") {
                    // 如果字符串中包含填充字符串 分割字符串
                    let decodeArray = decodeStr.components(separatedBy: "\0")
                    // 返回字符串第一个
                    return decodeArray.first!
                } else {
                    // 如果不包含填充字符串 直接返回字符串
                    return decodeStr
                }
            } else {
                return "" //解析出来的内容为空
            }
        } else {
            return "" // base64编码的内容为空
        }
    }
    
    /// 加密数据 传入string
    private static func crypt(string: String, key: String) throws -> Data {
        do {
            if let data = string.data(using: String.Encoding.utf8) {
                return try self.cryptoOperation(data, key: key, operation: CCOperation(kCCEncrypt))
            } else { throw SymmetricCryptorError.wrongInputData }
        } catch {
            throw(error)
        }
    }
    
    /// 加密数据 传入Data
    private static func crypt(data: Data, key: String) throws -> Data {
        do {
            return try self.cryptoOperation(data, key: key, operation: CCOperation(kCCEncrypt))
        } catch {
            throw(error)
        }
    }
    
    /// 解密方法
    private static func decrypt(_ data: Data, key: String) throws -> Data  {
        do {
            return try self.cryptoOperation(data, key: key, operation: CCOperation(kCCDecrypt))
        } catch {
            throw(error)
        }
    }
    
    /// 加密解密方法
    static internal func cryptoOperation(_ inputData: Data, key: String, operation: CCOperation) throws -> Data {
        
        guard let keyBytes = key.cString(using: String.Encoding.utf8)  else { // kCCKeySizeAES128 + 1 = keyPtr.count
            throw NSError(domain: "AES CCCrypt", code: kCCInvalidKey, userInfo: nil)
        }
        
        //let keyLength        = size_t(kCCKeySizeAES128) //  algorithm.requiredKeySize()
        // 输入数据长度
        let dataLength       = Int(inputData.count)
        // 输入数据内容
        let dataBytes        = inputData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        }
        
        var bufferData       = Data(count: Int(dataLength) + kCCBlockSizeAES128) // algorithm.requiredBlockSize()
        // 输出数据
        let bufferPointer    = bufferData.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return bytes
        }
        // 输出数据长度
        let bufferLength     = size_t(bufferData.count)
        var bytesDecrypted   = Int(0)
        // Perform operation
        let cryptStatus = CCCrypt(
            operation, // Operation 加解密方式(加密或解密)
            CCAlgorithm(kCCAlgorithmAES), // Algorithm kCCAlgorithmAES128
            CCOptions(kCCOptionPKCS7Padding + kCCOptionECBMode), // Options
            keyBytes, // key data 密钥数据
            size_t(kCCKeySizeAES128), // key length 密钥长度128
            nil, // IV buffer 偏移量数据 设置为空
            dataBytes, // input data 输入数据
            dataLength, // input length 输入长度
            bufferPointer, // output buffer 输出数据
            bufferLength, // output buffer length 输出长度
            &bytesDecrypted) // output bytes decrypted real length 解密数据实际长度
        if Int32(cryptStatus) == Int32(kCCSuccess) {
            bufferData.count = bytesDecrypted // Adjust buffer size to real bytes
            return bufferData as Data
        } else {
            debugPrint("Error in crypto operation: \(cryptStatus)")
            throw(SymmetricCryptorError.cryptOperationFailed)
        }
    }
    
    /// 字符串的MD5加密
    @objc public static func md5Crypto(str: String) -> String {
        let utf8_str = str.cString(using: .utf8)
        let str_len = CC_LONG(str.lengthOfBytes(using: .utf8))
        let digest_len = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digest_len)
        
        CC_MD5(utf8_str, str_len, result)
        
        let str = NSMutableString()
        for i in 0..<digest_len {
            str.appendFormat("%02x", result[i])
        }
        result.deallocate()
        
        return str as String
    }
}

