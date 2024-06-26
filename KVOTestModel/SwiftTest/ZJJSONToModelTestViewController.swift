//
//  ZJJSONToModelTestViewController.swift
//  KVOTestModel
//
//  Created by zhangjiang on 2023/5/24.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

import UIKit

class ZJJSONToModelTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "JSONModelTest"
        testJSONModel()
    }
    
    func testJSONModel() {
//        ZJMetaCodableModelTest.testMetaCodable()
        
//        ZJKakaJSONModelTest.testKakaJSON()
        
//        ZJCodableModelTest.testCodableJSON()
        
//        ZJCodableWrapperModelTest.testCodableWrapper()
        
//        ZJSmartCodableModelTest.testSmartCodableJSON()
        
//        ZJHandyJSONTest.testHandyJSON()
        
        ZJExCodableTest.testExCodable()
    }

}
