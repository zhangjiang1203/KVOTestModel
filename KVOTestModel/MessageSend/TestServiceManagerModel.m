//
//  TestServiceManagerModel.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "TestServiceManagerModel.h"
#import "ZJServiceProtocol.h"
#import "TestServiceProtocol.h"
#import "ZJServiceManager.h"
@interface TestServiceManagerModel ()<ZJServiceProtocol,TestServiceProtocol>

@end

@implementation TestServiceManagerModel

+(void)load{
    [self setServiceActive:YES];
}

- (BOOL)isServiceActive {
    return YES;
}

+ (void)setServiceActive:(BOOL)active {
    [ZJServiceManager enableServiceActive:active serviceClass:self];
}

- (void)serviceActionWithEvent:(int)event { 
    if (event == 1) {
        [ZJServiceManager addServiceWithClass:[self class] protocol:@protocol(TestServiceProtocol)];
    }
}

- (NSString *)showName { 
    return @"我就是我不一样的烟火";
}


@end
