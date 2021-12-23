//
//  ZJContainerViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/11/26.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJContainerViewController.h"

@interface ZJContainerViewController ()

@end

@implementation ZJContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"ZJContainerViewController touchesBegan");
}

@end
