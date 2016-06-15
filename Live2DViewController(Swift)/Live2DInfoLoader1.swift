//
//  Live2DInfoLoader.swift
//  Live2DDemo
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

protocol Live2DInfoLoaderDelegate {
    func setValue(value: Double, forParameter parameter: String)
    func valueForParameter(parameter: String) -> Double
    func setValue(value: Double, forPart part: String)
    func valueForPart(part: String) -> Double
}

//MARK: - 注意调试
class Live2DInfoLoader: NSObject, Live2DParameterDelegate, Live2DPartDelegate {
    var delegate: Live2DInfoLoaderDelegate?
    ///所取文件的上级文件路径
    var basePath = ""
    ///资源文件路径
    var bundlePath: String {
        return NSBundle.mainBundle().bundlePath
    }
    var modelInfo: NSDictionary?
    
    ///取得model.plish中的人物的moc文件路径
    var model: String {
        get {
            if let modelName = self.modelInfo?["ModelName"] as? NSString {
                return (self.basePath as NSString).stringByAppendingPathComponent(modelName as String)
            }else {
                FxLog("ModelName获取出错")
            }
            return ""
        }
    }
    
    ///获取model.plish中的ModelTextures(动画的图片资源路径)
    private var _textures: NSMutableArray = []
    var textures: NSArray {
        if let modelTextures = self.modelInfo?["ModelTextures"] as? [String] {
            for texture in modelTextures {
                _textures.addObject((self.basePath as NSString).stringByAppendingPathComponent(texture))
            }
            return _textures
        }else {
            FxLog("ModelTextures获取出错")
        }
        return []
    }
    
    ///取得model.plish文件中的ModelParam各属性名的数组, [String]类型
    var parameters: NSArray {
        if let modelParam = self.modelInfo!["ModelParam"] as? NSDictionary {
            let params = modelParam.allKeys
            let sortParams = (params as NSArray).sortedArrayUsingComparator({ (obj1, obj2) -> NSComparisonResult in
                return (((obj1 as! NSString) as String).compare((obj2 as! NSString) as String))
            })
            return (sortParams as! [String])
        }
        return []
    }
    
    ///获取Live2DParameter实例
    var parameter: Live2DParameter {
        let param = Live2DParameter.shard()
        if param.delegate == nil {
            param.delegate = self
        }
        return param
    }
    
    ///取得model.plish文件中的ModelPart属性(可显示的部位,[String]类型)
    var parts: [String] {
        if let modelParam = self.modelInfo!["ModelPart"] as? NSArray {
            let sortParams = modelParam.sortedArrayUsingComparator({ (obj1, obj2) -> NSComparisonResult in
                return (((obj1 as! NSString) as String).compare((obj2 as! NSString) as String))
            })
            return (sortParams as! [String])
        }
        return []
    }
    
    ///取得Live2DPart部位的实例
    var part: Live2DPart {
        let part = Live2DPart.shard()
        if part.delegate == nil {
            part.delegate = self
        }
        return part
    }
    
    init(path: String) {
        super.init()
        let lastPathComponent = (path as NSString).lastPathComponent
        self.basePath = (self.bundlePath as NSString).stringByAppendingString((path as NSString).stringByReplacingOccurrencesOfString(lastPathComponent, withString: ""))
        self.modelInfo = self.dictionaryFromPlistBundlePath(path)
        if self.modelInfo == nil {
            assert(false, "Load model.plist Fail")
        }
    }
    
    ///取得model plish数据
    func dictionaryFromPlistBundlePath(path: String) -> NSDictionary? {
        let filePath = (self.bundlePath as NSString).stringByAppendingPathComponent(path)
        return NSDictionary(contentsOfFile: filePath)
    }
    
    //MARK: - Live2DPartDelegate代理的实现
    ///改变part值
    func setValue(value: Double, forPart part: String) {
        self.delegate?.setValue(value, forPart: part)
    }
    
    func valueForPart(part: String) -> Double {
        if self.delegate == nil {
            FxLog("Live2DInfoLoaderDelegate为空1")
        }
        return self.delegate!.valueForPart(part)
    }
    
    //MARK: - Live2DParameterDelegate代理的实现
    //回传该parameter的预设最大最小值(获取model.plish中ModelParam属性中的各个属性)
    func infoForParameter(parameter: String) -> NSDictionary? {
        if let modelParam = self.modelInfo!["ModelParam"] as? NSDictionary {
            if let param = modelParam[parameter] as? NSDictionary {
                return param
            }
        }
        return nil
    }
    
    func setValue(value: Double, forParameter parameter: String) {
        self.delegate?.setValue(value, forParameter: parameter)
    }
    
    func valueForParameter(parameter: String) -> Double {
        if self.delegate == nil {
            FxLog("Live2DInfoLoaderDelegate为空2")
        }
        return self.delegate!.valueForParameter(parameter)
    }
}
