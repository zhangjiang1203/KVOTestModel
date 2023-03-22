//
//  ZJModuleTestViewController.m
//  KVOTestModel
//
//  Created by douyu on 2023/3/6.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import "ZJModuleTestViewController.h"
#import <Masonry/Masonry.h>
#import "MTMediatorModel.h"
#import "ZJTestQueueManager.h"

@interface ZJModuleTestViewController ()

@property (nonatomic, copy) NSString *detailURL;

@property (nonatomic, strong) UIButton *showMedaitorButton;

@property (nonatomic, strong) UIButton *cleanBtn;

@property (nonatomic, strong) ZJTestQueueManager *testManager;

@property (nonatomic, assign) NSInteger count;

@end

@implementation ZJModuleTestViewController
//从当前视图返回上一层
- (void)didMoveToParentViewController:(UIViewController *)parent{
    if(parent == nil){
        [self.testManager cleanSemaphore];
    }
}

- (instancetype)initWithURLString:(NSString *)detailURL{
    self = [super init];
    if(self) {
        self.detailURL = detailURL;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.testManager = [[ZJTestQueueManager alloc] init];
    self.count = 0;
    
    NSLog(@"当前设置的url==%@",self.detailURL);
    
    _showMedaitorButton = [[UIButton alloc]init];
    _showMedaitorButton.tag = 1;
    [_showMedaitorButton setTitle:@"获取组件对象" forState:(UIControlStateNormal)];
    [_showMedaitorButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [_showMedaitorButton addTarget:self action:@selector(showMedaitorButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_showMedaitorButton];
    
    [_showMedaitorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(100);
    }];
    
    _cleanBtn = [[UIButton alloc]init];
    _cleanBtn.tag = 2;
    [_cleanBtn setTitle:@"开始清空" forState:(UIControlStateNormal)];
    [_cleanBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [_cleanBtn addTarget:self action:@selector(showMedaitorButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_cleanBtn];
    
    [_cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(self.showMedaitorButton.mas_bottom).offset(30);
    }];
}

- (void)showMedaitorButtonAction:(UIButton *)sender {
//    UIViewController *vc = [MTMediatorModel detailViewControllerWithURL:@"hello world"];
//    vc.title = @"组件设置demo";
//    [self.navigationController pushViewController:vc animated:YES];
    
    if(sender.tag == 1) {
        self.count += 1;
        [self.testManager insertCustomData:[NSString stringWithFormat:@"展示数据==%zd",self.count]];
    } else {
        [self.testManager cleanSemaphore];
    }
}


@end
