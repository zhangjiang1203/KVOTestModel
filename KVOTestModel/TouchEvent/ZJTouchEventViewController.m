//
//  ZJTouchEventViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/11/26.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJTouchEventViewController.h"
#import "ZJContainerViewController.h"
#import "ZJLivingViewController.h"
#import "ZJCustomScrollView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface ZJTouchEventViewController ()

@property (nonatomic, strong) ZJLivingViewController *liveVC;

@property (nonatomic, strong) ZJContainerViewController *containerVC;

@property (nonatomic, strong) ZJCustomScrollView *swipeScrollView;


@end

@implementation ZJTouchEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRenderLivingView];
    [self setClearScreenViewConfig];
    
}

- (void)setRenderLivingView{
    self.liveVC = [[ZJLivingViewController alloc]init];
    [self addChildViewController:self.liveVC];
    self.liveVC.view.frame = self.view.bounds;
    [self.view addSubview:self.liveVC.view];
    
    [self.liveVC.view bringSubviewToFront:self.swipeScrollView];
    
    //添加手势
    UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(startGesture:)];
//    swipe.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    [self.liveVC.view addGestureRecognizer:swipe];
}

- (void)startGesture:(UIPanGestureRecognizer *)reg{
    CGPoint translation = [reg translationInView:self.view];
    
    

}

- (void)setClearScreenViewConfig{
    //设置scrollview 进行一个层级操作
    self.swipeScrollView = [[ZJCustomScrollView alloc]initWithFrame:self.view.bounds];
    self.swipeScrollView.showsVerticalScrollIndicator = NO;
    self.swipeScrollView.showsHorizontalScrollIndicator = NO;
    self.swipeScrollView.pagingEnabled = YES;
    self.swipeScrollView.bounces = NO;
    self.swipeScrollView.contentSize = CGSizeMake(kWidth * 2, 0);
    [self.view insertSubview:self.swipeScrollView aboveSubview:self.liveVC.view];
    [self.swipeScrollView setContentOffset:CGPointMake(kWidth, 0) animated:NO];
    self.swipeScrollView.alpha = 0;
    [UIView animateWithDuration:.4 animations:^{
        self.swipeScrollView.alpha = 1;
    }];
    
    self.containerVC = [[ZJContainerViewController alloc]init];
    self.containerVC.view.frame = CGRectMake(kWidth, 0, kWidth, kHeight);
    [self addChildViewController:self.containerVC];
    [self.swipeScrollView addSubview:self.containerVC.view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"ZJTouchEventViewController touchesBegan");
}
@end
