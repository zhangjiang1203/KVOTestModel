//
//  ZJAnswerDefine.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZJQuestionEvent) {
    ZJQuestionEvent_None = 0,
    ZJQuestionEvent_SetUp = 1,
    
    //windown  回调方法
    ZJQuestionEvent_WillResignActiveEvent = 100,
    ZJQuestionEvent_DidEnterBackgroundEvent,
    ZJQuestionEvent_WillEnterBackgroundEvent,
    ZJQuestionEvent_DidBecomeActiveEvent,
    ZJQuestionEvent_WillTerminateEvent,
    
    //view 生命回调方法
    ZJQuestionEvent_DidFinishLaunch  = 200,
    ZJQuestionEvent_ViewDidLoad,
    ZJQuestionEvent_ViewWillAppear,
    ZJQuestionEvent_ViewWillDisappear,
};


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

