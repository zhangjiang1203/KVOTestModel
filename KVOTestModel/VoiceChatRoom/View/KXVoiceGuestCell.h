//
//  KXVoiceGuestCell.h
//  KXLive
//
//  Created by zhangjiang on 2021/5/10.
//  Copyright © 2021 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KXVoiceSeatModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface KXVoiceGuestCell : UITableViewCell

@property (nonatomic,strong) KXVoiceSeatModel *seatModel;

@property (nonatomic,strong) RACSubject *giftSubject;

@end

NS_ASSUME_NONNULL_END
