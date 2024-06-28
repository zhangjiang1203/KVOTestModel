//
//  ZJSmartCodableModel.swift
//  KVOTestModel
//
//  Created by 张江 on 2024/6/25.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

import Foundation
import SmartCodable

fileprivate let maxCount = 1
fileprivate let jsonStr = """
{
    "username": "yuhanle",
    "age": "18",
    "weight": 65.4,
    "sex": 1,
    "location": "Toronto, Canada"
}
"""
//fileprivate let jsonStr = """
//{
//    "username": "yuhanle",
//    "age": "18",
//    "weight": 65.4,
//    "sex": 1,
//    "location": "Toronto, Canada",
//    "three_day_forecast": [
//        {
//            "conditions": "Partly cloudy",
//            "day": "Monday",
//            "temperature": 20
//        },
//        {
//            "conditions": "Showers",
//            "day": "Tuesday",
//            "temperature": 22
//        },
//        {
//            "conditions": "Sunny",
//            "day": "Wednesday",
//            "temperature": 28
//        }
//    ]
//}
//"""

/**
 1.支持Any
 2.数据兼容 String  int bool number可自动转化完成
 
 
 test SmartCodableJSON deserialize time totals:  25.688678979873657
 test SmartCodable toJSONString time totals:  11.140548944473267
 
 CPU：108%
 MEMORY：458.2MB
 测试机器: iPhone XR
 */


struct ZJSmartCodableModelTest {
    static func testSmartCodableJSON() {
        var start = CFAbsoluteTimeGetCurrent()

//        var people: ZJSmartCodableModel = ZJSmartCodableModel()
        for _ in 0..<maxCount {
            let people = ZJSmartCodableModel.deserialize(from: jsonStr)!
            print("测试")
        }

        var executionTime = CFAbsoluteTimeGetCurrent() - start
        print("test SmartCodableJSON deserialize time totals: ", executionTime)

//        start = CFAbsoluteTimeGetCurrent()
//
//        for _ in 0..<maxCount {
//            _ = people.toJSONString() ?? ""
//        }
//
//        executionTime = CFAbsoluteTimeGetCurrent() - start
////        print(res)
//        print("test SmartCodable toJSONString time totals: ", executionTime)
    }
}

//MARK: smartCodable
struct ZJSmartCodableModel: SmartCodable {
    var username: String?
    var age: Int?
    var weight: Double?
    var sex: Int?
    var location: String?
//    var threeDayForecast: [ZJThreeDaySmartCodableModel] = []
//    
//    static func mappingForKey() -> [SmartKeyTransformer]? {
//        [
//            CodingKeys.threeDayForecast <--- "three_day_forecast",
//            CodingKeys.username <--- ["username", "title"]
//        ]
//    }
}
struct ZJThreeDaySmartCodableModel: SmartCodable {
    var conditions: String?
    var day: String?
    var temperature: Int?
}
