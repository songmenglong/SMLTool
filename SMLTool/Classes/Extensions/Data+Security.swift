//
//  Data+Security.swift
//  SMLTool
//
//  Created by SongMengLong on 2022/3/26.
//

import Foundation
import CommonCrypto

//public extension Data {
//    func encodedAES256(_ key: String, options: CCOptions = CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode), ivString: String? = nil) throws -> Data {
//        guard let keyPtr = key.cString(using: .utf8)  else { // kCCKeySizeAES128 + 1 = keyPtr.count
//            throw NSError(domain: "AES CCCrypt", code: kCCInvalidKey, userInfo: nil)
//        }
//        let values = self.bytes
//        let len = values.count
//        // 对于块加密算法：输出的大小<= 输入的大小 +  一个块的大小
//        let bufferSize = len+kCCBlockSizeAES128
//        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: bufferSize)
//        defer {
//            buffer.deallocate()
//        }
//        var bytesNum: Int = 0
//        let operation = CCOperation(kCCEncrypt)
//        let aes = CCAlgorithm(kCCAlgorithmAES128)
//        let iv = ivString?.cString(using: .utf8)
//        let cryptStatus = CCCrypt(operation,
//                                  aes,
//                                  options,
//                                  keyPtr,
//                                  kCCKeySizeAES128,
//                                  iv,
//                                  values,
//                                  len,
//                                  buffer,
//                                  bufferSize,
//                                  &bytesNum)
//         if cryptStatus == kCCSuccess {
//            return Data(bytes: buffer, count: bytesNum)
//         }
//        throw NSError(domain: "AES CCCrypt", code: kCCParamError, userInfo: nil)
//    }
//    
//    func decodedAES256(_ key: String, options: CCOptions = CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode), ivString: String? = nil) throws -> Data {
//        guard let keyPtr = key.cString(using: .utf8)  else { // kCCKeySizeAES128 + 1 = keyPtr.count
//            throw NSError(domain: "AES CCCrypt", code: kCCInvalidKey, userInfo: nil)
//        }
//        let values = self.bytes
//        let len = values.count
//        let bufferSize = len+kCCBlockSizeAES128
//        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: bufferSize)
//        defer {
//            buffer.deallocate()
//        }
//        var bytesNum: Int = 0
//        let operation = CCOperation(kCCDecrypt)
//        let aes = CCAlgorithm(kCCAlgorithmAES128)
//        let iv = ivString?.cString(using: .utf8)
//        let cryptStatus = CCCrypt(operation,
//                                  aes,
//                                  options,
//                                  keyPtr,
//                                  kCCKeySizeAES128,
//                                  iv,
//                                  values,
//                                  len,
//                                  buffer,
//                                  bufferSize,
//                                  &bytesNum)
//         if cryptStatus == kCCSuccess {
//            return Data(bytes: buffer, count: bytesNum)
//         }
//        throw NSError(domain: "AES CCCrypt", code: kCCDecodeError, userInfo: nil)
//    }
//
//    func encodedDES(_ key: String) throws -> Data {
//        guard let iv = key.cString(using: .utf8),
//            let ASCIIKey = key.cString(using: .ascii) else { // key.count == kCCKeySizeDES,
//            throw NSError(domain: "DES CCCrypt", code: kCCInvalidKey, userInfo: nil)
//        }
//        //let bytes = self.bytes
//        try self.withUnsafeBytes { dataBytes -> Void in
//            
//            let len = self.count
//            let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: len)
//            defer {
//                buffer.deallocate()
//            }
//            var bytesNum: Int = 0
//            let cryptStatus = CCCrypt(CCOperation(kCCEncrypt),
//                                      CCAlgorithm(kCCAlgorithmDES),
//                                      CCOptions(kCCOptionPKCS7Padding),
//                                      ASCIIKey,
//                                      kCCKeySizeDES,
//                                      iv,
//                                      dataBytes,
//                                      len,
//                                      buffer,
//                                      1024,
//                                      &bytesNum)
//            if cryptStatus == kCCSuccess {
//                return Data(bytes: buffer, count: bytesNum)
//            } else {
//                throw NSError(domain: "DES CCCrypt", code: kCCParamError, userInfo: nil)
//            }
//            
//        }
//        
//        
//    }
//    func decodedDES(_ key: String) throws -> Data {
//        guard let iv = key.cString(using: .utf8),
//            let ASCIIKey = key.cString(using: .ascii) else { // key.count == kCCKeySizeDES,
//            throw NSError(domain: "DES CCCrypt", code: kCCInvalidKey, userInfo: nil)
//        }
//        let bytes = self.bytes
//        let len = self.count
//        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: len)
//        defer {
//            buffer.deallocate()
//        }
//        var bytesNum: Int = 0
//        let cryptStatus = CCCrypt(CCOperation(kCCDecrypt),
//                                  CCAlgorithm(kCCAlgorithmDES),
//                                  CCOptions(kCCOptionPKCS7Padding),
//                                  ASCIIKey,
//                                  kCCKeySizeDES,
//                                  iv,
//                                  bytes,
//                                  len,
//                                  buffer,
//                                  1024,
//                                  &bytesNum)
//        if cryptStatus == kCCSuccess {
//            return Data(bytes: buffer, count: bytesNum)
//        } else {
//            throw NSError(domain: "DES CCCrypt", code: kCCDecodeError, userInfo: nil)
//        }
//    }
//}

