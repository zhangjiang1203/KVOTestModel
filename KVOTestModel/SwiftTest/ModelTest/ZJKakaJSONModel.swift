//
//  ZJKakaJSONModel.swift
//  KVOTestModel
//
//  Created by 张江 on 2024/6/25.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

import Foundation
import KakaJSON

fileprivate let maxCount = 100000
fileprivate let jsonStr = """
{
    "title": "yuhanle",
    "age": 18,
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
 1.支持泛型
 2.支持自定义多个key值
 3.类型兼容， string 转 int  bool number
 4.支持any类型解析
 
 test KakaJSON deserialize time totals:  22.845061898231506
 test KakaJSON toJSONString time totals:  14.10849404335022
 
 CPU: 101%
 MEMORY: 503.6MB
 测试机器: iPhone XR
 */

struct ZJKakaJSONModelTest {
    static func testKakaJSON() {
        var start = CFAbsoluteTimeGetCurrent()

        var people: ZJKakaJSONModel = ZJKakaJSONModel()
        for _ in 0..<maxCount {
            people = jsonStr.kj.model(ZJKakaJSONModel.self)!
        }

        var executionTime = CFAbsoluteTimeGetCurrent() - start
        print("test KakaJSON deserialize time totals: ", executionTime)

        start = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<maxCount {
            _ = people.kj.JSONString()

        }

        executionTime = CFAbsoluteTimeGetCurrent() - start
//        print(res)
        print("test KakaJSON toJSONString time totals: ", executionTime)
    }
}

//MARK: smartCodable
struct ZJKakaJSONModel: Convertible {
    var username: String?
    var age: Int?
    var weight: Double?
    var sex: Int?
    var location: String?
    var threeDayForecast: [ZJThreeDayKakaJSONModel]?
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        case "username": return ["username", "title"]
        case "threeDayForecast": return "three_day_forecast"
        default:
            return property.name
        }
    }
}
struct ZJThreeDayKakaJSONModel: Convertible {
    var conditions: String?
    var day: String?
    var temperature: Int?
}
