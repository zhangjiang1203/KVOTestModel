//
//  ZJServiceEvent.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJServiceEvent : NSObject

- (BOOL)getServicesActive:(Class)serviceClass;

- (void)enableServiceActive:(BOOL)isActive serviceClass:(Class)serviceCls;

- (void)activeServiceEvent:(int)event;

@end

NS_ASSUME_NONNULL_END
