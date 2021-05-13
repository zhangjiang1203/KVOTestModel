//
//  ZJServiceManager.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJServiceManager.h"
#import "ZJServiceEvent.h"
#import "ZJServiceManager.h"
#import "ZJServiceModel.h"

@interface ZJServiceManager()

@property (nonatomic,strong) ZJServiceEvent *serviceEvent;

@property (nonatomic,strong) ZJServiceModel *serviceModel;

@end

@implementation ZJServiceManager

+(instancetype)shareInstance{
    static ZJServiceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZJServiceManager alloc]init];
    });
    return manager;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.serviceEvent = [[ZJServiceEvent alloc]init];
        self.serviceModel = [[ZJServiceModel alloc]init];
    }
    return self;
}

#pragma mark -event
+ (BOOL)getServicesActive:(Class)serviceClass{
    return [[ZJServiceManager shareInstance].serviceEvent getServicesActive:serviceClass];
}

+ (void)enableServiceActive:(BOOL)isActive serviceClass:(Class)serviceCls{
    [[ZJServiceManager shareInstance].serviceEvent enableServiceActive:isActive serviceClass:serviceCls];
}

+ (void)activeServiceEvent:(int)event{
    [[ZJServiceManager shareInstance].serviceEvent activeServiceEvent:event];
}



#pragma mark -serviceAssisate
+ (void)addServiceWithClass:(Class)serviceCls protocol:(Protocol *)protocol{
    [[ZJServiceManager shareInstance].serviceModel addServiceWithClass:serviceCls protocol:protocol];
}

+ (void)removeServiceWithProtocol:(Protocol *)protocol {
    [[ZJServiceManager shareInstance].serviceModel removeServiceWithProtocol:protocol];
}

+ (Class)getServiceClassWithProtocol:(Protocol *)protocol {
    return [[ZJServiceManager shareInstance].serviceModel getServiceClassWithProtocol:protocol];
}

@end
