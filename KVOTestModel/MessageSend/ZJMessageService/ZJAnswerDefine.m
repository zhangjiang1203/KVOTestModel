//
//  ZJAnswerDefine.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJAnswerDefine.h"
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



id NS_REQUIRES_NIL_TERMINATION __serviceRequestion(Protocol *protocol,SEL selector,...){

    Class cls = [ZJServiceManager getServiceClassWithProtocol:protocol];
    // 该类是否存在 该类是否实现该协议
    if (!cls || ![cls conformsToProtocol:protocol]) {
        return NULL;
    }
    
    if (![cls respondsToSelector:selector] && ![[[cls alloc]init] respondsToSelector:selector]) {
        return NULL;
    }

    id target;
    if ([cls respondsToSelector:selector]) {
        target = cls;
    }else if([[[cls alloc]init] respondsToSelector:selector]) {
        // 初始化该对象 获取实例
        target = [[cls alloc]init];
    }
    
    NSMethodSignature *clsSignature = [target methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:clsSignature];
    //invocation 设置对应的target和selector 并没有强引用，当target被释放 然后再去invoke该invocation，就会造成野指针异常，所以要调用retainArguments方法来强引用参数(包括target 和 selector)
    [invocation retainArguments];
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
    
    /*
     考虑到 getReturnValue 方法仅仅是将返回数据拷贝到提供的缓存区（retLoc）内，并不会考虑到此处的内存管理，所以如果返回数据是对象类型的，实际上获取到的返回数据是 __unsafe_unretained 类型的，上层函数再�把它作为返回数据返回的时候就会造成野指针异常。
     */
    
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
            /*
             返回为对像的单独处理
             使用__bridge将缓存区转换为Objective-C类型，这种做法其实跟第一种相似，但是我们建议使用这种方式来解决以上问题，因为getReturnValue本来就是给缓存区写入数据，缓存区声明为void*类型更为合理，然后通过__bridge方式转换为Objective-C类型，并且将该内存区的内存管理交给 ARC。
             */
            void  *returnObj = NULL;
            [invocation getReturnValue:&returnObj];
            id result = (__bridge id)(returnObj);
            return result;
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
