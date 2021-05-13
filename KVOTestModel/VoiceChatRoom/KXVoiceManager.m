//
//  KXVoiceManager.m
//  KXLive
//
//  Created by zhangjiang on 2021/5/10.
//  Copyright © 2021 ibobei. All rights reserved.
//

#import "KXVoiceManager.h"
//#import <KXMsgModule/KXIMClient.h>

@interface KXVoiceManager ()


@end


@implementation KXVoiceManager

+ (instancetype)shareInstance {
    static KXVoiceManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[KXVoiceManager alloc]init];
    });
    return _instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.seatInfoArr = [NSMutableArray array];
    }
    return self;
}

//- (void)addIMVoiceHandler {
//    [[KXIMClient sharedInstance] addDelegate:self delegateQueue:NULL];
//}
//
//- (void)removeIMVoiceHandler {
//    [[KXIMClient sharedInstance] removeDelegate:self];
//}


#pragma mark -同步房间信息
- (void)getVoiceRoomInfo {
    
}

//- (void)clientDidReceiveMessages:(NSArray <KXBaseMessageModel *> *)messagesArray varietyMsgDictionary:(NSDictionary *)varietyMsgDictionary {
//    NSLog(@"接收到下发消息______%@",varietyMsgDictionary);
//}











- (void)dealloc
{
//    [[KXIMClient sharedInstance]removeDelegate:self];
}

@end
