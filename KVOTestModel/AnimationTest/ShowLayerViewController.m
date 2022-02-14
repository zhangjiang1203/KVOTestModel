//
//  ShowLayerViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2022/2/11.
//  Copyright © 2022 zhangjiang. All rights reserved.
//

#import "ShowLayerViewController.h"
#import "CustomShowView.h"

@interface ShowLayerViewController ()

@property (nonatomic, strong) CustomShowView *showView;

@property (nonatomic, strong) UISlider *sliderValue;

@end

@implementation ShowLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"layer测试";
    [self upSetShowView];
}


- (void)upSetShowView{
    self.showView = [[CustomShowView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.showView.storkeColor = [UIColor grayColor];
    [self.view addSubview:self.showView];
    
    self.sliderValue = [[UISlider alloc]initWithFrame:CGRectMake(100, 250, 200, 30)];
    self.sliderValue.value = 0.5;
    [self.sliderValue addTarget:self action:@selector(valueChangeSlider:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:self.sliderValue];
}

- (void)valueChangeSlider:(UISlider *)sender{
    NSLog(@"开始变化=====%f",sender.value);
    self.showView.progress = sender.value;
}

@end
