//
//  DateFormatter+Extension.swift
//  SwiftReLearn
//
//  Created by runlong on 2021/5/24.
//  Copyright © 2021 JoyTomi. All rights reserved.
//

import Foundation

let sharedInstanceDate = DateFormatter()
extension DateFormatter {
    
    public struct TMDatePattern {
        static let FullDateTime = "yyyy-MM-dd HH:mm:ss"
        static let MDHM = "MM-dd HH:mm"
        static let YMD = "yyyy-MM-dd"
        static let HMS = "HH:mm:ss"
        static let HM = "HH:mm"
        static let YMDHM = "yyyy-MM-dd HH:mm"
        static let Default = TMDatePattern.FullDateTime
    }
    
    /// 根据时间戳换算成时间
    ///
    /// - Parameters:
    ///   - timestamp: 时间戳
    ///   - pattern: 换算的格式dateFormat
    /// - Returns: 时间字符
    public static func tm_stringFromTimestamp(_ timestamp: TimeInterval, pattern: String?) -> String {
        if pattern != nil {
            sharedInstanceDate.dateFormat = pattern
        } else {
            sharedInstanceDate.dateFormat = TMDatePattern.Default
        }
        return sharedInstanceDate.string(from: Date(timeIntervalSince1970: timestamp))
    }
    
    /// 时间字符转成时间格式
    ///
    /// - Parameters:
    ///   - string: 时间字符
    ///   - pattern: 换算的格式dateFormat
    /// - Returns: 返回时间
    public static func tm_dateFromString(_ string: String, pattern: String) -> Date? {
        sharedInstanceDate.dateFormat = pattern
        return sharedInstanceDate.date(from: string)
    }
    
    /// 快速根据时间戳生成时间字符
    ///
    /// - Parameter timestamp: 时间戳
    /// - Returns: 时间字符
    public static func tm_stringFromTimestamp(_ timestamp: TimeInterval) -> String {
        return tm_stringFromTimestamp(timestamp, pattern: TMDatePattern.Default)
    }
    
    public static func tm_getFormatterDate(_ dateString: String?, pattern: String) -> (String) {
        var formatterDateString = ""
        
        if dateString == nil {
            return formatterDateString
        }
        
        sharedInstanceDate.dateFormat = pattern
        let date = sharedInstanceDate.date(from: dateString!)
        
        if date == nil {
            return formatterDateString
        }
        
        sharedInstanceDate.dateFormat = "MM月dd日"
        formatterDateString = sharedInstanceDate.string(from: date!)
        
        return formatterDateString
    }
    
    /// 根据date时间格式判断星期
    ///
    /// - Parameters:
    ///   - dateString: 传入的时间字符 不传返回“”
    ///   - pattern: 换算的格式dateFormat
    /// - Returns: 生成的星期
    public static func tm_getWeekDay(dateString: String?, pattern: String) -> (String) {
        var weekDay = ""
        guard dateString != nil else {
            return weekDay
        }
        
        sharedInstanceDate.dateFormat = pattern
        guard let date = sharedInstanceDate.date(from: dateString!) else {
            return weekDay
        }
        
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.weekday, from: date)
        
        switch dateComponent.weekday! {
        case 1:
            weekDay = "周日"
        case 2:
            weekDay = "周一"
        case 3:
            weekDay = "周二"
        case 4:
            weekDay = "周三"
        case 5:
            weekDay = "周四"
        case 6:
            weekDay = "周五"
        case 7:
            weekDay = "周六"
        default:
            break
        }
        
        return weekDay
    }
   
}

