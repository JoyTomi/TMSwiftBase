//
//  Array+Extension.swift
//  SwiftReLearn
//
//  Created by runlong on 2021/5/24.
//  Copyright © 2021 JoyTomi. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    /// 移除指定元素
    /// - Parameter object: 指定元素
    mutating func tm_remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}

extension Array {
    
    /// 根据范围获取数组
    /// - Parameter range: 数组范围
    public func tm_get(at range: ClosedRange<Int>) -> Array {
        let halfOpenClampedRange = Range(range).clamped(to:indices)
        return Array(self[halfOpenClampedRange])
    }
    /// 判断数组是否包含给定元素的类型
    /// - Parameter element: 给定元素
    public func tm_containsType<T>(of element: T) -> Bool {
        let elementType = type(of: element)
        return contains { type(of: $0) == elementType}
    }
    /// 将数组分解为包含第一个元素和其他元素的元组
    public func tm_decompose() -> (head: Iterator.Element, tail: SubSequence)? {
        return (count > 0) ? (self[0], self[1..<count]) : nil
    }
    /// 对数组的每个元素及其索引进行迭代
    /// - Parameter body: (指数、元素)
    public func tm_forEachEnumerated(_ body: @escaping (_ offset: Int, _ element: Element) -> Void) {
        enumerated().forEach(body)
    }
    /// 获取指定索引处的对象(如果它存在)
    /// - Parameter index: 索引
    public func tm_get(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    /// 将对象添加到数组第一个
    /// - Parameter newElement: 新元素
    public mutating func tm_insertFirst(_ newElement: Element) {
        insert(newElement, at: 0)
    }
    /// 从数组中返回一个随机元素
    public func tm_random() -> Element? {
        guard count > 0 else { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
    /// 反转给定的索引  i.g.: reverseIndex(2) would be 2 to the last
    /// - Parameter index: 索引
    public func tm_reverseIndex(_ index: Int) -> Int? {
        guard index >= 0 && index < count else { return nil }
        return Swift.max(count - 1 - index, 0)
    }
    /// 打乱数组的位置 Fisher-Yates-Durstenfeld algorithm
    public mutating func tm_shuffle() {
        guard count > 1 else { return }
        var j: Int
        for i in 0..<(count-2) {
            j = Int(arc4random_uniform(UInt32(count - i)))
            if i != i+j { self.swapAt(i, i+j) }
        }
    }
    /// 打乱复制的数组，返回打乱的数组 Fisher-Yates-Durstenfeld algorithm
    public func tm_shuffled() -> Array {
        var result = self
        result.shuffle()
        return result
    }
    /// 返回一个数组，该数组中元素的最大数目为给定的数字
    /// - Parameter n: 数量
    public func tm_takeMax(_ n: Int) -> Array {
        return Array(self[0..<Swift.max(0, Swift.min(n, count))])
    }
    /// 检查数组中所有元素是否为true
    /// - Parameter body: <#body description#>
    public func tm_testAll(_ body: @escaping (Element) -> Bool) -> Bool {
        return !contains { !body($0) }
    }
    /// 检查数组中所有元素是否为true或者false
    /// - Parameter condition: <#condition description#>
    public func tm_testAll(is condition: Bool) -> Bool {
        return tm_testAll { ($0 as? Bool) ?? !condition == condition }
    }
}

extension Array where Element: Equatable {
    
    /// 检查数组是否包含给定数组
    /// - Parameter array: 数组
    public func tm_contains(_ array: [Element]) -> Bool {
        return array.tm_testAll { self.firstIndex(of: $0) ?? -1 >= 0 }
    }
    /// 检查数组是否包含给定的元素列表
    /// - Parameter elements: 元素列表
    public func tm_contains(_ elements: Element...) -> Bool {
        return elements.tm_testAll { self.firstIndex(of: $0) ?? -1 >= 0 }
    }
    /// 移除第一个给定的元素
    /// - Parameter element: 元素
    public mutating func tm_removeFirst(_ element: Element) {
        guard let index = firstIndex(of: element) else { return }
        self.remove(at: index)
    }
    /// 删除给定对象的所有匹配项，至少需要一个项
    /// - Parameters:
    ///   - firstElement: 第一个
    ///   - elements: 列表
    public mutating func tm_removeAll(_ firstElement: Element?, _ elements: Element...) {
        var removeAllArr = [Element]()
        
        if let firstElementVal = firstElement {
            removeAllArr.append(firstElementVal)
        }
        
        elements.forEach({element in removeAllArr.append(element)})
        
        tm_removeAll(removeAllArr)
    }
    /// 删除给定对象的所有匹配项
    /// - Parameter elements: 给定对象
    public mutating func tm_removeAll(_ elements: [Element]) {
        // COW ensures no extra copy in case of no removed elements
        self = filter { !elements.contains($0) }
    }
    /// self和输入数组的区别
    /// - Parameter values: 数组
    public func tm_difference(_ values: [Element]...) -> [Element] {
        var result = [Element]()
        elements: for element in self {
            for value in values {
                //  if a value is in both self and one of the values arrays
                //  jump to the next iteration of the outer loop
                if value.contains(element) {
                    continue elements
                }
            }
            //  element it's only in self
            result.append(element)
        }
        return result
    }
    /// self和输入数组的交集
    /// - Parameter values: 数组
    public func tm_intersection(_ values: [Element]...) -> Array {
        var result = self
        var intersection = Array()
        
        for (i, value) in values.enumerated() {
            //  the intersection is computed by intersecting a couple per loop:
            //  self n values[0], (self n values[0]) n values[1], ...
            if i > 0 {
                result = intersection
                intersection = Array()
            }
            
            //  find common elements and save them in first set
            //  to intersect in the next loop
            value.forEach { (item: Element) -> Void in
                if result.contains(item) {
                    intersection.append(item)
                }
            }
        }
        return intersection
    }
    /// self和输入数组的并集
    /// - Parameter values: 输入数组
    public func tm_union(_ values: [Element]...) -> Array {
        var result = self
        for array in values {
            for value in array {
                if !result.contains(value) {
                    result.append(value)
                }
            }
        }
        return result
    }
    /// 返回一个由数组中唯一元素组成的数组
    public func tm_unique() -> Array {
        return reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }
}
