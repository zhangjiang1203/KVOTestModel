//
//  ZJPopView.m
//  LHPerformanceStatusBar
//
//  Created by pg on 2017/11/19.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "ZJPopView.h"
#import "ZJPreformLabel.h"
#import "LHPerformanceUtil.h"
CGFloat const gestureMinTranslation = 20.0;
CGFloat const hiddenWidth = 50;
CGFloat const hiddenTime = 10;
#define KViewW [[UIScreen mainScreen]bounds].size.width

@interface ZJPopView()

@property (nonatomic,strong) CADisplayLink *displayTime;

@property (nonatomic,strong) ZJPreformLabel *memLabel;

@property (nonatomic,strong) ZJPreformLabel *CPULabel;

@property (nonatomic,strong) ZJPreformLabel *FPSLabel;

@property (assign, nonatomic) NSTimeInterval lastTimestamp;

@property (assign, nonatomic) NSInteger countPerFrame;

@property (nonatomic,strong) NSTimer *showTimer;

@property (nonatomic,assign) BOOL isHidden;


@end

@implementation ZJPopView

+(instancetype)shareInstance{
    static ZJPopView *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[self alloc]init];
    });
    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpMyDataUI];
        
    }
    return self;
}

-(void)setUpMyDataUI{
    _lastTimestamp = -1;
    self.displayTime = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMyDataToUI:)];
    self.displayTime.paused = YES;
    [self.displayTime addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    self.layer.masksToBounds = YES;
    self.frame = CGRectMake(20, 100, 100, 60);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panToView:)];
    [self addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToChangeView:)];
    [self addGestureRecognizer:tap];
    
    
    //添加显示的字符串
    self.memLabel = [[ZJPreformLabel alloc]initWithFrame:CGRectMake(5, 0, 95, 20)];
    self.memLabel.textColor = [UIColor blackColor];
    self.memLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.memLabel];
    
    self.CPULabel = [[ZJPreformLabel alloc]initWithFrame:CGRectMake(5, 20, 95, 20)];
    self.CPULabel.textColor = [UIColor blackColor];
    self.CPULabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.CPULabel];
    
    self.FPSLabel = [[ZJPreformLabel alloc]initWithFrame:CGRectMake(5, 40, 95, 20)];
    self.FPSLabel.textColor = [UIColor blackColor];
    self.FPSLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.FPSLabel];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [self initMyTime];
}

#pragma mark -定时器开始刷新
-(void)updateMyDataToUI:(CADisplayLink*)displayLink{
    if (_lastTimestamp == -1) {
        _lastTimestamp = displayLink.timestamp;
        return;
    }
    _countPerFrame ++;
    NSTimeInterval interval = displayLink.timestamp - _lastTimestamp;
    if (interval < 1) {
        return;
    }
    _lastTimestamp = displayLink.timestamp;
    CGFloat fps = _countPerFrame / interval;
    _countPerFrame = 0;
    self.FPSLabel.text = [NSString stringWithFormat:@"FPS:%d",(int)round(fps)];
    
    CGFloat memory = [LHPerformanceUtil usedMemoryInMB];
    self.memLabel.text = [NSString stringWithFormat:@"Mem:%.2fMB",memory];
    
    CGFloat cpu = [LHPerformanceUtil cpuUsage];
    self.CPULabel.text = [NSString stringWithFormat:@"CPU:%.2f%%",cpu];
}

#pragma mark -点击手势
-(void)tapToChangeView:(UITapGestureRecognizer*)sender{
//    if (self.isHidden) {
//        //打开
//        [self showOrHiddenView:NO];
//    }else{
//        [self.showTimer invalidate];
//        self.showTimer = nil;
//    }
////    [self initMyTime];
//    self.isHidden = !self.isHidden;
}


-(void)showOrHiddenView:(BOOL)isHidden{
    __weak typeof(self) weakSelf = self;
    if (isHidden) {
        self.layer.cornerRadius = hiddenWidth/2.0;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.memLabel.frame = CGRectMake(5, 5, 95, 20);
            weakSelf.memLabel.textAlignment = NSTextAlignmentCenter;
            weakSelf.FPSLabel.hidden = YES;
            weakSelf.CPULabel.hidden = YES;
            if (weakSelf.center.x >= KViewW/2.0) {
                weakSelf.frame = CGRectMake(KViewW-30, weakSelf.frame.origin.y, hiddenWidth, hiddenWidth);
            }else{
                weakSelf.frame = CGRectMake(0, weakSelf.frame.origin.y, hiddenWidth, hiddenWidth);
            }
        }];
    }else{
        self.layer.cornerRadius = 0;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.memLabel.frame = CGRectMake(5, 0, 95, 20);
            weakSelf.memLabel.textAlignment = NSTextAlignmentLeft;
            weakSelf.FPSLabel.hidden = NO;
            weakSelf.CPULabel.hidden = NO;
            if (weakSelf.center.x >= KViewW/2.0) {
                weakSelf.frame = CGRectMake(KViewW-100, weakSelf.frame.origin.y, 100, 60);
            }else{
                weakSelf.frame = CGRectMake(0, weakSelf.frame.origin.y, 100, 60);
            }
        }];
    }
}


#pragma mark -拖动手势
-(void)panToView:(UIPanGestureRecognizer*)gesture{
    CGPoint translation = [gesture translationInView:self];
    self.center = CGPointMake(translation.x + self.center.x, translation.y+self.center.y);
    //重新设置手势位置
    [gesture setTranslation:CGPointZero inView:self];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.isHidden = YES;
//        [self initMyTime];
    }else{
//        [self.showTimer invalidate];
//        self.showTimer = nil;
    }
}

#pragma mark -添加定时器
-(void)initMyTime{
    __weak typeof(self) weakSelf = self;
    self.showTimer = [NSTimer timerWithTimeInterval:hiddenTime repeats:NO block:^(NSTimer * _Nonnull timer) {
        [weakSelf.showTimer invalidate];
        weakSelf.showTimer = nil;
        weakSelf.isHidden = YES;
        //设置位置
        [weakSelf showOrHiddenView:weakSelf.isHidden];
    }];
    [[NSRunLoop currentRunLoop]addTimer:self.showTimer forMode:NSRunLoopCommonModes];
}

+(void)managerRun{
    [ZJPopView shareInstance].displayTime.paused = NO;
}

+(void)managerStop{
    [ZJPopView shareInstance].displayTime.paused = YES;
}

@end
