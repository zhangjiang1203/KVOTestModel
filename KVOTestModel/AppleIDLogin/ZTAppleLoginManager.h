//
//  ZTAppleLoginManager.h
//  ZTLoginModule
//
//  Created by zhangjiang on 2021/7/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^ZTAppleLoginBlock)(NSString *_Nullable userID,NSString *_Nullable accessToken,NSString *_Nullable errorMsg);

@interface ZTAppleLoginManager : NSObject

@property (nonatomic,weak) UIViewController *presentVC;

@property (nonatomic,copy) ZTAppleLoginBlock loginBlock;

+ (instancetype)shareInstance;


/// 使用AppleID登录
- (void)siginWithAppleID:(ZTAppleLoginBlock)loginBlock;


/// 查询appleID登录状态
- (void)checkAppleLoginState;

@end

NS_ASSUME_NONNULL_END
