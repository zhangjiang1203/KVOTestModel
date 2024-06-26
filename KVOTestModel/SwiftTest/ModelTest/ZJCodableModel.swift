//
//  ZJCodableModel.swift
//  KVOTestModel
//
//  Created by 张江 on 2024/6/25.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

import Foundation

fileprivate let maxCount = 100000
fileprivate let jsonStr = """
{
    "username": "yuhanle",
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
 CodingKeys : 比较极端 1.完全不写  2.所有对应的属性都要写，需要转换的特别指出
 1.不支持codingkey 多个json key解析到同一个key上
 2.不兼容类型 string 定义为 int  bool 会解析失败
 3.不支持any类型
 
 test CodableJSON deserialize time totals:  6.839451909065247
 test CodableJSON toJSONString time totals:  3.1653120517730713
 
 CPU：100%
 MEMORY：17MB
 测试机器: iPhone XR
 */


struct ZJCodableModelTest {
   static func testCodableJSON() {
        var start = CFAbsoluteTimeGetCurrent()

        var people: ZJTestCodableModel = ZJTestCodableModel()
        for _ in 0..<maxCount {
            let data = jsonStr.data(using: .utf8)
            people = try! JSONDecoder().decode(ZJTestCodableModel.self, from: data!)
        }

        var executionTime = CFAbsoluteTimeGetCurrent() - start
        print("test CodableJSON deserialize time totals: ", executionTime)

        start = CFAbsoluteTimeGetCurrent()

       let encoder = JSONEncoder()
       encoder.outputFormatting = .prettyPrinted
        for _ in 0..<maxCount {
            let jsonData = try? encoder.encode(people)
            _ = String(data: jsonData ?? Data(), encoding: .utf8) ?? ""
        }

        executionTime = CFAbsoluteTimeGetCurrent() - start
//        print(res)
        print("test CodableJSON toJSONString time totals: ", executionTime)
    }
}

// MARK: - DYHCommentInfoMode
struct ZJTestCodableModel: Codable {
    var username: String?
    var age: Int?
    var weight: Double?
    var sex: Int?
    var location: String?
    var threeDayForecast: [ZJThreeDayCodableModel]?

    enum CodingKeys: String, CodingKey {
        case username, age, weight, sex, location
        case threeDayForecast = "three_day_forecast"
    }
}

struct ZJThreeDayCodableModel: Codable {
    var conditions: String?
    var day: String?
    var temperature: Int?
}
