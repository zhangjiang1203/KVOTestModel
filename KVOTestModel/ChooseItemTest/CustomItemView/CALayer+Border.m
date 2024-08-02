//
//  CALayer+Border.m
//  KVOTestModel
//
//  Created by 张江 on 2024/7/18.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

#import "CALayer+Border.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation CALayer (Border)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSel = @selector(setBorderWidth:);
        SEL swizzledSel = @selector(swizzled_setBorderWith:);
        
        Method originalM = class_getInstanceMethod(class, originalSel);
        Method swizzledM = class_getInstanceMethod(class, swizzledSel);
        
        BOOL didAddMethod = class_addMethod(class, originalSel, method_getImplementation(swizzledM), method_getTypeEncoding(swizzledM));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSel, method_getImplementation(originalM), method_getTypeEncoding(originalM));
        }else{
            method_exchangeImplementations(originalM, swizzledM);
        }
    });
}

#pragma mark -解决 高分辨率手机上 0.5pt绘制异常问题
- (void)swizzled_setBorderWith:(CGFloat)borderWidth {
    
    CGFloat width = borderWidth;
    if (width == 0.5 && [UIScreen mainScreen].scale >= 3) {
        width = 1 / [UIScreen mainScreen].scale;
    }
    
    [self swizzled_setBorderWith:width];
}


@end
