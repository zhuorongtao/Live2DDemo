//
//  Live2DParameter.swift
//  Live2DDemo
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

protocol Live2DParameterDelegate {
    func infoForParameter(parameter: String) -> NSDictionary?
    func setValue(value: Double, forParameter parameter: String)
    func valueForParameter(parameter: String) -> Double
}

class Live2DParameter: NSObject, Live2DParameterValueDelegate {
    var delegate: Live2DParameterDelegate?
    
    private struct temps {
        static var onceCacheToken: dispatch_once_t = 0 //标识符
        static var onceShardToken: dispatch_once_t = 0
    }
    
    ///获取Live2DParameter实例
    static func shard() -> Live2DParameter {
        dispatch_once(&temps.onceShardToken) { () -> Void in
            objc_setAssociatedObject(self, __FUNCTION__, Live2DParameter(), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        guard let part = objc_getAssociatedObject(self, __FUNCTION__) as? Live2DParameter else {
            print("shard获取错误")
            fatalError()
        }
        
        return part
    }
    
    ///缓冲获取调用过的值
    static func cacheForParameterValue(parameter: String) -> Live2DParameterValue? {
        //保证方法体里面的代码只能被运行一次
        dispatch_once(&temps.onceCacheToken) { () -> Void in
            var cacheTable: NSMutableDictionary = [:]
            objc_setAssociatedObject(self, __FUNCTION__, cacheTable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
//        as? [String : Live2DParameterValue]
        guard let parameterValue = objc_getAssociatedObject(self, __FUNCTION__) else {
            FxLog("cacheForPartValue获取错误")
            fatalError()
        }
        return parameterValue[parameter]
    }
    
    //MARK: - Live2DParameterValueDelegate代理的实现
    func setValue(value: Double, forParameter parameter: String) {
        self.delegate?.setValue(value, forParameter: parameter)
    }
    
    func valueForParameter(parameter: String) -> Double {
        if self.delegate == nil {
            FxLog("Live2DParameterDelegate没设置")
        }
        return self.delegate!.valueForParameter(parameter)
    }
    
    ///设置下标获取Live2DParameterValue
    subscript(parameter: String) -> Live2DParameterValue {
        var parameterValue = Live2DParameter.cacheForParameterValue(parameter)
        if parameterValue == nil {
            if let info = self.delegate?.infoForParameter(parameter) {
                if let max = info["Max"] as? Double, min = info["Min"] as? Double {
                    parameterValue = Live2DParameterValue(parameter: parameter, max: max, min: min)
                }else {
                    FxLog("info的值不是Double")
                }
                parameterValue?.delegate = self
            }else {
                print("Live2DParameterDelegate没赋值")
            }
        }
        return parameterValue!
    }
}
