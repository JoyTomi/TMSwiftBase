//
//  String+Extension.swift
//  SwiftReLearn
//
//  Created by runlong on 2021/5/24.
//  Copyright © 2021 JoyTomi. All rights reserved.
//

import Foundation
import CommonCrypto
import UIKit
extension String {
    
    func tm_trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func tm_at(_ index: String.IndexDistance) -> String.Index {
        
        return self.index(self.startIndex, offsetBy: index)
    }
    
    /**
     根据时长格式化输出
     - parameter duration: 单位(秒)
     - returns: 返回格式化后的时长
     */
    func tm_getFormatterDuration(_ duration: Int) -> String {
        let hour = duration / 3600
        let minute = (duration - hour * 3600) / 60
        if hour <= 0 {
            return "\(minute)分钟"
        }
        if minute <= 0 {
            return "\(hour)小时"
        }
        return "\(hour)小时\(minute)分钟"
    }
    
    /**
     根据时长格式化输出
     - parameter duration: 单位(秒)
     - returns: 返回格式化后的时长
     */
    func tm_getFormatterDurationToMS(_ duration: Int) -> String {
        let hour = duration / 3600
        let minute = (duration - hour * 3600) / 60
        let second = (duration - hour * 3600 - minute * 60)
        return String(format: "%02d:%02d:%02d", hour, minute,second)
    }
    
    /// 获取本地化字符串
    /// - Returns: 本地化字符串
    func tm_localized() -> String {
        return NSLocalizedString(self, comment: self)
    }
    
    /// 获取字符串高度
    /// - Parameters:
    ///   - font: 字体大小
    ///   - width: 宽度
    func tm_getHeigh(font: UIFont , width: CGFloat) -> CGFloat {
        let statusLabelText: String = self
        let size =  CGSize(width: width, height: 900)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : AnyObject], context:nil).size
        
        return strSize.height
    }
    
    /// 获取字符串宽度
    /// - Parameters:
    ///   - font: 字体
    ///   - height: 高度
    func tm_getWidth(font: UIFont, height: CGFloat) -> CGFloat {
        let statusLabelText: String = self
        let size = CGSize(width: 900, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : AnyObject], context:nil).size
        
        return strSize.width
    }
    //使用正则表达式替换
    func tm_pregReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
        
    }
    
    
    ///判断如果包含中文
    func tm_containChinese() -> Bool {
        for i in 0..<self.count {
            let a = (self as NSString).character(at: i)
            if a > 0x4e00 && a < 0x9fff {
                return true
            }
        }
        return false
    }
    
    ///判断输入框是否包含空格
    func containSpace() -> Bool {
        let str = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return str == self
    }
    
    ///判断输入框是否圈空格
    func isSpaceAll() -> Bool {
        let str = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return str.count == 0
    }
    
    //    数字转汉字
    static func transforNumberToString(num:NSNumber)->String{
        let formatter = NumberFormatter()
        let locale = Locale.init(identifier: "zh_Hans")
        formatter.numberStyle = .spellOut
        formatter.locale = locale
        let string = formatter.string(from: num)
        return string ?? ""
    }
}
// 处理HTML
extension String {
    
    /// 去掉某个标签
    /// - Parameter tag: 标签名称
    func tm_deleteHTMLTag(tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
    
    /// 去掉多个标签
    /// - Parameter tags: 标签数组
    func tm_deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.tm_deleteHTMLTag(tag: tag)
        }
        return mutableString
    }
    
    ///去掉z所有标签
    mutating func tm_filterHTML() -> String?{
        let scanner = Scanner(string: self)
        var text: String?
        while !scanner.isAtEnd {
            text = scanner.scanUpToString("<")
            text = scanner.scanUpToString(">")
            self = self.replacingOccurrences(of: "\(text == nil ? "" : text!)>", with: "")
        }
        // 去除调空格
        self = self.replacingOccurrences(of: "&nbsp;", with: "")
        return self
    }
}
// 编码转换
extension String {
    /// 获取String的md5字符串
    func tm_toMD5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        return String(hash)
    }
    
    /// base64编码
    func tm_toBase64() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    /// base64解码
    func tm_fromBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
// 转换
extension String {
    public var tm_bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return self.count > 0
        }
    }
    public var tm_int: Int? {
        return Int(self)
    }
    public var tm_int64: Int64? {
        return Int64(self)
    }
    public var tm_float: Float? {
        return Float(self)
    }
    public var tm_double: Double? {
        return Double(self)
    }
}
