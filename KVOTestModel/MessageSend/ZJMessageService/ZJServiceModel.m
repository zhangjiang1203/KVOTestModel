//
//  ZJServiceModel.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJServiceModel.h"

@interface ZJServiceModel ()

@property (nonatomic,strong) NSMutableDictionary *servicesDict;
@property (nonatomic,strong) NSMutableDictionary *classesDict;
@property (nonatomic,strong) NSLock *serviceLock;

@end


@implementation ZJServiceModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.servicesDict = [NSMutableDictionary dictionary];
        self.classesDict = [NSMutableDictionary dictionary];
        self.serviceLock = [[NSLock alloc]init];
    }
    return self;
}


- (void)addServiceWithClass:(Class)serviceCls protocol:(Protocol *)protocol{
    if (!serviceCls || !protocol) {
        return;
    }
    
    //当前class或者类实例要实现这个协议
    if (![serviceCls conformsToProtocol:protocol]) {
        return;
    }
    //添加方法到字典中
    [self.serviceLock lock];
    [self.servicesDict setValue:NSStringFromClass(serviceCls) forKey:NSStringFromProtocol(protocol)];
    [self.classesDict setValue:NSStringFromProtocol(protocol) forKey:NSStringFromClass(serviceCls)];
    [self.serviceLock unlock];
}

- (void)removeServiceWithProtocol:(Protocol *)protocol {
    if (!protocol) {
        return;
    }
    [self.serviceLock lock];
    NSString *classStr = [self.classesDict valueForKey:NSStringFromProtocol(protocol)];
    if (classStr) {
        [self.servicesDict removeObjectForKey:classStr];
    }
    [self.classesDict removeObjectForKey:NSStringFromProtocol(protocol)];
    [self.serviceLock unlock];
}

- (Class)getServiceClassWithProtocol:(Protocol *)protocol {
    if (!protocol) {
        return NULL;
    }
    NSString *classStr = [self.servicesDict valueForKey:NSStringFromProtocol(protocol)];
    if (classStr) {
        return NSClassFromString(classStr);
    }
    return NULL;
}

@end
