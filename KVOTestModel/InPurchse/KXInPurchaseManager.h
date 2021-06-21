//
//  KXInPurchaseManager.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/6/18.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, KXInPurchaseState) {
    KXInPurchase_Success = 1,
    KXInPurchase_Fail,
    KXInPurchase_Cancel,
    KXInPurchase_verifyFailed,
    KXInPurchase_verifySuccess,
    KXInPurchase_NotAllow
};


NS_ASSUME_NONNULL_BEGIN

typedef void(^KXInPurchaseResultBlock)(KXInPurchaseState status, NSData *data);

@interface KXInPurchaseManager : NSObject

/// 注册交易观察者
+ (void)registerTransactionObserver;

///开始请求购买
+ (void)startInPurchseWithID:(NSString *)purchID complete:(KXInPurchaseResultBlock)complete;

@end

NS_ASSUME_NONNULL_END
