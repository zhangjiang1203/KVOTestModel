//
//  KXInPurchaseManager.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/6/18.
//  Copyright © 2021 zhangjiang. All rights reserved.
//


/*
0.https://developer.apple.com/documentation/storekit/original_api_for_in-app_purchase/setting_up_the_transaction_observer_for_the_payment_queue?language=objc 官方文档
1.http://yimouleng.com/2015/12/17/ios-AppStore/  内购流程
2.http://www.jianshu.com/p/b199a4672608   完成交易后和服务器交互
3.http://www.jianshu.com/p/1ef61a785508 沙盒账号测试
4.https://www.jianshu.com/p/4f8a854ff427  审核前的配置及注意事项
 
注意事项：
1.沙盒环境测试appStore内购流程的时候，请使用没越狱的设备。
2.请务必使用真机来测试，一切以真机为准。
3.项目的Bundle identifier需要与您申请AppID时填写的bundleID一致，不然会无法请求到商品信息。
4.如果是你自己的设备上已经绑定了自己的AppleID账号请先注销掉,否则你到死😂😂😂😂都不知道是怎么回事。
5.订单校验 苹果审核app时，仍然在沙盒环境下测试，所以需要先进行正式环境验证，如果发现是沙盒环境则转到沙盒验证。
 As a best practice, always call the production URL for verifyReceipt first, and proceed to verify with the sandbox URL if you receive a 21007 status code.
识别沙盒环境订单方法：
 1.根据字段 environment = sandbox。
 2.根据验证接口返回的状态码,如果status=21007，则表示当前为沙盒环境。
 苹果反馈的状态码：
 21000App Store无法读取你提供的JSON数据
 21002 订单数据不符合格式
 21003 订单无法被验证
 21004 你提供的共享密钥和账户的共享密钥不一致
 21005 订单服务器当前不可用
 21006 订单是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中
 21007 订单信息是测试用（sandbox），但却被发送到产品环境中验证
 21008 订单信息是产品环境中使用，但却被发送到测试环境中验证
 */



#import "KXInPurchaseManager.h"
#import <StoreKit/StoreKit.h>
///沙盒验证地址
static NSString *const sandboxURL = @"https://sandbox.itunes.apple.com/verifyReceipt";
/// 正式验证地址
static NSString *const serverURL = @"https://buy.itunes.apple.com/verifyReceipt";


@interface KXInPurchaseManager ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic,copy) NSString *purchID;

@property (nonatomic,copy) KXInPurchseResultBlock resultBlock;

@end

@implementation KXInPurchaseManager

+(instancetype)shareInstance{
    static KXInPurchaseManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL]init];
    });
    return _instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [KXInPurchaseManager shareInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //监听程序销毁
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)handleWillTerminate:(NSNotification *)noti {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

+ (void)registerTransactionObserver{
    //购买监听，程序挂起时移除监听，如果有为完成的订单会自动回调paymentQueue:updateTransations
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[self shareInstance]];
}


+ (void)startInPurchseWithID:(NSString *)purchID complete:(KXInPurchseResultBlock)complete{
    [KXInPurchaseManager shareInstance].resultBlock = complete;
    if (purchID.length > 0) {
        [KXInPurchaseManager shareInstance].purchID = purchID;
        if ([SKPaymentQueue canMakePayments]) {
            [[KXInPurchaseManager shareInstance]startProductsRequest:purchID];
        }else{
            //当前设备不支持内购支付
            [[KXInPurchaseManager shareInstance] handlePaymentResult:(KXInPurchse_NotAllow) data:nil];
        }
    }
}

/// 开始请求商品信息
- (void)startProductsRequest:(NSString *)purchID {
    NSSet *set = [NSSet setWithArray:@[purchID]];
    SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

#pragma mark -observe方法 商品支付成功的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *trans in transactions) {
        switch (trans.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"【KXInPurchaseManager】添加进列表");
                break;
            case SKPaymentTransactionStatePurchased:
                NSLog(@"【KXInPurchaseManager】交易成功");
                [self completeTransaction:trans];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"【KXInPurchaseManager】交易失败");
                [self failedTransaction:trans];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"【KXInPurchaseManager】已购买过");
                [[SKPaymentQueue defaultQueue] finishTransaction:trans];
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"【KXInPurchaseManager】交易延迟");
                break;
        }
    }
}


#pragma mark -product请求代理
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray<SKProduct *> *products = response.products;
    if (products.count == 0) {
        NSLog(@"【KXInPurchaseManager】当前没有商品");
        return;
    }
    SKProduct *product = nil;
    for (SKProduct *obj in products) {
        if ([obj.productIdentifier isEqualToString:self.purchID]) {
            product = obj;
            break;
        }
    }
    
#if DEBUG
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"%@",[product description]);
    NSLog(@"%@",[product localizedTitle]);
    NSLog(@"%@",[product localizedDescription]);
    NSLog(@"%@",[product priceLocale]);
    NSLog(@"%@",[product productIdentifier]);
    NSLog(@"发送购买请求");
    
    //根据地区来展示不同的价格
    NSNumberFormatter *formater = [[NSNumberFormatter alloc]init];
    formater.numberStyle = NSNumberFormatterCurrencyStyle;
    formater.locale = product.priceLocale;
    NSString *priceStr = [formater stringFromNumber:product.price];
#endif
    
    if (product) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"【KXInPurchaseManager】商品信息请求成功");
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"【KXInPurchaseManager】商品信息请求失败==%@",error.description);
}

#pragma mark -transaction 成功失败处理 处理
- (void)completeTransaction:(SKPaymentTransaction *)trans{
    NSString *identifier = trans.payment.productIdentifier;
    if (identifier.length > 0) {
        //向自己的服务器验证购买凭证
        
    }
    //苹果官方验证
    [self verifyPurchaseWithTransaction:trans isTestServer:NO];
}

- (void)failedTransaction:(SKPaymentTransaction *)trans{
    if (trans.transactionState != SKErrorPaymentCancelled) {
        [self handlePaymentResult:(KXInPurchse_Fail) data:nil];
    }else{
        [self handlePaymentResult:(KXInPurchse_Cancel) data:nil];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:trans];
}


- (void)verifyPurchaseWithTransaction:(SKPaymentTransaction *)trans isTestServer:(BOOL)isTest {
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *recepit = [NSData dataWithContentsOfURL:recepitURL];
    if (recepit == nil) {
        [self handlePaymentResult:(KXInPurchse_verifyFailed) data:nil];
        return;
    }
    //购买成功将交易凭证发送到后台验证
    [self handlePaymentResult:(KXInPurchse_Success) data:recepit];
    
    //构造参数
    NSError *error;
    NSDictionary *dict = @{
        @"receipt-data":[recepit base64EncodedDataWithOptions:(NSDataBase64Encoding64CharacterLineLength)]
    };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if (requestData == nil) {
        [self handlePaymentResult:(KXInPurchse_verifyFailed) data:nil];
        return;
    }
    
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:isTest ? sandboxURL : serverURL]];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    [[NSURLSession sharedSession] dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            //苹果服务器校验失败
            [self handlePaymentResult:(KXInPurchse_verifyFailed) data:nil];
        }else{
            NSError *error;
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (resDict == nil || error) {
                [self handlePaymentResult:(KXInPurchse_verifyFailed) data:nil];
                return;
            }
            //服务器返回的验证结果
            NSLog(@"【KXInPurchaseManager】verify response result = %@",resDict);
            //先验证正式服务器，如果正式服务器返回21007 再去苹果测试服务器验证，沙盒测试环境苹果用的是测试服务器
            NSString *status = [NSString stringWithFormat:@"%@",resDict[@"status"]];
            if (status && [status isEqualToString:@"21007"]) {
                //这时候再去测试服务器验证
                [self verifyPurchaseWithTransaction:trans isTestServer:YES];
            }else if(status && [status isEqualToString:@"0"]){
                [self handlePaymentResult:(KXInPurchse_Success) data:nil];
            }
        }
    }];
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    [[SKPaymentQueue defaultQueue] finishTransaction:trans];
}


- (void)handlePaymentResult:(KXInPurchseState)state data:(NSData *)receiptData {
    switch (state) {
        case KXInPurchse_Success:
            NSLog(@"【KXInPurchaseManager】内购成功");
            break;
        case KXInPurchse_Fail:
            NSLog(@"【KXInPurchaseManager】内购失败");
            break;
        case KXInPurchse_Cancel:
            NSLog(@"【KXInPurchaseManager】取消内购");
            break;
        case KXInPurchse_verifyFailed:
            NSLog(@"【KXInPurchaseManager】验证失败");
            break;
        case KXInPurchse_verifySuccess:
            NSLog(@"【KXInPurchaseManager】验证成功");
            break;
        case KXInPurchse_NotAllow:
            NSLog(@"【KXInPurchaseManager】不支持内购");
            break;
    }
    if (self.resultBlock) {
        self.resultBlock(state,receiptData);
    }
}
@end
