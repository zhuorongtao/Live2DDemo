//
//  FxGlobal.swift
//  Uber
//
//  Created by apple on 16/1/9.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
import UIKit

func FxLog(message: String, function: String = __FUNCTION__) {
    //在Build Setting中的Other Swif Flags增加-D DEBUG
    #if DEBUG
        print("Log: \(message), \(function)")//__FUNCTION__标示哪个函数输出的日志
    #else
        
    #endif
}