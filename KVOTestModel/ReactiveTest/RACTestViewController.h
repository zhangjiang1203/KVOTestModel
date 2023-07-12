//
//  RACTestViewController.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/7.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN
@interface Account : NSObject

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *password;

@end

@interface LoginViewModel : NSObject

@property (nonatomic, strong) Account *account;

// 是否允许登录的信号
@property (nonatomic, strong, readonly) RACSignal *enableLoginSignal;

@property (nonatomic, strong, readonly) RACCommand *LoginCommand;

@property (nonatomic, strong) RACSubject *actionSub;
@end

@interface RACTestViewController : UIViewController

@end



NS_ASSUME_NONNULL_END
