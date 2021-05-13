//
//  ZJServiceEvent.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJServiceEvent.h"
#import "ZJServiceProtocol.h"
@interface ZJServiceEvent ()

@property (nonatomic,strong) NSMutableDictionary *totalClassesDict;

@property (nonatomic,strong) NSLock *lock;

@end

@implementation ZJServiceEvent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.totalClassesDict = [NSMutableDictionary dictionary];
        self.lock = [[NSLock alloc]init];
    }
    return self;
}

- (BOOL)getServicesActive:(Class)serviceClass{
    if (!serviceClass) {
        return NO;
    }
    BOOL result = [serviceClass conformsToProtocol:@protocol(ZJServiceProtocol)];
    if (!result) {
        return NO;
    }
    id obj = [self.totalClassesDict objectForKey:NSStringFromClass(serviceClass)];
    if (obj) {
        return YES;
    }
    return NO;
}

- (void)enableServiceActive:(BOOL)isActive serviceClass:(Class)serviceCls {
    if (!serviceCls) {
        return;
    }
    BOOL result = [serviceCls conformsToProtocol:@protocol(ZJServiceProtocol)];
    if (!result) {
        return;
    }
    
    if (isActive) {
        [self addServiceClass:serviceCls];
    }else{
        [self removeServiceClass:serviceCls];
    }
    
}

- (void)addServiceClass:(Class)cls {
    BOOL result = [self getServicesActive:cls];
    if (result) {
        return;
    }
    [self.lock lock];
    id instance = [[cls alloc]init];
    [self.totalClassesDict setValue:instance forKey:NSStringFromClass(cls)];
    [self.lock unlock];
    
}

- (void)removeServiceClass:(Class)cls {
    if (!cls) {
        return;
    }
    [self.lock lock];
    [self.totalClassesDict removeObjectForKey:NSStringFromClass(cls)];
    [self.lock unlock];
}


- (void)activeServiceEvent:(int)event{
    if (event == 0) {
        return;
    }
    NSMutableArray *totalClassArr = [NSMutableArray array];
    NSArray *tempArr = self.totalClassesDict.allValues;
    if (tempArr &&tempArr.count) {
        totalClassArr = [NSMutableArray arrayWithArray:tempArr];
    }
    for (id<ZJServiceProtocol> instance in tempArr) {
        if ([instance respondsToSelector:@selector(serviceActionWithEvent:)]) {
            [instance serviceActionWithEvent:event];
        }
    }
}

@end
