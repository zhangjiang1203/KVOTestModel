//
//  KXVoiceManager.h
//  KXLive
//
//  Created by zhangjiang on 2021/5/10.
//  Copyright © 2021 ibobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KXVoiceSeatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KXVoiceManager : NSObject

@property (nonatomic,strong) NSMutableArray *seatInfoArr;

/// 添加代理依赖
//- (void)addIMVoiceHandler;
//
///// 移除代理依赖
//- (void)removeIMVoiceHandler;
//
//
//#pragma mark -同步房间信息
//- (void)getVoiceRoomInfo;

@end

NS_ASSUME_NONNULL_END
