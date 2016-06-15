//
//  Live2DPart.swift
//  Live2DDemo
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

protocol Live2DPartDelegate {
    func setValue(value: Double, forPart part: String)
    func valueForPart(part: String) -> Double
}

class Live2DPart: NSObject, Live2DPartValueDelegate {
    var delegate: Live2DPartDelegate?
    
    private struct temps {
        static var onceCacheToken: dispatch_once_t = 0 //标识符
        static var onceShardToken: dispatch_once_t = 0
    }
    
    static func shard() -> Live2DPart {
        dispatch_once(&temps.onceShardToken) { () -> Void in
            objc_setAssociatedObject(self, __FUNCTION__, Live2DPart(), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        guard let part = objc_getAssociatedObject(self, __FUNCTION__) as? Live2DPart else {
            print("shard获取错误")
            fatalError()
        }
        
        return part
    }
    
    static func cacheForPartValue(part: String) -> Live2DPartValue? {
        //保证方法体里面的代码只能被运行一次
        dispatch_once(&temps.onceCacheToken) { () -> Void in
            var cacheTable: NSMutableDictionary = [:]
            objc_setAssociatedObject(self, __FUNCTION__, cacheTable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
//         as? [String : Live2DPartValue]
        guard let partValue = objc_getAssociatedObject(self, __FUNCTION__) else {
            FxLog("cacheForPartValue获取错误")
            fatalError()
        }
        
        return partValue[part]
    }
    
    ///自定义订阅键(通过下标获取Live2DPartValue实例)
//    func objectForKeyedSubscript(part: String) -> Live2DPartValue {
//        var parameterValue = Live2DPart.cacheForPartValue(part)
//        if parameterValue == nil {
//            parameterValue = Live2DPartValue(part: part)
//            parameterValue?.delegate = self
//        }
//        return parameterValue!
//    }
    
    subscript(part: String) -> Live2DPartValue {
        var parameterValue = Live2DPart.cacheForPartValue(part)
        if parameterValue == nil {
            parameterValue = Live2DPartValue(part: part)
            parameterValue?.delegate = self
        }
        return parameterValue!
    }
    
    //MARK: - Live2DPartValueDelegate代理方法实现
    ///改变part值
    func setValue(value: Double, forPart part: String) {
        self.delegate?.setValue(value, forPart: part)
    }
    
    ///获得当前part值
    func valueForPart(part: String) -> Double {
        if self.delegate == nil {
            FxLog("Live2DPartDelegate为空")
        }
        return self.delegate!.valueForPart(part)
    }
}
