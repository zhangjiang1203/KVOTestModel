//
//  SwizzleHook.m
//  DYFPerformanceMonitor
//
//  Created by liuqi on 2020/2/4.
//

#import "SwizzleHook.h"
#import <objc/runtime.h>

@implementation SwizzleHook

void dyphookMethod(Class originalClass, SEL originalSel, Class replaceClass, SEL replaceSel, BOOL isClassMethod) {
    
    Method originalMethod = NULL;
    Method replaceMethod = NULL;
    
    if (isClassMethod) {
        originalMethod = class_getClassMethod(originalClass, originalSel);
        replaceMethod = class_getClassMethod(replaceClass, replaceSel);
    } else {
        originalMethod = class_getInstanceMethod(originalClass, originalSel);
        replaceMethod = class_getInstanceMethod(replaceClass, replaceSel);
    }
    if (!replaceMethod || !originalMethod) {
        return;
    }
    
    IMP originalIMP = method_getImplementation(originalMethod);
    IMP replaceIMP = method_getImplementation(replaceMethod);
    
    const char *originalType = method_getTypeEncoding(originalMethod);
    const char *replaceType = method_getTypeEncoding(replaceMethod);

    if (isClassMethod) {
        Class originalMetaClass = objc_getMetaClass(class_getName(originalClass));
        Class replaceMetaClass = objc_getMetaClass(class_getName(replaceClass));
        class_replaceMethod(replaceMetaClass, replaceSel, originalIMP, originalType);
        class_replaceMethod(originalMetaClass, originalSel, replaceIMP, replaceType);
    } else {
        class_replaceMethod(replaceClass, replaceSel, originalIMP, originalType);
        class_replaceMethod(originalClass, originalSel, replaceIMP, replaceType);
    }
}

void dyphookAddMethod(Class originalClass, SEL originalSel, Class replaceClass, SEL replaceSel, SEL noneSel) {
    
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    Method replaceMethod = class_getInstanceMethod(replaceClass, replaceSel);
    
    //若相应方法未实现则添加
    if (!originalMethod) {
        Method noneMethod = class_getInstanceMethod(replaceClass, noneSel);
        BOOL didAddNoneMethod = class_addMethod(originalClass, originalSel, method_getImplementation(noneMethod), method_getTypeEncoding(noneMethod));
        if (didAddNoneMethod) {
#if DEBUG
            NSLog(@"%@没有实现方法: %@, 已注入", NSStringFromClass(originalClass), NSStringFromSelector(originalSel));
#endif
        }
        return;
    }
    
    //若实现了, 先添加方法到该类方法列表, 再交换
    BOOL didAddReplaceMethod = class_addMethod(originalClass, replaceSel, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod));
    if (didAddReplaceMethod) {
        Method newMethod = class_getInstanceMethod(originalClass, replaceSel);
        method_exchangeImplementations(originalMethod, newMethod);
#if DEBUG
        NSLog(@"%@已实现方法: %@, 已交换", NSStringFromClass(originalClass), NSStringFromSelector(originalSel));
#endif
    } else {
        method_exchangeImplementations(originalMethod, replaceMethod);
    }
}

void dyphookAddNewMethod(Class originalClass, SEL originalSel, Class replaceClass, SEL replaceSel) {
    
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    Method replaceMethod = class_getInstanceMethod(replaceClass, replaceSel);
    
    //若相应方法未实现则添加
    if (!originalMethod) {
        return;
    }
    
    //若实现了, 先添加方法到该类方法列表, 再交换
    BOOL didAddReplaceMethod = class_addMethod(originalClass, replaceSel, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod));
    if (didAddReplaceMethod) {
        Method newMethod = class_getInstanceMethod(originalClass, replaceSel);
        method_exchangeImplementations(originalMethod, newMethod);
#if DEBUG
        NSLog(@"%@已实现方法: %@, 已交换", NSStringFromClass(originalClass), NSStringFromSelector(originalSel));
#endif
    } else {
        method_exchangeImplementations(originalMethod, replaceMethod);
    }
}
@end
