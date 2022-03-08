//
//  ZJNetWorkManager.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/6/21.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestDemoDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZJNetWorkManager : NSObject

@property (nonatomic,weak) id<ZJNetWorkManagerDelegate> delegate;

- (void)show1111;

@end

NS_ASSUME_NONNULL_END
