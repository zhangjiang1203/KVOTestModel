//
//  KXVoiceChatRoomViewController.h
//  KXLive
//
//  Created by zhangjiang on 2021/5/10.
//  Copyright © 2021 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KXVoiceManager.h"
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface KXVoiceChatRoomViewController : UIViewController

@property (nonatomic,strong) KXVoiceManager *voiceManager;

@property (nonatomic,strong) RACSubject<KXVoiceSeatModel *> *guestTapSubject;


@end

NS_ASSUME_NONNULL_END
