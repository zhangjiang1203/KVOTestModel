//
//  YogaSpecialLayoutViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/12/28.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "YogaSpecialLayoutViewController.h"
//#import <YogaKit/UIView+Yoga.h>


@interface YogaSpecialLayoutViewController ()

@end

@implementation YogaSpecialLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"special layout";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view configureLayoutWithBlock:^(YGLayout *layout) {
//        layout.isEnabled = YES;
//        layout.paddingTop = YGPointValue(100);
//        layout.flexDirection = YGFlexDirectionColumn;
////        layout.justifyContent = YGJustifyCenter;
//    }];
//    [self setSpecialLayout1];
//    [self setSpecialLayout2];
//    [self setSpecialLayout3];
}

//- (void)setSpecialLayout1{
//    UIView *blueView = [UIView new];
//    blueView.backgroundColor = [UIColor blueColor];
//    [blueView configureLayoutWithBlock:^(YGLayout *layout) {
//        layout.isEnabled = YES;
//        layout.flexGrow = 1;
//        layout.marginTop = YGPointValue(60);
//        layout.alignItems = YGAlignCenter;
//    }];
//    [self.view addSubview:blueView];
//    
//    UIImageView *topImageView = [UIImageView new];
//    topImageView.backgroundColor = [UIColor greenColor];
//    topImageView.layer.cornerRadius = 50;
//    topImageView.layer.masksToBounds = YES;
//    [topImageView configureLayoutWithBlock:^(YGLayout *layout) {
//        layout.isEnabled = YES;
//        layout.marginTop = YGPointValue(-50);
//        layout.height = YGPointValue(100);
//        layout.aspectRatio = 1;
//    }];
//    [blueView addSubview:topImageView];
//    [self.view.yoga applyLayoutPreservingOrigin:YES];
//}
//
//#pragma mark -使用绝对定位和相对定位
//- (void)setSpecialLayout2{
//    UIView *bgView = [UIView new];
//    bgView.backgroundColor = [UIColor grayColor];
//    [bgView configureLayoutWithBlock:^(YGLayout *layout) {
//        layout.isEnabled = YES;
//        layout.flexDirection = YGFlexDirectionRow;
//    }];
//    [self.view addSubview:bgView];
//    
//    //设置子view
//    UIView *wrapper = [UIView new];
//    [wrapper configureLayoutWithBlock:^(YGLayout *layout) {
//        layout.isEnabled = YES;
//        layout.flexGrow = 1;
//        layout.position = YGPositionTypeRelative;
//    }];
//    [bgView addSubview:wrapper];
//    
//    UIImageView *userImageView = [UIImageView new];
//    userImageView.backgroundColor = [UIColor redColor];
//    [userImageView configureLayoutWithBlock:^(YGLayout *layout) {
//        layout.isEnabled = YES;
//        layout.width = YGPointValue(140);
//        layout.aspectRatio = 1;
//    }];
//    [bgView addSubview:userImageView];
//    
//    UIView *rapWrapper = [UIView new];
//    rapWrapper.backgroundColor = [UIColor blueColor];
//    [rapWrapper configureLayoutWithBlock:^(YGLayout *layout) {
//        layout.isEnabled = YES;
//        layout.flexWrap = YGWrapWrap;
//        layout.flexDirection = YGFlexDirectionRow;
//        layout.position = YGPositionTypeAbsolute;
//    }];
//    [wrapper addSubview:rapWrapper];
//    
//    //添加子view
//    for(int i = 0 ;i < 8 ;i++){
//        UILabel *itemLabel = [UILabel new];
//        itemLabel.font = [UIFont systemFontOfSize:10];
//        itemLabel.text = [NSString stringWithFormat:@"%d",i];
//        itemLabel.textColor = [UIColor redColor];
//        itemLabel.backgroundColor = [UIColor greenColor];
//        [itemLabel configureLayoutWithBlock:^(YGLayout *layout) {
//            layout.isEnabled = YES;
//            layout.width = YGPointValue(60);
//            layout.height = YGPointValue(30);
//            layout.marginHorizontal = YGPointValue(8);
//            layout.marginVertical = YGPointValue(6);
//        }];
//        [rapWrapper addSubview:itemLabel];
//    }
//    [self.view.yoga applyLayoutPreservingOrigin:YES];
//}
//
//- (void)setSpecialLayout3{
//    UIScrollView *myScrollView = [UIScrollView new];
//    myScrollView.backgroundColor = [UIColor blueColor];
//    [myScrollView configureLayoutWithBlock:^(YGLayout *layout) {
//        layout.isEnabled = YES;
//        layout.flexGrow = 1;
//        layout.position = YGPositionTypeRelative;
//    }];
//    [self.view addSubview:myScrollView];
//    
//    UIView *contentView = [UIView new];
//    [contentView configureLayoutWithBlock:^(YGLayout *layout) {
//        layout.isEnabled = YES;
//        layout.height = YGPointValue(1200);
//        layout.position = YGPositionTypeAbsolute;
//    }];
//    [myScrollView addSubview:contentView];
//    
//    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [button setTitle:@"按钮" forState:(UIControlStateNormal)];
//    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    button.backgroundColor = [UIColor systemPinkColor];
//    [button configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
//        layout.isEnabled = YES;
//        layout.height = YGPointValue(50);
//    }];
//    [self.view addSubview:button];
//    
//    [self.view.yoga applyLayoutPreservingOrigin:YES];
//    myScrollView.contentSize = contentView.bounds.size;
////    [myScrollView setContentSize:CGSizeMake(0, contentView.bounds.size.height)];
//    
//}

@end
