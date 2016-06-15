//
//  CustomViewController.swift
//  Live2DDemo
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

enum CustomType {
    case Haru, Wanko, Miku
}

class CustomViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var floatingView: UIView!
    
    @IBOutlet weak var movingView: UIView!
    
    @IBOutlet weak var valueSlider: UISlider!
    
    @IBOutlet weak var parameterTextField: UITextField!
    
    @IBOutlet weak var partTextField: UITextField!
    
    @IBOutlet weak var partSwitch: UISwitch!
    
    @IBOutlet weak var floatingViewToTop: NSLayoutConstraint!
   
    ///人物类型
    var type: CustomType?
    
    var parameterPicker: UIPickerView? // 参数选项滚轮
    var partPicker: UIPickerView? // 角色部位选项滚轮
    var live2DViewController: DaiLive2DViewController?
    var previousScale: CGFloat = 0
    var isTouchOnMovingView: Bool = false
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupIntitValues()
        self.setupLive2DModel()
        self.setupParameterTextField()
        self.setupPartTextField()
        self.setupGestures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - 参数初始化
    func setupIntitValues() {
        self.valueSlider.enabled = false
        self.partSwitch.enabled = false
    }
    
    ///设置参数的TextField
    private func setupParameterTextField() {
        let parameterPicker = UIPickerView()
        parameterPicker.dataSource = self
        parameterPicker.delegate = self
        self.parameterTextField.inputView = parameterPicker //点击后加载选项组件(滚轮)
        self.parameterPicker = parameterPicker
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let parameterDoneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "parameterDoneAction")
        let toolBar = UIToolbar()
        toolBar.items = [flexibleSpace, parameterDoneButton]
        toolBar.sizeToFit()
        self.parameterTextField.inputAccessoryView = toolBar
    }
    
    ///初始化部件的TextField
    private func setupPartTextField() {
        let partPicker = UIPickerView()
        partPicker.dataSource = self
        partPicker.delegate = self
        self.partTextField.inputView = partPicker //点击后加载选项组件(滚轮)
        self.partPicker = partPicker
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let partDoneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "partDoneAction")
        let toolBar = UIToolbar()
        toolBar.items = [flexibleSpace, partDoneButton]
        toolBar.sizeToFit()
        //设置滚轮的顶部导航栏
        self.partTextField.inputAccessoryView = toolBar
    }
    
    ///设置Live2D画面
    private func setupLive2DModel() {
        var beginPosition: CGFloat = 0
        if self.type == nil {
            assert(false, "人物类型没选择")
        }
        switch self.type! {
        case .Haru:
            self.live2DViewController = HaruViewController()
            beginPosition = self.live2DViewController!.position.y - (self.floatingView.bounds.height + 64) * 5
        case .Miku:
            self.live2DViewController = MikuViewController()
            beginPosition = self.live2DViewController!.position.y - (self.floatingView.bounds.height + 64) * 2.2
        case .Wanko:
            self.live2DViewController = WankoromochiViewController()
            beginPosition = self.live2DViewController!.position.y - (self.floatingView.bounds.height)
        }
        
        self.live2DViewController?.view.frame = self.view.bounds
        self.view.addSubview(self.live2DViewController!.view)
        self.live2DViewController?.position.y = beginPosition
        self.view.bringSubviewToFront(self.floatingView)
    }
    
    ///设置手势(缩放)
    func setupGestures() {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "onPitch:")
        self.view.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    //MARK: - selector定义
    func parameterDoneAction() {
        if let pickerView = self.parameterTextField.inputView as? UIPickerView {
            if let finalSelectedString = pickerView.delegate?.pickerView!(pickerView, titleForRow: pickerView.selectedRowInComponent(0), forComponent: 0) {
                self.parameterTextField.text = finalSelectedString
                self.parameterTextField.resignFirstResponder() //取消第一响应
                //点击done键后, 进度条可能会与选择滚轮后进度条的值不同(因为人物参数在改变)
                self.enableSliderForParameter(finalSelectedString)
            }
        }
    }
    
    //使Slider的value值随所选择的的选项而变化
    func enableSliderForParameter(parameter: String) {
        self.valueSlider.enabled = true
        self.valueSlider.minimumValue = Float(self.live2DViewController!.loader.parameter[parameter].min) * 100
        self.valueSlider.maximumValue = Float(self.live2DViewController!.loader.parameter[parameter].max) * 100
        //获取当前人物参数的值
        self.valueSlider.value = Float(self.live2DViewController!.loader.parameter[parameter].value) * 100
    }
    
    func partDoneAction() {
        if let pickerView = self.partTextField.inputView as? UIPickerView {
            if let finalSelectedString = pickerView.delegate?.pickerView!(pickerView, titleForRow: pickerView.selectedRowInComponent(0), forComponent: 0) {
                self.partTextField.text = finalSelectedString
                self.partTextField.resignFirstResponder() //取消第一响应
                self.enableSwitchForPart(finalSelectedString)
            }
        }
    }
    
    //使Switch的开关状态随所选择的的部件而变化
    func enableSwitchForPart(part: String) {
        self.partSwitch.enabled = true
        if self.live2DViewController?.loader.part[part].value <= 0 {
            self.partSwitch.on = false
        }else {
            self.partSwitch.on = true
        }
    }
    
    //对Live2D图画进行缩放
    func onPitch(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        if pinchGestureRecognizer.state == .Ended {
            self.previousScale = 1
            return
        }
        
        let scale = 1 - (self.previousScale - pinchGestureRecognizer.scale)
        if scale > 1 {
            self.live2DViewController?.scale += 10
        }else if scale < 1 {
            self.live2DViewController?.scale -= 10
        }
        
        self.previousScale = pinchGestureRecognizer.scale
    }

    //MARK: - 控件事件
    @IBAction func onParameterValueChange(sender: UISlider) {
        if let param = self.parameterTextField.text {
            self.live2DViewController?.loader.parameter[param].value = Double(sender.value) / 100
        }
    }
    
    @IBAction func onPartValueChange(sender: UISwitch) {
        var isShow: Double = 0
        if sender.on {
            isShow = 1
        }else {
            isShow = 0
        }
        self.live2DViewController?.loader.part[self.partTextField.text].value = isShow
    }
    
    //MARK: - UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.parameterPicker {
            return self.live2DViewController!.loader.parameters.count
        }else {
            return self.live2DViewController!.loader.parts.count
        }
    }
    
    //MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.parameterPicker {
            return self.live2DViewController?.loader.parameters[row]
        }else {
            return self.live2DViewController?.loader.parts[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.parameterPicker {
            if let selectedString = pickerView.delegate?.pickerView!(pickerView, titleForRow: pickerView.selectedRowInComponent(0), forComponent: 0) {
                self.parameterTextField.text = selectedString
                self.enableSliderForParameter(selectedString)
            }else {
                print("parameterPicker没选中")
            }
        }else {
            if let selectedString = pickerView.delegate?.pickerView!(pickerView, titleForRow: pickerView.selectedRowInComponent(0), forComponent: 0) {
                self.partTextField.text = selectedString
                self.enableSwitchForPart(selectedString)
            }else {
                print("partPicker没选中")
            }
        }
    }
    
    //MARK: - 触摸事件
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == self.movingView {
                self.isTouchOnMovingView = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInView(self.view)
            let previousLocation = touch.previousLocationInView(self.view)
            //计算移动距离差
            let deltaX = location.x - previousLocation.x
            let deltaY = location.y - previousLocation.y
            
            if self.isTouchOnMovingView {
                self.floatingViewToTop.constant += deltaY //改变设置框的高度
                self.floatingView.layoutIfNeeded() //设置框进行更新
            }else {
                //改变图像的位置
                var newPosition = self.live2DViewController?.position
                if newPosition == nil {
                    newPosition = CGPointZero
                }
                newPosition!.x -= deltaX * 5
                newPosition!.y -= deltaY * 5
                self.live2DViewController?.position = newPosition!
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.isTouchOnMovingView = false
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.isTouchOnMovingView = false
    }
}
