//
//  Dictionary+Extension.swift
//  SwiftReLearn
//
//  Created by runlong on 2021/5/25.
//  Copyright © 2021 JoyTomi. All rights reserved.
//

import Foundation

extension Dictionary {
    
    /// 获取字典里的Bool值
    /// - Parameters:
    ///   - key: key
    ///   - defaultValue: 默认值
    public func tm_getBoolValueForKey(_ key: String,_ defaultValue: Bool) -> Bool {
        return tm_getValueForKey(key, defaultValue, Bool.self)
    }
    
    /// 获取字典里的Int值
    /// - Parameters:
    ///   - key: key
    ///   - defaultValue: 默认值
    public func tm_getIntValueForKey(_ key: String,_ defaultValue: Int) -> Int {
       return tm_getValueForKey(key, defaultValue, Int.self)
    }
    /// 获取字典里的Int64值
    /// - Parameters:
    ///   - key: key
    ///   - defaultValue: 默认值
    public func tm_getInt64ValueForKey(_ key: String,_ defaultValue: Int64) -> Int64 {
       return tm_getValueForKey(key, defaultValue, Int64.self)
    }
    /// 获取字典里的String值
    /// - Parameters:
    ///   - key: key
    ///   - defaultValue: 默认值
    public func tm_getStringValueForKey(_ key: String,_ defaultValue: String) -> String {
        return tm_getValueForKey(key, defaultValue, String.self)
    }
    
    /// 获取字典里的值 自定义类型
    /// - Parameters:
    ///   - key: key
    ///   - defaultValue: 默认值
    ///   - valueType: 值类型 String.self
    public func tm_getValueForKey<T>(_ key: String,_ defaultValue: T,_ valueType: T.Type) -> T {
        guard let dict:Dictionary<String,AnyObject> = self as? Dictionary<String,AnyObject> else {
            return defaultValue
        }
        guard let value = dict[key] as? T else {
            let value = "\(dict[key]!)"
            if valueType == Int.self {
                return value.tm_int as! T
            } else if valueType == Int64.self {
                return value.tm_int64 as! T
            } else if valueType == Double.self {
                return value.tm_double as! T
            } else if valueType == Float.self {
                return value.tm_float as! T
            } else if valueType == Bool.self {
                return value.tm_bool as! T
            } else if valueType == String.self {
                return value as! T
            } else {
                return defaultValue
            }
        }
        return value
    }
}
