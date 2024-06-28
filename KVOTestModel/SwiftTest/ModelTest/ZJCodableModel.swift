//
//  ZJCodableModel.swift
//  KVOTestModel
//
//  Created by 张江 on 2024/6/25.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

import Foundation

fileprivate let maxCount = 1
fileprivate let jsonStr = """
{
    "username": "yuhanle",
    "age": 18,
    "weight": 65.4,
    "sex": 1,
    "location": "Toronto, Canada",
    "show_name_test": nil,
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
       let encoder = JSONEncoder()
       encoder.outputFormatting = .prettyPrinted
       
        for _ in 0..<maxCount {
            let data = jsonStr.data(using: .utf8)
            let people = try? JSONDecoder().decode(ZJTestCodableModel.self, from: data!)
            
            let jsonData = try? encoder.encode(people)
            let jsonStr = String(data: jsonData ?? Data(), encoding: .utf8) ?? ""
            print("展示数据==\(jsonStr)")
            
        }

        var executionTime = CFAbsoluteTimeGetCurrent() - start
        print("test CodableJSON deserialize time totals: ", executionTime)

//        start = CFAbsoluteTimeGetCurrent()
//
//       let encoder = JSONEncoder()
//       encoder.outputFormatting = .prettyPrinted
//        for _ in 0..<maxCount {
//            let jsonData = try? encoder.encode(people)
//            _ = String(data: jsonData ?? Data(), encoding: .utf8) ?? ""
//        }
//
//        executionTime = CFAbsoluteTimeGetCurrent() - start
////        print(res)
//        print("test CodableJSON toJSONString time totals: ", executionTime)
    }
}

// MARK: - DYHCommentInfoMode
struct ZJTestCodableModel: Codable {
    var username: String?
    var age: Int?
    var weight: Double?
    var sex: Int?
    var location: String?
//    var threeDayForecast: [ZJThreeDayCodableModel]?
    var show_name_test: [String : Any]?
    var three_day_forecast: [Any]?

    enum CodingKeys: String, CodingKey {
        case username, age, weight, sex, location, three_day_forecast, show_name_test
//        case threeDayForecast = "three_day_forecast"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decodeIfPresent(String.self, forKey: .username)
        self.age = try container.decodeIfPresent(Int.self, forKey: .age)
        self.weight = try container.decodeIfPresent(Double.self, forKey: .weight)
        self.sex = try container.decodeIfPresent(Int.self, forKey: .sex)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.three_day_forecast = try container.decodeIfPresent(Array<Any>.self, forKey: .three_day_forecast)
        self.show_name_test = try container.decodeIfPresent(Dictionary<String, Any>.self, forKey: .show_name_test)

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.username, forKey: .username)
        try container.encodeIfPresent(self.age, forKey: .age)
        try container.encodeIfPresent(self.weight, forKey: .weight)
        try container.encodeIfPresent(self.sex, forKey: .sex)
        try container.encodeIfPresent(self.location, forKey: .location)
        try container.encode(self.three_day_forecast, forKey: .three_day_forecast)
        try container.encode(self.show_name_test, forKey: .show_name_test)
    }
}

struct ZJThreeDayCodableModel: Codable {
    var conditions: String?
    var day: String?
    var temperature: Int?
}
