//
//  WankoromochiViewController.swift
//  Live2DDemo
//
//  Created by apple on 16/1/30.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class WankoromochiViewController: DaiLive2DViewController {

    var isEyeClosing     = false
    var eyeSpeed: Double = 0
    
    //MARK: - 构造方法
    init() {
        super.init(fromBundlePath: "/Wankoromochi/model.plist")
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
    }

    //人物动画
    override func animateModelSetting(loader: Live2DInfoLoader!, onTime time: UInt64) {
        let globalTime = Double(time) / 1000
        loader.parameter["PARAM_ANGLE_Z"].value = loader.parameter["PARAM_ANGLE_Z"].max * sin(globalTime)
        loader.parameter["PARAM_BODY_ANGLE_Z"].value = loader.parameter["PARAM_ANGLE_Z"].max * sin(globalTime)
        loader.parameter["PARAM_BREATH"].value = (cos(globalTime) + 1) / 2
        
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
