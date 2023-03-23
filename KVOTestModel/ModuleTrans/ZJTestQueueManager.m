//
//  ZJTestQueueManager.m
//  KVOTestModel
//
//  Created by douyu on 2023/3/22.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import "ZJTestQueueManager.h"
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@interface ZJTestQueueManager ()<CAAnimationDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) dispatch_semaphore_t dataSeamphore;

@property (nonatomic, strong) dispatch_semaphore_t tipsSemaphore;
// 是否正在执行
@property (nonatomic, assign) BOOL isExecuting;

@property (nonatomic, strong) UIView *animView;

@end

@implementation ZJTestQueueManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArr = [NSMutableArray array];
        self.dataSeamphore = dispatch_semaphore_create(1);
        self.tipsSemaphore = dispatch_semaphore_create(1);
        [self setUpAnimationView];
    }
    return self;
}

- (void)setUpAnimationView {
    self.animView = [[UIView alloc] init];
    self.animView.backgroundColor = [UIColor redColor];
    self.animView.layer.cornerRadius = 10;
    [[UIApplication sharedApplication].delegate.window addSubview:self.animView];
    
    [self.animView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-100);
        make.bottom.mas_equalTo(-100);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
}

//出入数据加锁
- (void)insertCustomData:(NSString *)str {
    dispatch_semaphore_wait(self.dataSeamphore, DISPATCH_TIME_FOREVER);
    [self.dataArr addObject:str];
    dispatch_semaphore_signal(self.dataSeamphore);
    
    [self startShowTips];
}

- (void)startShowTips{
    if(self.isExecuting){
        return;
    }
    
    dispatch_semaphore_wait(self.tipsSemaphore, DISPATCH_TIME_FOREVER);
    self.isExecuting = YES;
    [self executeShowBannerComplete:^{
        self.isExecuting = NO;
        dispatch_semaphore_signal(self.tipsSemaphore);
        if(self.dataArr.count > 0){
            [self startShowTips];
        }
    }];
}


- (void)executeShowBannerComplete:(void (^)(void))action {
    if(self.dataArr.count == 0){
        action();
        return;
    }
    NSString *dataStr = self.dataArr.firstObject;
    [self.dataArr removeObjectAtIndex:0];
    //设置位移动画 和 透明度动画
    
    [UIView animateWithDuration:2 animations:^{
        [self.animView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
        }];
        [[UIApplication sharedApplication].delegate.window layoutIfNeeded];
        [[UIApplication sharedApplication].delegate.window setNeedsLayout];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            self.animView.alpha = 0;
        } completion:^(BOOL finished) {
            self.animView.alpha = 1;
            [self.animView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(-100);
            }];
            [[UIApplication sharedApplication].delegate.window layoutIfNeeded];
            [[UIApplication sharedApplication].delegate.window setNeedsLayout];
            action();
        }];
    }];
}

- (void)cleanSemaphore{
    dispatch_semaphore_wait(self.dataSeamphore, DISPATCH_TIME_FOREVER);
    [self.dataArr removeAllObjects];
    dispatch_semaphore_signal(self.dataSeamphore);
    dispatch_semaphore_signal(self.tipsSemaphore);//还原为1
    self.isExecuting = NO;
}

- (void)dealloc{
    self.dataSeamphore = nil;
    self.tipsSemaphore = nil;
}
@end
