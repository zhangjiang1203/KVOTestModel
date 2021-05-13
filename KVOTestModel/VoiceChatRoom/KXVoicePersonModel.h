//
//  KXVoicePersonModel.h
//  KXLive
//
//  Created by zhangjiang on 2021/5/10.
//  Copyright © 2021 ibobei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KXVoiceType) {
    KXVoiceType_None = 1,      //观众
    KXVoiceType_Gesture,       //嘉宾
    KXVoiceType_Anchor         //主持
};



/*
 身份类型
 姓名
 id
 头像
 streamID
 */
@interface KXVoicePersonModel : NSObject

@property (nonatomic,assign) KXVoiceType identifierType;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *streamID;

@property (nonatomic,copy) NSString *headIconURL;

/// 静音
@property (nonatomic,assign) BOOL isSilence;
/// 踢出
@property (nonatomic,assign) BOOL isCanQuit;
/// 是否在说话
@property (nonatomic,assign) BOOL isSpeak;

/// 是否被选中
@property (nonatomic,assign) BOOL isChoose;

@end

NS_ASSUME_NONNULL_END
