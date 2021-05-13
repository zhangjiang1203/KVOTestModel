//
//  ZJServiceProtocol.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZJServiceProtocol <NSObject>

//@required
//- (BOOL)isServiceActive;
//- (void)setServiceActive:(BOOL)active;


@required
- (void)serviceActionWithEvent:(int)event;

@end

NS_ASSUME_NONNULL_END
