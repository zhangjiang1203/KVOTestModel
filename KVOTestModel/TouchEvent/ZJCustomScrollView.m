//
//  ZJCustomScrollView.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/11/26.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJCustomScrollView.h"

@implementation ZJCustomScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"ZJCustomScrollView touchesBegan");
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return nil;
}

@end
