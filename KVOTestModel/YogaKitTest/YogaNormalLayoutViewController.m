//
//  YogaNormalLayoutViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/12/28.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "YogaNormalLayoutViewController.h"
#import <YogaKit/UIView+Yoga.h>

static NSInteger const defaultTag = 100;

#define Module1Arr @[@"门票",@"酒店",@"周边游",@"民宿客栈",@"国际酒店",@"周边精选"]

#define Module2Arr @[@"机票",@"火车票",@"汽车票",@"国际机票",@"极速抢票",@"用车*接送机"]

#define Module3Arr @[@"旅游",@"出境游",@"游轮",@"国内游",@"攻略游记"]

#define Module4Arr @[@"金融理财",@"保险",@"贷款*分期游"]


#pragma mark - 按钮相关布局设置
#define kSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define paddingNo 3
#define marginNo .5f
#define columnNo 3
#define btnHeight 62
#define btnWidth ((kSCREENWIDTH - paddingNo*2 - columnNo*marginNo*2) / columnNo)

@interface YogaNormalLayoutViewController ()

@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation YogaNormalLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YogaKit Normal Test";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.paddingTop = YGPointValue(100);
    }];
    [self setUpModule1];
    [self setUpModule2];
    [self setUpModule3];
    [self setUpModule4];
    
    [self.view.yoga applyLayoutPreservingOrigin:YES];
}

- (void)setUpModule1{
    UIView *bgView = [UIView new];
    [self.view addSubview:bgView];
    [bgView configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionRow;//设置水平方向为水平布局
        layout.padding = YGPointValue(paddingNo);
        layout.flexWrap = YGWrapWrap; //自动换行
    }];
    
    //添加按钮
    for (int i = 0; i < Module1Arr.count; i++) {
        UIButton *button = [self createItemButton:Module1Arr[i] bgColor:[UIColor systemPinkColor] index:i];
        [bgView addSubview:button];
        [button configureLayoutWithBlock:^(YGLayout *layout) {
            layout.isEnabled = YES;
            layout.width = YGPointValue(btnWidth);
            layout.height = YGPointValue(btnHeight);
            layout.margin = YGPointValue(marginNo);
        }];
    }
}

- (void)setUpModule2{
    UIView *bgView = [UIView new];
    [self.view addSubview:bgView];
    [bgView configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionRow;
        layout.padding = YGPointValue(paddingNo);
        layout.flexWrap = YGWrapWrap;
    }];
    
    NSInteger index = Module1Arr.count;
    for (NSInteger i = 0 ; i < Module2Arr.count; i++) {
        UIButton *button = [self createItemButton:Module2Arr[i] bgColor:[UIColor systemBlueColor] index:i + index];
        [bgView addSubview:button];
        
        [button configureLayoutWithBlock:^(YGLayout *layout) {
            layout.isEnabled = YES;
            layout.width = YGPointValue(btnWidth);
            layout.height = YGPointValue(btnHeight);
            layout.margin = YGPointValue(marginNo);
        }];
    }
}

- (void)setUpModule3{
    //对于这种要分为两个模块进行布局
    UIView *bgView = [UIView new];
    [self.view addSubview:bgView];
    [bgView configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionRow;
        layout.padding = YGPointValue(paddingNo);
    }];
    
    //设置大button
    NSInteger index = Module1Arr.count + Module2Arr.count;
    UIButton *button = [self createItemButton:Module3Arr[0] bgColor:[UIColor systemGreenColor] index:index];
    [bgView addSubview:button];
    [button configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(btnWidth);
        layout.height = YGPointValue(btnHeight * 2);
        layout.margin = YGPointValue(marginNo);
    }];
    
    //右边的小视图
    UIView *rightView = [UIView new];
    [bgView addSubview:rightView];
    [rightView configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionRow;
        layout.flexWrap = YGWrapWrap;
        layout.width = YGPointValue(KScreenWidth / columnNo * (columnNo - 1));
    }];
    
    for (NSInteger i = 1 ; i < Module3Arr.count; i++) {
        UIButton *button = [self createItemButton:Module3Arr[i] bgColor:[UIColor systemGreenColor] index:i + index];
        [rightView addSubview:button];
        [button configureLayoutWithBlock:^(YGLayout *layout) {
            layout.isEnabled = YES;
            layout.width = YGPointValue(btnWidth);
            layout.height = YGPointValue(btnHeight);
            layout.margin = YGPointValue(marginNo);
        }];
    }
}

- (void)setUpModule4{
    UIView *bgView = [UIView new];
    [self.view addSubview:bgView];
    [bgView configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionRow;
        layout.padding = YGPointValue(paddingNo);
        layout.flexWrap = YGWrapWrap;
    }];
    
    NSInteger index = Module1Arr.count + Module2Arr.count + Module3Arr.count;
    for (NSInteger i = 0 ; i < Module4Arr.count; i++) {
        UIButton *button = [self createItemButton:Module4Arr[i] bgColor:[UIColor systemYellowColor] index:i + index];
        [bgView addSubview:button];
        [button configureLayoutWithBlock:^(YGLayout *layout) {
            layout.isEnabled = YES;
            layout.width = YGPointValue(btnWidth);
            layout.height = YGPointValue(btnHeight);
            layout.margin = YGPointValue(marginNo);
        }];
    }
}

#pragma mark - 创建按钮快捷方式
- (UIButton *)createItemButton:(NSString *)title bgColor:(UIColor *)bgColor index:(NSInteger)index {
    UIButton *button = [UIButton new];
    button.tag = defaultTag + index;
    [button setTitle:title forState:(UIControlStateNormal)];
    button.backgroundColor = bgColor;
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(showCommonTarget:) forControlEvents:(UIControlEventTouchUpInside)];
    return button;
}

/// 按钮响应事件
- (void)showCommonTarget:(UIButton *)sender {
    
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    
    UIViewAnimationTransition tra = sender.selected?UIViewAnimationTransitionFlipFromLeft:UIViewAnimationTransitionFlipFromRight;
    [UIView animateWithDuration:.35 animations:^{
        [UIView setAnimationTransition:tra forView:sender cache:YES];
    }];
}
@end
