//
//  ZJServiceManager.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJServiceProtocol.h"
#import "ZJServiceDefine.h"

//注册对应的 protocol 和 class

NS_ASSUME_NONNULL_BEGIN

@interface ZJServiceManager : NSObject
+ (BOOL)getServicesActive:(Class)serviceClass;

+ (void)enableServiceActive:(BOOL)isActive serviceClass:(Class)serviceCls;

+ (void)activeServiceEvent:(int)event;



+ (void)addServiceWithClass:(Class)serviceCls protocol:(Protocol *)protocol;

+ (void)removeServiceWithProtocol:(Protocol *)protocol;

+ (Class)getServiceClassWithProtocol:(Protocol *)protocol;
@end

NS_ASSUME_NONNULL_END
