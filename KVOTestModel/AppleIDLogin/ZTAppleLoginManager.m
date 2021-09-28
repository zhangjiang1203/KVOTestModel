//
//  ZTAppleLoginManager.m
//  ZTLoginModule
//
//  Created by zhangjiang on 2021/7/7.
//

#import "ZTAppleLoginManager.h"
#import <AuthenticationServices/AuthenticationServices.h>
//#import <UICKeyChainStore/UICKeyChainStore.h>

@interface ZTAppleLoginManager ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
//@property (nonatomic,strong) UICKeyChainStore *keyStore;
@end

@implementation ZTAppleLoginManager

static ZTAppleLoginManager *_instance = nil;
+ (instancetype)shareInstance{
    return [[self alloc]init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册通知
        if (@available(iOS 13.0, *)) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
        }
//        self.keyStore = [UICKeyChainStore keyChainStoreWithService:[NSBundle mainBundle].bundleIdentifier];
    }
    return self;
}

- (void)handleSignInWithAppleStateChanged:(NSNotification *)notification
{
    // 重新登录
    NSLog(@"%@", notification.userInfo);
}

- (void)siginWithAppleID:(ZTAppleLoginBlock)loginBlock {
    if (!self.presentVC) {
        NSLog(@"ZTAppleLoginManager 请设置presentVC");
        return;
    }
    
    if (!loginBlock) {
        NSLog(@"ZTAppleLoginManager 请设置loginBlock");
        return;
    }
    self.loginBlock = loginBlock;
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
        ASAuthorizationAppleIDRequest *appleIdrequest = [provider createRequest];
        appleIdrequest.requestedScopes = @[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail];
        
//        ASAuthorizationPasswordRequest *passwordReq = [[ASAuthorizationPasswordProvider new] createRequest];
//        NSMutableArray<ASAuthorizationRequest *> *requests = [NSMutableArray array];
//        if (appleIdrequest) {
//            [requests addObject:appleIdrequest];
//        }
//        if (passwordReq) {
//            [requests addObject:passwordReq];
//        }
        
        ASAuthorizationController *authorVC = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[appleIdrequest]];
        authorVC.delegate = self;
        authorVC.presentationContextProvider = self;
        [authorVC performRequests];
    }
}

#pragma mark -ASAuthorizationControllerPresentationContextProviding

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    return  self.presentVC.view.window;
}


#pragma mark -ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"正在授权或请求失败";
            break;
        default:
            errorMsg = @"授权请求失败";
            break;
    }
    if (self.loginBlock) {
        self.loginBlock(nil,nil, errorMsg);
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        //获取appleID中的信息
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
//        NSString *state = credential.state;
        NSString *userID = credential.user;
//        NSPersonNameComponents *fullName = credential.fullName;
//        NSString *email = credential.email;
//        NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];// refresh Token
        NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding]; // access token
//        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        //保存用户标识
//        [self.keyStore setString:userID forKey:@"userIdentifier"];
        //获取对应的信息提交给server进行验证处理
        if (self.loginBlock) {
            self.loginBlock(userID,identityToken, nil);
        }
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        ASPasswordCredential *passwordCredential = authorization.credential;
        NSString *userIdentifier = passwordCredential.user;
        NSString *password = passwordCredential.password;
        NSLog(@"保存的账号和密码==user:%@ password:%@",userIdentifier,password);
    }
}


#pragma mark -appleID登录状态查询
//- (void)checkAppleLoginState{
//    if (@available(iOS 13, *)) {
//        NSString *userIdentifier = [self.keyStore stringForKey:@"userIdentifier"];
//        if (userIdentifier && userIdentifier.length > 0) {
//            ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
//            [provider getCredentialStateForUserID:userIdentifier completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
//                switch (credentialState) {
//                    case ASAuthorizationAppleIDProviderCredentialRevoked:
//                    case ASAuthorizationAppleIDProviderCredentialNotFound:
//                        //appleID登录失效，需要重新登录
//                        break;
//                    case ASAuthorizationAppleIDProviderCredentialAuthorized:
//                        //appleID 有效
//                        break;
//                    default:
//                        break;
//                }
//            }];
//        }
//    }
//}

@end
