//
//  CorasickTreeManager.h
//  KVOTestModel
//
//  Created by zhangjiang on 2019/12/5.
//  Copyright © 2019 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CorasickTreeManager : NSObject

+ (instancetype)shareInstance;

/// 创建AC自动机
- (NSString *)createTrieTree;

/// ac自动机查询
- (NSString *) trieFindMyTree:(NSString *)string;

/// for循环查询
- (NSString *)forNormalTimeCal:(NSString *)string;

/// 清空自动机
- (void) clearTrieTree;
@end

NS_ASSUME_NONNULL_END
