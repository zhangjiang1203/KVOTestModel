//
//  TeseSingleInstanceModel.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/14.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "TeseSingleInstanceModel.h"
#import "ZJServiceProtocol.h"
#import "TestServiceProtocol.h"
#import "ZJServiceManager.h"
@interface TeseSingleInstanceModel ()<ZJServiceProtocol,TestSingleInstanceProtocol>

@end


@implementation TeseSingleInstanceModel
static TeseSingleInstanceModel *_instance = nil;
+(instancetype)shareInstance {

    return  [[self alloc]init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


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
        [ZJServiceManager addServiceWithClass:[self class] protocol:@protocol(TestSingleInstanceProtocol)];
    }
}

-(NSString *)testSingleInstance:(NSString *)showName{
    return @" testSingleInstance ";
}

@end
