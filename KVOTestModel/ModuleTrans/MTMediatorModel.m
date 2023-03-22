//
//  MTMediatorModel.m
//  KVOTestModel
//
//  Created by douyu on 2023/3/6.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import "MTMediatorModel.h"

@implementation MTMediatorModel

+ (__kindof UIViewController *)detailViewControllerWithURL:(NSString *)detailURL{
    Class detailVC = NSClassFromString(@"ZJModuleTestViewController");
    UIViewController *vc = [[detailVC alloc] performSelector:NSSelectorFromString(@"initWithURLString:") withObject:detailURL];
    return vc;
}


@end
