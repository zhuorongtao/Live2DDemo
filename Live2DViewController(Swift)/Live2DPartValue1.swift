//
//  Live2DPartValue.swift
//  Live2DDemo
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

protocol Live2DPartValueDelegate {
    func setValue(value: Double, forPart part: String)
    func valueForPart(part: String) -> Double
}

class Live2DPartValue1: NSObject {
    var delegate: Live2DPartValueDelegate?
    
    var part: String
    
    var value: Double {
        get {
            FxLog("Live2DPartValueDelegate没设置")
            return self.delegate!.valueForPart(self.part)
        }
        set {
            self.delegate?.setValue(newValue, forPart: self.part)
        }
    }
    
    init(part: String) {
        self.part = part
    }
}
