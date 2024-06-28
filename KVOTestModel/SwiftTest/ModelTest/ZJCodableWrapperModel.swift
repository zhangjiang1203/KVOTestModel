//
//  ZJCodableWrapperModel.swift
//  KVOTestModel
//
//  Created by 张江 on 2024/6/25.
//  Copyright © 2024 zhangjiang. All rights reserved.
//


import Foundation
import CodableWrapper

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
 默认值 - 可以直接在结构体中为属性设置默认值，无需额外处理。
 基本类型转换 - 自动在String, Bool, Number之间进行转换。
 自定义CodingKey - 支持单个或多个键名，以实现灵活的数据映射。
 嵌套CodingKey - 方便处理嵌套字典的编码与解码。
 大小写兼容 - 自动在驼峰式和下划线命名法间转换。
 Codable子类支持 - 自动生成子类的init(from:)和encode(to:)方法。
 
 最低支持版本号
 1.0+  >= iOS13
 0.3.3 < iOS13
 
 不支持Any类型
 test CodableWrapper deserialize time totals:  39.64376699924469
 test CodableWrapper toJSONString time totals:  6.35113000869751
 
 CPU: 100%
 MEMORY: 16.8MB
 测试机器: iPhone XR
 */

// MARK: CodableWrapper

struct ZJCodableWrapperModelTest {
    
    static func testCodableWrapper() {
        var start = CFAbsoluteTimeGetCurrent()

//        var people: ZJTestCodableWrapperModel = ZJTestCodableWrapperModel()
        for _ in 0..<maxCount {
            do{
                let people = try JSONDecoder().decode(ZJTestCodableWrapperModel.self, from: jsonStr.data(using: .utf8)!)
            } catch {
                print("测试数据==\(error)")
            }
        }

        var executionTime = CFAbsoluteTimeGetCurrent() - start
        print("test CodableWrapper deserialize time totals: ", executionTime)

//        start = CFAbsoluteTimeGetCurrent()
//
//        for _ in 0..<maxCount {
//            let data = try! JSONEncoder().encode(people)
//            _ = String(data: data, encoding: .utf8)!
//        }
//
//        executionTime = CFAbsoluteTimeGetCurrent() - start
////        print(res)
//        print("test CodableWrapper toJSONString time totals: ", executionTime)
    }
}

@Codable
struct ZJTestCodableWrapperModel {
    @CodingKey("username", "title")
    var username: String?
    var age: Int?
    var weight: Double?
    var sex: Int?
    var location: String?
    
    //自定义转化的key值
    @CodingKey("three_day_forecast")
    var threeDayForecast: [ZJThreeDayCodableWrapperModel] = []
}

@Codable
struct ZJThreeDayCodableWrapperModel {
    var conditions: String?
    var day: String?
    var temperature: String = ""
}
