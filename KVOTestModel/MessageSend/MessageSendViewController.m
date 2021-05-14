//
//  MessageSendViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/12.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "MessageSendViewController.h"
#import "SendPersonModel.h"
#import "ZJServiceManager.h"
#import "TestServiceProtocol.h"
@interface MessageSendViewController ()

@end

@implementation MessageSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转发";
    
    
    id result = service_Request(@protocol(TestServiceProtocol), @selector(showName),nil);
    NSLog(@"协议转发 获取1 %@",result);
    
    id result2 = service_Request(@protocol(TestServiceProtocol), @selector(getMySysInfo),nil);
    NSLog(@"协议转发 获取2 %@",result2);
    
//    SendPersonModel *model = [SendPersonModel new];
//    [model eat];
    
    //使用nsinvocation进行消息转发
    NSMethodSignature *signature = [MessageSendViewController instanceMethodSignatureForSelector:@selector(sendMesageWithNumber:withContent:)];
    
    //创建NSInvocation对象
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = @selector(sendMesageWithNumber:withContent:);
    //给对应的方法设置参数
    /*
     设置参数的索引不能从0 和 1 当前位置设置，0 放置self  1 放_cmd
     */
    NSString *number = @"11111";
    [invocation setArgument:&number atIndex:2];
    NSString *content = @"2222";
    [invocation setArgument:&content atIndex:3];
    //只要调用invocation的invoke方法 就代表需要执行NSInvocation对象中指定的方法，并且传递指定的参数
    [invocation invoke];
    char type[] = @encode(id);
    NSLog(@"当前使用===%s",type);
    
}



- (void)sendMesageWithNumber:(NSString *)number withContent:(NSString *)content {
    NSLog(@"电话号:%@,内容:%@",number,content);
}



@end
