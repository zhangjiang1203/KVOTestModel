//
//  ZJHandyJSONModel.swift
//  KVOTestModel
//
//  Created by 张江 on 2024/6/25.
//  Copyright © 2024 zhangjiang. All rights reserved.
//
import Foundation
import HandyJSON

fileprivate let maxCount = 100000
fileprivate let jsonStr = """
{
    "username": "yuhanle",
    "age": "18",
    "weight": 65.4,
    "sex": 1,
    "location": "Toronto, Canada",
    "three_day_forecast": [
        {
            "conditions": "Partly cloudy",
            "day": "Monday",
            "temperature": 20
        },
        {
            "conditions": "Showers",
            "day": "Tuesday",
            "temperature": 22
        },
        {
            "conditions": "Sunny",
            "day": "Wednesday",
            "temperature": 28
        }
    ]
}
"""

/**
 1.类型自适应，如JSON中是一个Int，但对应Model是String字段，会自动完成转化
 2.支持Any
 3.支持自定义映射 多对一
 
 test HandyJSON deserialize time totals:  26.35019600391388
 test HandyJSON toJSONString time totals:  37.25950598716736
 
 CPU：101%
 MEMORY：547MB
 测试机器: iPhone XR
 */

struct ZJHandyJSONTest {

    static func testHandyJSON() {
        var start = CFAbsoluteTimeGetCurrent()
        
//        var people: ZJTestHandyJSONModel = ZJTestHandyJSONModel()
        for _ in 0..<maxCount {
            let people = ZJTestHandyJSONModel.deserialize(from: jsonStr)!
        }
        
        var executionTime = CFAbsoluteTimeGetCurrent() - start
        print("test HandyJSON deserialize time totals: ", executionTime)
        
//        start = CFAbsoluteTimeGetCurrent()
//        
//        for _ in 0..<maxCount {
//            _ = people.toJSONString()!
//        }
//        
//        executionTime = CFAbsoluteTimeGetCurrent() - start
//        print("test HandyJSON toJSONString time totals: ", executionTime)
    }
}



// MARK: HandyJSON
struct ZJTestHandyJSONModel: HandyJSON {
    var username: String?
    var age: Int?
    var weight: Double?
    var sex: Int?
    var location: String?
    var threeDayForecast: [ZJThreeDayHandyJSONModel] = []
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.username <-- ["title","username"]
        mapper <<<
            self.threeDayForecast <-- "three_day_forecast"
    }
}

struct ZJThreeDayHandyJSONModel: HandyJSON {
    var conditions: String?
    var day: String?
    var temperature: Int?
}
