//
//  GCDQueue.h
//  GCD
//
//  http://home.cnblogs.com/u/YouXianMing/
//  https://github.com/YouXianMing
//
//  Created by XianMingYou on 15/3/15.
//  Copyright (c) 2015年 XianMingYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDGroup;
/**
 主要是对dispatch_queue做的封装
 */
@interface GCDQueue : NSObject

@property (strong, readonly, nonatomic) dispatch_queue_t dispatchQueue;

/// 获取主线程对列
+ (GCDQueue *)mainQueue;
/// 获取 global 线程对列
+ (GCDQueue *)globalQueue;
/// 获取 高优先级global 线程对列
+ (GCDQueue *)highPriorityGlobalQueue;
/// 获取 低优先级global 线程对列
+ (GCDQueue *)lowPriorityGlobalQueue;
/// 获取 background优先级global 线程对列
+ (GCDQueue *)backgroundPriorityGlobalQueue;

#pragma mark - 便利的构造方法

/// 在主线程对列执行 block
+ (void)executeInMainQueue:(dispatch_block_t)block;
/// 在global线程对列执行 block
+ (void)executeInGlobalQueue:(dispatch_block_t)block;
/// 在高优先级global线程对列执行 block
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block;
/// 在低优先级global线程对列执行 block
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block;
/// 在background优先级global线程对列执行 block
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block;
/// 在主线程对列执行 block,延迟sec秒执行
+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
/// 在global线程对列执行 block,延迟sec秒执行
+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
/// 在高优先级global线程对列执行 block,延迟sec秒执行
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
/// 在低优先级global线程对列执行 block,延迟sec秒执行
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
/// 在background优先级global线程对列执行 block,延迟sec秒执行
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

#pragma 初始化
/// 初始化
- (instancetype)init;
/// 初始化串行对列
- (instancetype)initSerial;
/// 初始化串行对列
- (instancetype)initSerialWithLabel:(NSString *)label;
/// 初始化并行对列
- (instancetype)initConcurrent;
/// 初始化并行对列
- (instancetype)initConcurrentWithLabel:(NSString *)label;

#pragma mark - 用法
- (void)execute:(dispatch_block_t)block;
- (void)execute:(dispatch_block_t)block afterDelay:(int64_t)delta;
- (void)execute:(dispatch_block_t)block afterDelaySecs:(float)delta;
- (void)waitExecute:(dispatch_block_t)block;
- (void)barrierExecute:(dispatch_block_t)block;
- (void)waitBarrierExecute:(dispatch_block_t)block;
- (void)suspend;
- (void)resume;

#pragma mark - 与GCDGroup相关
- (void)execute:(dispatch_block_t)block inGroup:(GCDGroup *)group;
- (void)notify:(dispatch_block_t)block inGroup:(GCDGroup *)group;

@end
