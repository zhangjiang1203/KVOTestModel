//
//  GCDGroup.h
//  GCD
//
//  http://home.cnblogs.com/u/YouXianMing/
//  https://github.com/YouXianMing
//
//  Created by XianMingYou on 15/3/15.
//  Copyright (c) 2015年 XianMingYou. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 GCDGroup的封装
 */
@interface GCDGroup : NSObject

@property (strong, nonatomic, readonly) dispatch_group_t dispatchGroup;

#pragma 初始化
/// 初始化
- (instancetype)init;

#pragma mark - 用法
/// 进入 GCDGroup
- (void)enter;
/// 离开 GCDGroup
- (void)leave;
/// 等待
- (void)wait;
/// 等待时间
- (BOOL)wait:(int64_t)delta;

@end
