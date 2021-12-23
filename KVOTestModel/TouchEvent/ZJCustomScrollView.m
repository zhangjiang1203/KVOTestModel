//
//  ZJCustomScrollView.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/11/26.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJCustomScrollView.h"

@interface ZJCustomScrollView ()<UIGestureRecognizerDelegate>

//需要响应的视图
@property (nonatomic, strong) UIView *responseView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) BOOL isShowingKeyboard;

@end

@implementation ZJCustomScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setObserverForScrollView];
    }
    return self;
}

- (void)setObserverForScrollView{
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    self.tapGesture.delegate = self;
    [self addGestureRecognizer:self.tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)setNeedResponseView:(UIView *)view{
    self.responseView = view;
}

#pragma mark - 设置响应方法
- (void)keyBoardHidden:(NSNotification *)noti{
    self.isShowingKeyboard = NO;
}

- (void)keyBoardShow:(NSNotification *)noti{
    self.isShowingKeyboard = YES;
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture{
    //执行自己的action
    
}

#pragma mark - 手势响应代理
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //判断手势是否响应
    if (self.isShowingKeyboard) return NO;
    
    CGPoint point = [gestureRecognizer locationInView:self.superview];
    //判断这个点是否在需要响应的视图上,如果在 就需要响应 不在直接返回No
    CGRect rect = [self.responseView convertRect:self.responseView.frame toView:self.window];
    return CGRectContainsPoint(rect, point);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    //判断各种状态
    if (!self.responseView) return view;
    
    //TODO :在responseView中 根据point 返回对应的View 让对应的View去响应事件
//    CGPoint n_point = [self convertPoint:point toView:self.window];
//    UIView *responseView = [self.responseView 构造方法返回view]
    
    
    return view;
}

@end
