//
//  KXVoiceSeatModel.h
//  KXLive
//
//  Created by zhangjiang on 2021/5/10.
//  Copyright © 2021 ibobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KXVoicePersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KXVoiceSeatModel : NSObject

/*
 2.对应的人
 3.座位序号
 4.是否静音
 5.是否可踢
 */

@property (nonatomic,assign) NSInteger seatIndex;

@property (nonatomic,strong) KXVoicePersonModel *person;



@end

NS_ASSUME_NONNULL_END
