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


// 判断是否是objective
BOOL isObjectType(const char *objcType);
// 是否是block
BOOL isBlockType(const char *unqualifiedObjcType);
// 获取对应的Unqualified type
BOOL isUnqualifiedClassType(const char *unqualifiedType);

const char *service_typeWithoutQualifiers(const char *objcType);

// invocation的返回值
id service_returnValue(NSInvocation *invocation);

// 匹配class 类方法
void matchClassMethodWithClass(Class cls,Protocol *protocol);
// 匹配class 实例方法
void matchClassInstanceMethodWithClass(Class cls,Protocol *protocol);


void addInvocationParamters(NSInvocation *invocation);


id NS_REQUIRES_NIL_TERMINATION __serviceRequestion(Protocol *protocol,SEL selector,...){

    Class cls = [ZJServiceManager getServiceClassWithProtocol:protocol];
    // 该类是否存在 该类是否实现该协议
    if (!cls || ![cls conformsToProtocol:protocol]) {
        return NULL;
    }
    
    if (![cls respondsToSelector:selector] && ![[[cls alloc]init] respondsToSelector:selector]) {
        return NULL;
    }

    NSMethodSignature *clsSignature;
    id target;
    if ([cls respondsToSelector:selector]) {
        target = cls;
        clsSignature = [target methodSignatureForSelector:selector];
    }else if([[[cls alloc]init] respondsToSelector:selector]) {
        target = [[cls alloc]init];
        clsSignature = [target methodSignatureForSelector:selector];
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:clsSignature];
    [invocation setSelector:selector];
    [invocation setTarget:target];
    
    NSString *selectorName = NSStringFromSelector(selector);
    NSArray *paramArr = [selectorName componentsSeparatedByString:@":"];
    NSUInteger paramCount = paramArr.count - 1;
    if (paramCount == 0) {
        [invocation invoke];
        return service_returnValue(invocation);
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
        
        //开始处理参数
        if (isObjectType(argType)) {
            SET_NEXT_PARAMETER(id);
        }else if (strcmp(argType, @encode(char)) == 0){
            SET_NEXT_PARAMETER(char);
        }else if (strcmp(argType, @encode(int)) == 0){
            SET_NEXT_PARAMETER(int);
        }else if (strcmp(argType, @encode(short)) == 0){
            SET_NEXT_PARAMETER(short);
        }else if (strcmp(argType, @encode(long)) == 0){
            SET_NEXT_PARAMETER(long);
        } else if (strcmp(argType, @encode(long long)) == 0) {
            SET_NEXT_PARAMETER(long long);
        } else if (strcmp(argType, @encode(unsigned char)) == 0) {
            SET_NEXT_PARAMETER(unsigned char);
        } else if (strcmp(argType, @encode(unsigned int)) == 0) {
            SET_NEXT_PARAMETER(unsigned int);
        } else if (strcmp(argType, @encode(unsigned short)) == 0) {
            SET_NEXT_PARAMETER(unsigned short);
        } else if (strcmp(argType, @encode(unsigned long)) == 0) {
            SET_NEXT_PARAMETER(unsigned long);
        } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
            SET_NEXT_PARAMETER(unsigned long long);
        } else if (strcmp(argType, @encode(float)) == 0) {
            SET_NEXT_PARAMETER(float);
        } else if (strcmp(argType, @encode(double)) == 0) {
            SET_NEXT_PARAMETER(double);
        } else if (strcmp(argType, @encode(BOOL)) == 0) {
            SET_NEXT_PARAMETER(BOOL);
        } else if (strcmp(argType, @encode(char *)) == 0) {
            SET_NEXT_PARAMETER(char *);
        } else if (strcmp(argType, @encode(void (^)(void))) == 0) {
            SET_NEXT_PARAMETER(id);
        } else if (strcmp(argType, @encode(SEL)) == 0)  {
            SET_NEXT_PARAMETER(SEL);
        }else if (strcmp(argType, @encode(CGSize)) == 0)  {
            CGSize parameter = CGSizeZero;
            parameter = va_arg(ap, CGSize);
            [invocation setArgument:&parameter atIndex:selectorIndex];
            selectorIndex ++;
        } else if (strcmp(argType, @encode(CGPoint)) == 0)  {
            CGPoint parameter = CGPointZero;
            parameter = va_arg(ap, CGPoint);
            [invocation setArgument:&parameter atIndex:selectorIndex];
            selectorIndex ++;
        } else if (strcmp(argType, @encode(CGRect)) == 0) {
            CGRect parameter = CGRectZero;
            parameter = va_arg(ap, CGRect);
            [invocation setArgument:&parameter atIndex:selectorIndex];
            selectorIndex ++;
        } else {
            NSString *argDescStr = [NSString stringWithFormat:@"__moduleOrzAsk Argument type ['%s'] not supported", argType];
            NSLog(@"%@", argDescStr);
            selectorIndex ++;
            continue;
        }
    }
    
    va_end(ap);
    
    [invocation invoke];
    id returnValue = service_returnValue(invocation);
    
    return returnValue;
}




BOOL isObjectType(const char *objcType){
    const char *unqualifiedObjCType = service_typeWithoutQualifiers(objcType);
    char objectiveType[] = @encode(id);
    if (strcmp(unqualifiedObjCType, objectiveType) == 0 || isUnqualifiedClassType(objectiveType)) return YES;
    //有时，对象的类名被附加到类型上，用双引号括起来
    if (strncmp(unqualifiedObjCType, objectiveType, sizeof(objectiveType) - 1) == 0 && unqualifiedObjCType[sizeof(objcType) - 1] == '"') {
        return YES;
    }
    
    //如果returnType是一个对象的类型定义，它的形式为^{OriginClass=#}
    NSString *regexStr = @"^\\^\\{(.*)=#.*\\}";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:NULL];
    NSString *type = [NSString stringWithCString:unqualifiedObjCType encoding:NSASCIIStringEncoding];
    if ([regex numberOfMatchesInString:type options:0 range:NSMakeRange(0, type.length)] > 0) {
        return YES;
    }
    
    return isUnqualifiedClassType(unqualifiedObjCType);
    
}

BOOL isBlockType(const char *unqualifiedObjcType){
    char blockType[] = @encode(void(^)(void));
    if (strcmp(unqualifiedObjcType, blockType) == 0) {
        return YES;
    }
    if (strncmp(unqualifiedObjcType, blockType, sizeof(blockType) -1) == 0 &&
        unqualifiedObjcType[sizeof(blockType) - 1] == '<'){
        return YES;
    }
    return NO;
}

BOOL isUnqualifiedClassType(const char *unqualifiedType){
    return (strcmp(unqualifiedType, @encode(Class)) == 0);
}

const char *service_typeWithoutQualifiers(const char *objcType){
    while(strchr("rnNoORV", objcType[0]) != NULL)
        objcType += 1;
    return objcType;
}


id service_returnValue(NSInvocation *invocation) {
    #define WRAP_AND_RETURN(type) \
        do { \
            type val = 0; \
            [invocation getReturnValue:&val]; \
            return @(val); \
        } while (0)

        const char *returnType = invocation.methodSignature.methodReturnType;
        // Skip const type qualifier.
        if (returnType[0] == 'r') {
            returnType++;
        }

        if (strcmp(returnType, @encode(id)) == 0 || strcmp(returnType, @encode(Class)) == 0 || strcmp(returnType, @encode(void (^)(void))) == 0) {
            __autoreleasing id returnObj;
            [invocation getReturnValue:&returnObj];
            return returnObj;
        } else if (strcmp(returnType, @encode(char)) == 0) {
            WRAP_AND_RETURN(char);
        } else if (strcmp(returnType, @encode(int)) == 0) {
            WRAP_AND_RETURN(int);
        } else if (strcmp(returnType, @encode(short)) == 0) {
            WRAP_AND_RETURN(short);
        } else if (strcmp(returnType, @encode(long)) == 0) {
            WRAP_AND_RETURN(long);
        } else if (strcmp(returnType, @encode(long long)) == 0) {
            WRAP_AND_RETURN(long long);
        } else if (strcmp(returnType, @encode(unsigned char)) == 0) {
            WRAP_AND_RETURN(unsigned char);
        } else if (strcmp(returnType, @encode(unsigned int)) == 0) {
            WRAP_AND_RETURN(unsigned int);
        } else if (strcmp(returnType, @encode(unsigned short)) == 0) {
            WRAP_AND_RETURN(unsigned short);
        } else if (strcmp(returnType, @encode(unsigned long)) == 0) {
            WRAP_AND_RETURN(unsigned long);
        } else if (strcmp(returnType, @encode(unsigned long long)) == 0) {
            WRAP_AND_RETURN(unsigned long long);
        } else if (strcmp(returnType, @encode(float)) == 0) {
            WRAP_AND_RETURN(float);
        } else if (strcmp(returnType, @encode(double)) == 0) {
            WRAP_AND_RETURN(double);
        } else if (strcmp(returnType, @encode(BOOL)) == 0) {
            WRAP_AND_RETURN(BOOL);
        } else if (strcmp(returnType, @encode(char *)) == 0) {
            WRAP_AND_RETURN(const char *);
        } else if (strcmp(returnType, @encode(void)) == 0) {
            return NULL;
        } else {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(returnType, &valueSize, NULL);

            unsigned char valueBytes[valueSize];
            [invocation getReturnValue:valueBytes];

            return [NSValue valueWithBytes:valueBytes objCType:returnType];
        }

        return nil;

    #undef WRAP_AND_RETURN
}
