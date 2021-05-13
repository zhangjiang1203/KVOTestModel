//
//  ZJServiceDefine.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJServiceDefine.h"
#import "ZJServiceManager.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@implementation ZJServiceDefine

- (id)getserviceRequestWith:(Protocol *)protocol selector:(SEL)selector object:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION {
    Class eventCls = [ZJServiceManager getServiceClassWithProtocol:protocol];
    if (!eventCls || ![eventCls conformsToProtocol:protocol]) {
        return NULL;
    }
    
    if (![eventCls respondsToSelector:selector] && ![[[eventCls alloc]init] respondsToSelector:selector]) {
        return NULL;
    }
    
    //匹配类方法
    if ([eventCls respondsToSelector:selector]) {
        [self matchClassMethodWithClass:eventCls selector:selector];
    }else if ([[[eventCls alloc]init] respondsToSelector:selector]){
        //匹配实例方法
        [self matchInstanceMethodWithClass:eventCls selector:selector];
    }
    
    
    //优先匹配实例方法展示数据
    
    //开始执行了
    NSLog(@"开始执行了");
    
    return NULL;
}

- (void)matchClassMethodWithClass:(Class)cls selector:(SEL)selector{
    NSMethodSignature *clsSignature = [cls methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:clsSignature];
    [invocation setSelector:selector];
    [invocation setTarget:cls];
    
    NSString *selectorName = NSStringFromSelector(selector);
    NSArray *paramArr = [selectorName componentsSeparatedByString:@":"];
    NSUInteger paramCount = paramArr.count - 1;
    if (paramCount == 0) {
        [invocation invoke];
        
        return ;
    }
    
    va_list ap;
    va_start(ap, selector);
    NSInteger selectorIndex = 2;
    
#define SET_NEXT_PARAMETER(type)\
    type parameter;\
    parameter = va_arg(ap, type);\
    if(!parameter) {\
        selectorIndex++;\
        continue;\
    }\
    [invocation setArgument:&parameter atIndex:selectorIndex];\
    selectorIndex++;\

    while (paramCount - (selectorIndex - 2) > 0) {
        // 添加参数
        const char *argType = [invocation.methodSignature getArgumentTypeAtIndex:selectorIndex];
        // 跳过const类型限定符
        if (argType[0] == 'r') {
            argType++;
        }
    }
    
    
}


- (void)matchInstanceMethodWithClass:(Class)cls selector:(SEL)selector{
    
}

- (BOOL)isObjectType:(const char *)objType {
    const char *unqualifiedObjCType = [self typeWithoutQualifiers:objType];
}

- (const char *)typeWithoutQualifiers:(const char *)objType{
    while (strchr("rnNoORV", objType[0]) != NULL) {
        objType += 1;
    }
    return objType;
}

- (BOOL) isUnqualifiedClassType:(const char *)unqualifiedObjCType {
    return (strcmp(unqualifiedObjCType, @encode(Class)) == 0);
}

//block类型
- (BOOL)isUnqualifiedBlockType:(const char *)unqualifiedObjcType{
    char blockType = @encode(void(^)(void));
    if (strcmp(unqualifiedObjcType, blockType) == 0) {
        return YES;
    }
    if (strncmp(unqualifiedObjcType, blockType, sizeof(blockType) -1) == 0 &&
        unqualifiedObjcType[sizeof(blockType) - 1] == '<'){
        return YES;
    }
    return NO;
}


@end


id NS_REQUIRES_NIL_TERMINATION __serviceRequestion(Protocol *protocol,SEL selector,...){

    Class eventCls = [ZJServiceManager getServiceClassWithProtocol:protocol];
    if (!eventCls || ![eventCls conformsToProtocol:protocol]) {
        return NULL;
    }
    
    if (![eventCls respondsToSelector:selector] && ![[[eventCls alloc]init] respondsToSelector:selector]) {
        return NULL;
    }
    NSLog(@"匹配的类方法,或实例方法");
    
    if ([eventCls respondsToSelector:selector]) {
        
    }
    
    NSMethodSignature *signature = [eventCls methodSignatureForSelector:selector];
    
    //优先匹配实例方法展示数据
    
    //开始执行了
    NSLog(@"开始执行了");
    
    return NULL;
}
