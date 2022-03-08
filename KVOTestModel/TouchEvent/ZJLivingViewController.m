//
//  ZJLivingViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/11/26.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJLivingViewController.h"

@interface ZJLivingViewController ()

@end

@implementation ZJLivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self addTestWidgets];
}

- (void)addTestWidgets{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 100, 200, 30)];
    label.text = @"show Name";
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"ZJLivingViewController touchesBegan");
}

@end
