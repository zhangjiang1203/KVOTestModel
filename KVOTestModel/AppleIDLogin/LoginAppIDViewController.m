//
//  LoginAppIDViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/8/10.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "LoginAppIDViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import <Masonry.h>
#import "ZTAppleLoginManager.h"
@interface LoginAppIDViewController ()

@end

@implementation LoginAppIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpAppleLogin];
}

- (void)setUpAppleLogin{
    if (@available(iOS 13, *)) {
        ASAuthorizationAppleIDButton *appleLoginBtn = [[ASAuthorizationAppleIDButton alloc]initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeSignIn authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleWhiteOutline];
        [appleLoginBtn addTarget:self action:@selector(signInWithAppleID) forControlEvents:(UIControlEventTouchUpInside)];
        appleLoginBtn.cornerRadius = (22);
        [self.view addSubview:appleLoginBtn];
        [appleLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(120);
            make.size.mas_equalTo(CGSizeMake(200, 44));
        }];
    }
}

- (void)signInWithAppleID {
   
    if (@available(iOS 13, *)) {
        [ZTAppleLoginManager shareInstance].presentVC = self;
        [[ZTAppleLoginManager shareInstance] siginWithAppleID:^(NSString * _Nonnull userID, NSString * _Nonnull accessToken, NSString * _Nonnull errorMsg) {
//            [self loginThirdWithType:@"AppleId" token:@"" uid:@""];
            NSLog(@"获取的token信息===accessToken:%@ ,userID:%@",accessToken,userID);
        }];
    }
//    [self.bindView showBindPhoneView:nil];
}


@end
