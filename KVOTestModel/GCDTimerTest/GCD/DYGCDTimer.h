//
//  DYGCDTimer.h
//  GCD
//
//  http://home.cnblogs.com/u/YouXianMing/
//  https://github.com/YouXianMing
//
//  Created by XianMingYou on 15/3/15.
//  Copyright (c) 2015年 XianMingYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDQueue;
/**
 GCDTimer的封装
 */
@interface DYGCDTimer : NSObject

@property (strong, readonly, nonatomic) dispatch_source_t dispatchSource;

#pragma 初始化
/// 构造函数
- (instancetype)init;
/// 构造函数
- (instancetype)initInQueue:(GCDQueue *)queue;

#pragma mark - 用法

/**
 定时触发 block
 
 @param block timer执行的函数
 @param secs timer时间间隔
 */
- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs;

/**
 定时触发 block
 
 @param block timer执行的函数
 @param secs timer时间间隔
 @param delaySecs 延迟触发
 */
- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs;

/// 启动timer
- (void)start;
/// 销毁timer
- (void)destroy;

@end
