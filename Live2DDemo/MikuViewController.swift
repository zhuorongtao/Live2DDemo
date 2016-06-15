//
//  MikuViewController.swift
//  Live2DDemo
//
//  Created by apple on 16/1/30.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class MikuViewController: DaiLive2DViewController {

    var isEyeClosing     = false
    var eyeSpeed: Double = 0
    
    //MARK: - 构造方法
    init() {
        super.init(fromBundlePath: "/Miku/model.plist")
    }
    
    //swift继承viewController必须重写的方法
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - 重写父类必须实现的方法
    //人物模型渲染
    override func defaultModelSetting(loader: Live2DInfoLoader!) {
        loader.parameter["PARAM_EYE_L_SMILE"].value  = 1
        loader.parameter["PARAM_EYE_R_SMILE"].value  = 1
        loader.parameter["PARAM_MOUTH_FORM"].value   = 1
        loader.parameter["PARAM_MOUTH_OPEN_Y"].value = 1
        self.isEyeClosing = false
    }
    
    //人物动作渲染
    override func animateModelSetting(loader: Live2DInfoLoader!, onTime time: UInt64) {
        let globalTime = Double(time) / 500
        loader.parameter["PARAM_ANGLE_Z"].value      = 30 * sin(globalTime)
        loader.parameter["PARAM_ARM_L"].value        = sin(globalTime)
        loader.parameter["PARAM_ARM_R"].value        = cos(globalTime)
        loader.parameter["PARAM_BODY_ANGLE_X"].value = 10 * sin(globalTime)
        loader.parameter["PARAM_BODY_ANGLE_Y"].value = 10 * sin(globalTime)
        loader.parameter["PARAM_BODY_ANGLE_Z"].value = 10 * sin(globalTime)
        loader.parameter["PARAM_HAIR_FRONT"].value   = sin(globalTime)
        loader.parameter["PARAM_HAIR_SIDE"].value    = sin(globalTime)
        loader.parameter["PARAM_HAIR_BACK"].value    = sin(globalTime)
        loader.parameter["PARAM_HAIR_BACK_L"].value  = sin(globalTime)
        loader.parameter["PARAM_HAIR_BACK_R"].value  = sin(globalTime)
        loader.parameter["PARAM_CHEEK"].value        = (sin(globalTime) + 1) / 2
        loader.parameter["PARAM_BREATH"].value       = (cos(globalTime) + 1) / 2
        
        if (sin(globalTime) + 1) >= 1.9 && !self.isEyeClosing {//眼睛睁开则使眼睛闭合
            self.isEyeClosing = true
            self.eyeSpeed     = Double(arc4random()) % 200 + 100 //盏眼频率
        }else if self.isEyeClosing {//如果是闭眼(图像眼睛现在是睁开)则让眼睛闭合, 设睁开幅度
            let eyeTime = Double(time) / self.eyeSpeed
            //设置左右眼睁开的幅度
            loader.parameter["PARAM_EYE_L_OPEN"].value = sin(eyeTime) + 1
            loader.parameter["PARAM_EYE_R_OPEN"].value = sin(eyeTime) + 1
            if (sin(eyeTime) + 1) >= 1.9 {//若睁开幅度大于sin(eyeTime) + 1, 则认为眼睛睁开
                self.isEyeClosing = false
            }
        }
    }
}
