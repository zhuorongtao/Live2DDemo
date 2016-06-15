//
//  Live2DParameterValue.swift
//  Live2DDemo
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

protocol Live2DParameterValueDelegate {
    func setValue(value: Double, forParameter parameter: String)
    func valueForParameter(parameter: String) -> Double
}

class Live2DParameterValue: NSObject {
    var delegate: Live2DParameterValueDelegate?
    var parameter: String
    var max: Double
    var min: Double
    
    ///改变parameter值, 取得parameter值
    var value: Double {
        get {
            if self.delegate == nil {
                print("Live2DParameterValueDelegate没设置")
            }
            return self.delegate!.valueForParameter(self.parameter)
        }
        set {
            self.delegate?.setValue(newValue, forParameter: self.parameter)
        }
    }
    
    init(parameter: String, max: Double, min: Double) {
        self.parameter = parameter
        self.max = max
        self.min = min
        super.init()
    }
}
