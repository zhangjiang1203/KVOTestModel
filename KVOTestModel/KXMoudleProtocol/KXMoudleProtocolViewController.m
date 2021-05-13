//
//  KXMoudleProtocolViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/12.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "KXMoudleProtocolViewController.h"
#import "KXModuleOrz.h"
#import "KXMoudleProtocolTestModel.h"
@interface KXMoudleProtocolViewController ()

@end

@implementation KXMoudleProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"模块通信";
    
    //需要同时引入 orz he 实现协议的模块  这样才能
    NSString *showName = orz_ask(@protocol(KXTestMoudleProtocol), @selector(getCurrentName),nil);
    NSLog(@"通过协议转发获取的值==%@",showName);
    

}




@end
