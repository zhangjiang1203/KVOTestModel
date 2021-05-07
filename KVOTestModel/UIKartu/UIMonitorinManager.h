//
//  UIMonitorinManager.h
//  searchPathProject
//
//  Created by zhangjiang on 2020/9/2.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIMonitorinManager : NSObject
//单例其他的创建方法失效
+ (instancetype)alloc  __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (instancetype)init   __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype)new    __attribute__((unavailable("new not available, call sharedInstance instead")));


+ (instancetype)shareInstance;


/// 开始监控
/// @param key 上报对应的key
-(void)startMonitorWithKey:(NSString*)key;


/// 停止上报
/// @param key 和上报的我key相对应
-(void)stopMonitorWithKey:(NSString*)key;


@end

NS_ASSUME_NONNULL_END
