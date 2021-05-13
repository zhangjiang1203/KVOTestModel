//
//  SendPersonModel.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/12.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "SendPersonModel.h"
#import <objc/runtime.h>
#import "SecondModel.h"

@implementation SendPersonModel



//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//    //方法转发的时机
//    if (sel == @selector(eat)) {
//        //调用下面的方法
//        IMP imp = class_getMethodImplementation(self.class, @selector(dynamicMethod));
//        class_addMethod(self.class, sel, imp, "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}
//
//
//- (void)dynamicMethod{
//
//}


///// 消息动态转发
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    SecondModel *model = [SecondModel new];
//    if ([model respondsToSelector:aSelector]) {
//        //让SeconModel 去响应该方法
//        return model;
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}


// 最后的方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *method = [super methodSignatureForSelector:aSelector];
//    if (!method) {
//        method = [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    }
    
    return method;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    SendPersonModel *person = SendPersonModel.new;
    if ([person respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:person];
    }else{
        NSLog(@"找不到方法实现===%@",NSStringFromSelector(sel));
    }
}

- (void)doesNotRecognizeSelector:(SEL)aSelector{
    NSLog(@"程序crash了");
}

@end
