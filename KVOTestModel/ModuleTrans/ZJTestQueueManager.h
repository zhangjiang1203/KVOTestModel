//
//  ZJTestQueueManager.h
//  KVOTestModel
//
//  Created by douyu on 2023/3/22.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJTestQueueManager : NSObject

/// 插入数据
- (void)insertCustomData:(NSString *)str;

/// 清除
- (void)cleanSemaphore;

@end

NS_ASSUME_NONNULL_END
