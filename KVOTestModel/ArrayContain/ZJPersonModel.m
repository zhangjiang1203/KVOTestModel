//
//  ZJPersonModel.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/10/21.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJPersonModel.h"

@implementation ZJPersonModel

- (BOOL)isEqualToPerson:(ZJPersonModel *)object{
    if (!object) {
        return NO;
    }
    return [self.userId isEqualToString:object.userId];
}

/// 为了比较两个model对象是否相同  重写isEqual方法
- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[ZJPersonModel class]]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    return [self isEqualToPerson:object];
}

@end
