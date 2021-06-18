//
//  KXInPurchaseManager.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/6/18.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, KXInPurchseState) {
    KXInPurchse_Success = 1,
    KXInPurchse_Fail,
    KXInPurchse_Cancel,
    KXInPurchse_verifyFailed,
    KXInPurchse_verifySuccess,
    KXInPurchse_NotAllow
};


NS_ASSUME_NONNULL_BEGIN

typedef void(^KXInPurchseResultBlock)(KXInPurchseState status, NSData *data);

@interface KXInPurchaseManager : NSObject

/// 注册交易观察者
+ (void)registerTransactionObserver;

///开始请求购买
+ (void)startInPurchseWithID:(NSString *)purchID complete:(KXInPurchseResultBlock)complete;

@end

NS_ASSUME_NONNULL_END
