//
//  Timer+Extension.swift
//  KVOTestModel
//
//  Created by 张江 on 2024/7/11.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

import Foundation

extension Timer {
    @discardableResult
    public class func scheduledTimer(withTimeInterval interval: TimeInterval, block: @escaping (Timer) -> Void) -> Timer {
        
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0) { (runLoopTimer) in
            block(runLoopTimer!)
        }!
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer
    }
}

