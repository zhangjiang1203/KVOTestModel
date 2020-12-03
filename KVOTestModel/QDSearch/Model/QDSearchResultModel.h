//
//  QDSearchResultModel.h
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/9.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,SearchResultType){
    SearchResultType_QQFriend         = 1 << 0,//1 qq好友
    SearchResultType_OuterContact     = 1 << 1,//2 外部联系人
    SearchResultType_Client           = 1 << 2,//4 客户
    SearchResultType_Colleague        = 1 << 3,//8 同事
    SearchResultType_GroupChat        = 1 << 4,//16 群聊
    SearchResultType_Department       = 1 << 5,//32 部门
    SearchResultType_ChattingRecords  = 1 << 6,//64 聊天记录
    SearchResultType_Function         = 1 << 7 //128 功能
};


NS_ASSUME_NONNULL_BEGIN

@interface QDSearchResultModel : NSObject

@property (nonatomic,assign) SearchResultType resultType;

@property (nonatomic,copy) NSString *avatarURL;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;
@property (nonatomic,copy) NSString *searchText;
///群组 好友 同事 部分 等的uin
@property (nonatomic,copy) NSString *jumpUin;
///原始数据
@property (nonatomic,strong) id userInfoData;

@end

NS_ASSUME_NONNULL_END
