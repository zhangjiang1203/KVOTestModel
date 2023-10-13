//
//  SwizzleHook.h
//  DYFPerformanceMonitor
//
//  Created by liuqi on 2020/2/4.
//

#import <Foundation/Foundation.h>

@interface SwizzleHook : NSObject

/**
 普通方法交换函数, 若目标未实现则不交换, 可用于类方法

 @param originalClass 原类
 @param originalSel 原方法
 @param replaceClass 目标类
 @param replaceSel 目标方法
 @param isClassMethod 是否是类方法
 */
void dyphookMethod(Class originalClass, SEL originalSel, Class replaceClass, SEL replaceSel, BOOL isClassMethod);

/**
 动态交换的方法函数, 若目标未实现, 则动态注入另一个方法

 @param originalClass 原类
 @param originalSel 原方法
 @param replaceClass 目标类
 @param replaceSel 目标方法
 @param noneSel 若没有实现该方法新添加方法
 */
void dyphookAddMethod(Class originalClass, SEL originalSel, Class replaceClass, SEL replaceSel, SEL noneSel);

void dyphookAddNewMethod(Class originalClass, SEL originalSel, Class replaceClass, SEL replaceSel);

@end
