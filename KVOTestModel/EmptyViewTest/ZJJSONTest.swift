//
//  ZJJSONTest.swift
//  KVOTestModel
//
//  Created by 张江 on 2024/5/27.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
import ObjectMapper

let maxCount = 100000

let jsonStr = """
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


class ZJJSONTest: NSObject {
    
    override init(){
        super.init()
        
    }
    
    func testObjcMapper() {
        var start = CFAbsoluteTimeGetCurrent()

        var people: ZJTestObjcMapper?
        for _ in 0..<maxCount {
            people = ZJTestObjcMapper(JSONString: jsonStr)
        }

        var executionTime = CFAbsoluteTimeGetCurrent() - start
        print("testObjcMapper deserialize time totals: ", executionTime)

        start = CFAbsoluteTimeGetCurrent()

        var res = ""
        for _ in 0..<maxCount {
            res = (people?.toJSONString()!)!
        }

        executionTime = CFAbsoluteTimeGetCurrent() - start
//        print(res)
        print("testObjcMapper toJSONString time totals: ", executionTime)
    }
    
    func testHandyJSON() {
        var start = CFAbsoluteTimeGetCurrent()

        var people: ZJTestHandyJSON = ZJTestHandyJSON()
        for _ in 0..<maxCount {
            people = ZJTestHandyJSON.deserialize(from: jsonStr)!
        }

        var executionTime = CFAbsoluteTimeGetCurrent() - start
        print("testHandyJSON deserialize time totals: ", executionTime)

        start = CFAbsoluteTimeGetCurrent()

        var res = ""
        for _ in 0..<maxCount {
            res = people.toJSONString()!
        }

        executionTime = CFAbsoluteTimeGetCurrent() - start
//        print(res)
        print("testHandyJSON toJSONString time totals: ", executionTime)
    }
    
    func testCodableJSON() {
        var start = CFAbsoluteTimeGetCurrent()

        var people: ZJTestCodableModel = ZJTestCodableModel()
        for _ in 0..<maxCount {
            let data = jsonStr.data(using: .utf8)
            people = try! JSONDecoder().decode(ZJTestCodableModel.self, from: data!)
        }

        var executionTime = CFAbsoluteTimeGetCurrent() - start
        print("testCodableJSON deserialize time totals: ", executionTime)

        start = CFAbsoluteTimeGetCurrent()

        var res = ""
        for _ in 0..<maxCount {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try? encoder.encode(people)
            res = String(data: jsonData ?? Data(), encoding: .utf8) ?? ""
        }

        executionTime = CFAbsoluteTimeGetCurrent() - start
//        print(res)
        print("testCodableJSON toJSONString time totals: ", executionTime)
    }

}

// MARK: HandyJSON
class ZJTestObjcMapper: Mappable {
    func mapping(map: ObjectMapper.Map) {
        username <- map["username"]
        age <- map["age"]
        weight <- map["weight"]
        sex <- map["sex"]
        location <- map["location"]
        threeDayForecast <- map["threeDayForecast"]
    }
    
    required init?(map: Map) { }
    
    var username: String?
    var age: Int?
    var weight: Double?
    var sex: Int?
    var location: String?
    var threeDayForecast: [ZJThreeDayObjcMapperModel] = []
}

class ZJThreeDayObjcMapperModel: Mappable {
    required init?(map: ObjectMapper.Map) {
            
    }
    
    func mapping(map: ObjectMapper.Map) {
        conditions <- map["conditions"]
        day <- map["day"]
        temperature <- map["temperature"]
    }
    
    var conditions: String?
    var day: String?
    var temperature: Int?
}

// MARK: HandyJSON
struct ZJTestHandyJSON: HandyJSON {
    init() { }
    
    var username: String?
    var age: Int?
    var weight: Double?
    var sex: Int?
    var location: String?
    var threeDayForecast: [ZJThreeDayHandyJSONModel] = []
}

struct ZJThreeDayHandyJSONModel: HandyJSON {
    init() { }
    
    var conditions: String?
    var day: String?
    var temperature: Int?
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
