//
//  HaruViewController.swift
//  Live2DDemo
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class HaruViewController: DaiLive2DViewController {
    
    var isEyeClosing     = false
    var eyeSpeed: Double = 0
    
    //MARK: - 构造方法
    init() {
        super.init(fromBundlePath: "/Haru/model.plist")
    }
 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - 重写父类必须实现的方法
    //人物模型渲染
    override func defaultModelSetting(loader: Live2DInfoLoader!) {
        loader.parameter["PARAM_EYE_L_SMILE"].value = 1.0
        loader.parameter["PARAM_EYE_R_SMILE"].value = 1.0
        loader.parameter["PARAM_ARM_L_A"].value     = -1.0
        loader.parameter["PARAM_ARM_R_A"].value     = -1.0
        loader.part["PARTS_01_ARM_L_B_001"].value   = 0
        loader.part["PARTS_01_ARM_R_B_001"].value   = 0
        self.isEyeClosing = false
    }
    
    //人物动作渲染
    override func animateModelSetting(loader: Live2DInfoLoader!, onTime time: UInt64) {
        //必须这样写, 不能先用time/1000先, 如果这样做会忽略小数部分从而使动画生硬
        let globalTime = Double(time) / 1000 //摇摆频率(除数越大, 摇摆越慢(即1000))
        //设置总视角
        loader.parameter["PARAM_ANGLE_Z"].value      = 30 * sin(globalTime)
        //设置身体视角
        loader.parameter["PARAM_BODY_ANGLE_Z"].value = 10 * sin(globalTime)
        //设置前头发
        loader.parameter["PARAM_HAIR_FRONT"].value   = sin(globalTime)
        //设置后头发
        loader.parameter["PARAM_HAIR_BACK"].value    = sin(globalTime)
        //设置呼吸率
        loader.parameter["PARAM_BREATH"].value       = (cos(globalTime) + 1) / 2
        //设置胸部Y坐标
        loader.parameter["PARAM_BUST_Y"].value       = cos(globalTime)
        
        if (sin(globalTime) + 1) >= 1.9 && !self.isEyeClosing {//眼睛睁开则使眼睛闭合
            self.isEyeClosing = true
            self.eyeSpeed = Double(arc4random()) % 200 + 100 //盏眼频率
        }else if self.isEyeClosing {//如果是闭眼(图像眼睛任然睁开)则让眼睛闭合, 设睁开幅度
            let eyeTime = Double(time) / self.eyeSpeed
            //设置左右眼睁开的幅度
            loader.parameter["PARAM_EYE_L_OPEN"].value = sin(eyeTime) + 1
            loader.parameter["PARAM_EYE_R_OPEN"].value = sin(eyeTime) + 1
            
            if (sin(eyeTime) + 1) >= 1.9 { //若睁开幅度大于sin(eyeTime) + 1, 则认为眼睛睁开
                self.isEyeClosing = false
            }
        }
    }
}
