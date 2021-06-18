//
//  MulDelegateViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/14.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "MulDelegateViewController.h"
#import "ShowTestDemo1.h"
#import "ShowTestDemo2.h"

/// 添加对应的日志输出，打印当前的行号
#define ZJDebugLog(moduleName,format, ...) {\
    NSString *formatMsg = [NSString stringWithFormat:(format), ##__VA_ARGS__]; \
    NSString *name = [NSString stringWithFormat:@"[%@],file:%s,function:%s,line:%d,message:%@\n",moduleName,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__PRETTY_FUNCTION__,__LINE__,formatMsg]; \
    printf([name UTF8String],nil);\
                    \
}

FOUNDATION_EXTERN NSString *const name;

@interface MulDelegateViewController ()

@end

@implementation MulDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"多代理测试";
    [self addTestMulDelegate];
}

- (void)addTestMulDelegate {
//    printDebugMsg("MulDelegate", @"这是测试信息==%@",@"哈哈哈");
    
//    char *msg = ["[%s],file:%s Function:%s, Line:%d, message:%s\n", moduleName, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__PRETTY_FUNCTION__, __LINE__ ,[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String]];
    
//    NSString *name = [NSString stringWithFormat:@"[%@],file:%@,function:%@,line:%d,message:%@\n",@"",@"",@"",14,@""];
    ZJDebugLog(@"你哈", @"来吧==%@", @"zhangsan");
}

- (void)dealMessage:(NSString *)moduleName format:(NSString *)format,... {
//    char *formatMsg = [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String]];
//    NSString *name = [NSString stringWithFormat:@"[%@],file:%@,function:%@,line:%d,message:%s\n",@"",@"",@"",14,formatMsg];
//    NSLog(name);
}

@end
