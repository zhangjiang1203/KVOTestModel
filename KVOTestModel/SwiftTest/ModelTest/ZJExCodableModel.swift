//
//  ZJExCodableModel.swift
//  KVOTestModel
//
//  Created by 张江 on 2024/6/25.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

import Foundation
import ExCodable

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



/*
 使用 KeyPath 映射到 Coding-Key，实现 Key-Mapping；
 支持多个候选 Coding-Key；
 支持 Coding-Key 嵌套；
 支持使用 Subscript 进行自定义 Encode/Decode；
 支持数据类型自动转换以及自定义转换；
 支持 struct、class、subclass；
 支持 JSON、PList 以及自定义 Encoder/Decoder，默认使用 JSON；
 使用类型推断，支持 Data、String、Array、Object 类型 JSON 数据；
 使用 Optional 类型取代抛出没什么用的 error，避免到处写 try?，有时还要套上括号 —— 现在也支持抛出异常了 [可选]。
 
 需要实现 keyMapping 方法
 自定义映射时要列出所有属性 不做映射的也要列出来 限制性太大
 数据类型不兼容
 嵌套类型解析失败
 不支持Any类型解析
 
 test Excodable deserialize time totals:  2.8706849813461304
 test Excodable toJSONString time totals:  3.7589659690856934
 
 
 CPU：100%
 MEMORY：17.8MB
 测试机器: iPhone XR
 */

struct ZJExCodableTest {

    static func testExCodable() {
        var start = CFAbsoluteTimeGetCurrent()
        
//        var people: ZJExcodableModel = ZJExcodableModel()
        for _ in 0..<maxCount {
            do {
                let people = try ZJExcodableModel.decoded(from: jsonStr.data(using: .utf8)!)
            }catch {
                print("excodable decode error:\(error.localizedDescription)")
            }
        }
        
        var executionTime = CFAbsoluteTimeGetCurrent() - start
        print("test Excodable deserialize time totals: ", executionTime)
        
//        start = CFAbsoluteTimeGetCurrent()
//        
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//         for _ in 0..<maxCount {
//             let jsonData = try? encoder.encode(people)
//             _ = String(data: jsonData ?? Data(), encoding: .utf8) ?? ""
//         }
//        
//        executionTime = CFAbsoluteTimeGetCurrent() - start
//        print("test Excodable toJSONString time totals: ", executionTime)
    }
}


//MARK: Excodable
struct ZJExcodableModel {
    var username: String?
    var age: Int?
    var weight: Double?
    var sex: Int?
    var location: String?
    var three_day_forecast: [ZJThreeDayExcodableModel]?
}

extension ZJExcodableModel: ExCodable {
    static var keyMapping: [KeyMap<Self>] = [
        KeyMap(\.username, to: "username","title"),
        KeyMap(\.age, to: "age"),
        KeyMap(\.weight, to: "weight"),
        KeyMap(\.sex, to: "sex"),
        KeyMap(\.location, to: "location"),
        KeyMap(\.three_day_forecast, to: "three_day_forecast")
    ]
}


struct ZJThreeDayExcodableModel {
    
    var conditions: String?
    var day: String?
    var temperature: Int?
}

extension ZJThreeDayExcodableModel: ExCodable {
    static var keyMapping: [KeyMap<Self>] = [
        KeyMap(\.conditions, to: "conditions"),
        KeyMap(\.day, to: "day"),
        KeyMap(\.temperature, to: "temperature")
    ]
    
}
