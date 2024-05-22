//
//  ZJImageMonitorViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2023/10/8.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import "ZJImageMonitorViewController.h"
#import <Masonry/Masonry.h>

@interface ZJImageMonitorViewController ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *testViewA;

@end

@implementation ZJImageMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"addsubView 层级设置";
    [self setUpView];
}

- (void)setUpView {
    self.containerView = [[UIView alloc] init];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    
    UIButton *addButton = [[UIButton alloc] init];
    addButton.layer.cornerRadius = 20;
    addButton.layer.masksToBounds = YES;
    [addButton setTitle:@"添加A" forState:(UIControlStateNormal)];
    [addButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    addButton.titleLabel.font = [UIFont systemFontOfSize:14];
    addButton.backgroundColor = [UIColor blueColor];
    addButton.tag = 1;
    [addButton addTarget:self action:@selector(showTestView:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.containerView addSubview:addButton];
    
    UIButton *removeButton = [[UIButton alloc] init];
    removeButton.layer.cornerRadius = 20;
    removeButton.layer.masksToBounds = YES;
    [removeButton setTitle:@"移除A" forState:(UIControlStateNormal)];
    [removeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    removeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    removeButton.backgroundColor = [UIColor greenColor];
    removeButton.tag = 2;
    [removeButton addTarget:self action:@selector(showTestView:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.containerView addSubview:removeButton];
    
    UIButton *testViewB = [[UIButton alloc] init];
    testViewB.layer.cornerRadius = 20;
    testViewB.layer.masksToBounds = YES;
    [testViewB setTitle:@"添加B" forState:(UIControlStateNormal)];
    [testViewB setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    testViewB.titleLabel.font = [UIFont systemFontOfSize:14];
    testViewB.backgroundColor = [UIColor purpleColor];
    testViewB.tag = 3;
    [testViewB addTarget:self action:@selector(testOPTIONS) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:testViewB];
    
    NSArray *widgetArr = @[addButton,removeButton,testViewB];
    
    [widgetArr mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:20 leadSpacing:15 tailSpacing:15];
    [widgetArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(90);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)showTestView:(UIButton *)sender {
    if (sender.tag == 1) {
        [self.containerView addSubview:self.testViewA];
        [self.testViewA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 200));
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(200);
        }];
    } else if (sender.tag == 2) {
        [self.testViewA removeFromSuperview];
    } else if (sender.tag == 3) {
//        //展示随机的视图
//        UIView *testViewB = [[UIView alloc] init];
//        testViewB.backgroundColor = [UIColor blueColor];
//        [self.view addSubview:testViewB];
//        [testViewB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(250, 250));
//            make.centerX.mas_equalTo(0);
//            make.top.mas_equalTo(250);
//        }];
    }
}

- (void)showTestBView {
    //展示随机的视图
    UIView *testViewB = [[UIView alloc] init];
    testViewB.backgroundColor = [UIColor blueColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTestBView:)];
    [testViewB addGestureRecognizer:tap];
    [self.containerView addSubview:testViewB];
    [testViewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 250));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(250);
    }];
}

- (void)dismissTestBView:(UITapGestureRecognizer *)gesture {
    UIView *view = gesture.view;
    [view removeFromSuperview];
}


- (UIView *)testViewA{
    if (!_testViewA) {
        _testViewA = [[UIView alloc] init];
        _testViewA.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTestBView)];
        [_testViewA addGestureRecognizer:tap];
    }
    return _testViewA;
}

@end
