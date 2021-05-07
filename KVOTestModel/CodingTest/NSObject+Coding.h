//
//  NSObject+Coding.h
//  KVOTestModel
//
//  Created by zhangjiang on 2020/12/4.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Coding)

- (instancetype)zj_modelInitWithCoder:(NSCoder *)aDecoder;

- (void)zj_modelEncodeWithCoder:(NSCoder *)aCoder;

/// 模型转字典
- (NSMutableDictionary *)convertModelToDictionary;

/// 字典转模型
- (instancetype)zj_initWithDict:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
