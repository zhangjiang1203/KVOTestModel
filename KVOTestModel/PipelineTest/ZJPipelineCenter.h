//
//  ZJPipelineCenter.h
//  KVOTestModel
//
//  Created by douyu on 2023/3/20.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ZJPipelineCenter : NSObject

/// 插入消息
- (void)insertMsg:(NSString *)message;

/// 清空操作
- (void)clean;

@end

NS_ASSUME_NONNULL_END
