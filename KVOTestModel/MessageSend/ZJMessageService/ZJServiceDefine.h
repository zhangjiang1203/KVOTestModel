//
//  ZJServiceDefine.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef ZJServiceDefine_h
#define ZJServiceDefine_h


#define ZJServiceRegist()\
+(void)load{\
    [self setServiceActive:YES];\
}\
\
- (BOOL)isServiceActive {\
    return YES;\
}\
\
+ (void)setServiceActive:(BOOL)active {\
    [ZJServiceManager enableServiceActive:active serviceClass:self];\
}

#define service_Request(_protocol,_selector,...) __serviceRequestion(_protocol,_selector,##__VA_ARGS__)

#if defined(__cplusplus)
extern "C" {
#endif
id NS_REQUIRES_NIL_TERMINATION __serviceRequestion(Protocol *protocol,SEL selector,...);

#if defined(__cplusplus)
}
#endif

#endif



NS_ASSUME_NONNULL_BEGIN

@interface ZJServiceDefine : NSObject

@end

NS_ASSUME_NONNULL_END
