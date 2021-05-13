//
//  KXMoudleProtocolTestModel.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/12.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "KXMoudleProtocolTestModel.h"
#import "KXModuleOrz.h"

//其中第一个 KXModuleProtocol 是必须要遵守的协议， KXTestMoudleProtocol 是自定义要遵循的协议
@interface KXMoudleProtocolTestModel()<KXModuleProtocol,KXTestMoudleProtocol>

@end


@implementation KXMoudleProtocolTestModel

KXModuleOrz_Auto_Regist()


//注册对应的协议
+ (KXModulePriority)modulePriority{
    return KXModulePriorityLow;
}


//根据事件来注册
- (void)moduleCatchEvent:(KXModuleEvent)event {
    switch (event) {
        case KXModuleEventSetup:
        {
            [[KXModuleOrz shareInstance] orz_registAnswer:[self class] forQuestion:@protocol(KXTestMoudleProtocol)];
            //后续不希望没有激活的有活性
            [[KXModuleOrz shareInstance] orz_enableModuleActive:NO module:[self class]];
        }
            break;
        default:
            break;
    }
}


+ (nonnull NSString *)getCurrentName {
    return @"我就是 不一样的烟火";
}

+ (nonnull NSNumber *)showDifferentName {
    return [NSNumber numberWithInt:18];
}

@end
