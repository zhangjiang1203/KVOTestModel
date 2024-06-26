//
//  ZJMetaCodableModel.swift
//  KVOTestModel
//
//  Created by 张江 on 2024/6/25.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

import Foundation
import MetaCodable

fileprivate let maxCount = 100000
fileprivate let jsonStr = """
{
    "username1": "yuhanle",
    "age": 18,
    "weight": 65.4,
    "sex": 1,
    "location": "Toronto, Canada",
    "address":{
        "country": "中国",
        "province": "河南"
    },
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

struct ZJMetaCodableModelTest {
    
    static func testMetaCodable() {
        var start = CFAbsoluteTimeGetCurrent()

        var people: ZJMetaCodableModel = ZJMetaCodableModel()
        for _ in 0..<maxCount {
            do{
                people = try JSONDecoder().decode(ZJMetaCodableModel.self, from: jsonStr.data(using: .utf8)!)
            } catch {
                print("测试数据==\(error)")
            }
        }

        var executionTime = CFAbsoluteTimeGetCurrent() - start
        print("test MetaCodable deserialize time totals: ", executionTime)

        start = CFAbsoluteTimeGetCurrent()

        for _ in 0..<maxCount {
            let data = try! JSONEncoder().encode(people)
            _ = String(data: data, encoding: .utf8)!
        }

        executionTime = CFAbsoluteTimeGetCurrent() - start
//        print(res)
        print("test MetaCodable toJSONString time totals: ", executionTime)
    }
}
/*
 test MetaCodable deserialize time totals:  7.452168941497803
 test MetaCodable toJSONString time totals:  3.383513927459717
 CPU: 100%  highest
 Memory: 17.6MB
 测试机器: iPhone XR
 
 1.不支持多个key 映射到同一个key上
 2.类型不兼容 string 解析为int number 会报错 解析失败
*/

//MARK: smartCodable
@Codable
struct ZJMetaCodableModel {
    //指定 title,,username 都 解析到 username上 不支持多个key映射到同一个key上
    @CodedAt("title")
    var username: String?
    var age: Int?
    var weight: Double?
    var sex: Int?
    var location: String?
    //指定使用 address中的country 隐射到 country上
    @CodedAt("address","city")
    var country: String?
    //从 address这层路径开始解析
    @CodedIn("address")
    var province:String?
    
    @CodedAt("three_day_forecast")
    var threeDayForecast: [ZJThreeDayMetaCodableModel] = []
}

@Codable
struct ZJThreeDayMetaCodableModel {
    var conditions: String?
    var day: String?
    var temperature: Int?
}
