//
//  ZJJSONToModelTestViewController.swift
//  KVOTestModel
//
//  Created by zhangjiang on 2023/5/24.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

import UIKit
import SnapKit
import SwiftUI
import Foundation

func handleDecimalNumber(data: Any?, scale: Int16, roundingMode: NSDecimalNumber.RoundingMode) -> NSDecimalNumber{
    //对数据进行处理
    guard let value = data else { return NSDecimalNumber(string: "0") }
    
    var decimal = NSDecimalNumber(string: "0")
    if let strValue = value as? String {
        if !(strValue.isEmpty || strValue.contains("null")){
            decimal = NSDecimalNumber(string: strValue)
        }
    } else if let numValue = value as? NSNumber {
        decimal = NSDecimalNumber(decimal:numValue.decimalValue)
    } else if let decimalValue = value as? NSDecimalNumber {
        decimal = decimalValue
    }
    
    let roundingBehavier = NSDecimalNumberHandler(roundingMode: roundingMode, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
    
    return decimal.rounding(accordingToBehavior: roundingBehavier)
}


extension NSDecimalNumber {
    
    func toString(scale: Int) -> String {
        let doubleValue = Double(truncating: self as NSNumber)
        return String(format: "%.\(scale)f", doubleValue)
    }
}


class ZJJSONToModelTestViewController: UIViewController {
    
    var timer: Timer!
    var timeCount: Int = 10
    
    let titles = ["123我来了","大哥火箭走一波","哈哈哈哈","测试是不是好了","我自横刀向天笑，去留肝胆两昆仑","感时花溅泪，恨别鸟惊心"]
    let colors: [Color] = [.red,.green,.pink,.purple,.accentColor,.brown,.cyan]
    var hostVC: UIHostingController<SwiftUITestPage>!
    
    var testModel: SwiftTestModel = SwiftTestModel(title: "我是初始值", textColor: .black)
    
    let swiftUICallClosure: () -> () = {
        print("按钮事件点击===1111")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "JSONModelTest"
        testDecimalFoundation()
    }
    
    func testDecimalFoundation(){
        print(handleDecimalNumber(data: "123.8678", scale: 2, roundingMode: .down).stringValue)
        print(handleDecimalNumber(data: "123.8678", scale: 2, roundingMode: .up).stringValue)
        print(handleDecimalNumber(data: 123.8678, scale: 3, roundingMode: .down).stringValue)
        print(handleDecimalNumber(data: 123.86746, scale:4, roundingMode: .up).stringValue)
        print(handleDecimalNumber(data: 123.86, scale: 3, roundingMode: .down).stringValue)
        print(handleDecimalNumber(data: 123.6, scale:4, roundingMode: .up).stringValue)
        print(handleDecimalNumber(data: "null", scale:4, roundingMode: .up).stringValue)
        print(handleDecimalNumber(data: "", scale:4, roundingMode: .up).stringValue)
        
    }
    
    func addSwiftUI(){
        //展示SwiftUi 视图
        hostVC = UIHostingController(rootView: recreateSwiftUIPage())
        addChild(hostVC)
        self.view.addSubview(hostVC.view)
        
        hostVC.view.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 200, height: 200))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        let titleBtn = UIButton()
        titleBtn.tag = 1
        titleBtn.backgroundColor = .blue
        titleBtn.layer.cornerRadius = 20
        titleBtn.layer.masksToBounds = true
        titleBtn.setTitle("修改Title", for: .normal)
        titleBtn.setTitleColor(.white, for: .normal)
        titleBtn.titleLabel?.font = .systemFont(ofSize: 14)
        titleBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        self.view.addSubview(titleBtn)
        
        let colorBtn = UIButton()
        colorBtn.tag = 2
        colorBtn.backgroundColor = .green
        colorBtn.layer.cornerRadius = 20
        colorBtn.layer.masksToBounds = true
        colorBtn.setTitle("修改Color", for: .normal)
        colorBtn.setTitleColor(.white, for: .normal)
        colorBtn.titleLabel?.font = .systemFont(ofSize: 14)
        colorBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        self.view.addSubview(colorBtn)
        
        titleBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 40))
            make.top.equalTo(hostVC.view.snp_bottomMargin).offset(10)
            make.centerX.equalToSuperview().offset(-60)
        }
        
        colorBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 40))
            make.top.equalTo(hostVC.view.snp_bottomMargin).offset(10)
            make.centerX.equalToSuperview().offset(60)
        }
    }
    
    @objc func buttonAction(sender: UIButton){
        if sender.tag == 1 {
            testModel.title = titles[Int.random(in: 0..<titles.count)]
        }else{
            testModel.textColor = colors[Int.random(in: 0..<colors.count)]
        }
        hostVC.rootView = recreateSwiftUIPage()
    }
    
    func recreateSwiftUIPage() -> SwiftUITestPage {
        SwiftUITestPage(testModel: testModel, onSubmit: swiftUICallClosure)
    }
    
    func testTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
             if self.timeCount <= 0 {
                 timer.invalidate()
                 self.timer = nil
                 print("倒计时结束==")
                 return
             }
             self.timeCount -= 1
            print("当前倒计时==\(self.timeCount)")
        }
        
        //可设置在指定时间设置定时器，时间可以用 弱引用来进行设置  防止循环引用
    }
    
    func testJSONModel() {
//    ZJCodableModelTest.testCodableJSON()
//    ZJHandyJSONTest.testHandyJSON()
//    ZJKakaJSONModelTest.testKakaJSON()
//    ZJSmartCodableModelTest.testSmartCodableJSON()
//    ZJExCodableTest.testExCodable()
//    ZJMetaCodableModelTest.testMetaCodable()
//    ZJCodableWrapperModelTest.testCodableWrapper()
    }
}
