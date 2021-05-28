//
//  KXRippleView.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "KXRippleView.h"

@interface KXRippleView ()

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign) NSInteger currentCount;

@property (nonatomic,assign) NSInteger maxCount;

@end

@implementation KXRippleView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initValues];
    }
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initValues];
    }
    return self;
}

- (void)initValues {
    self.backgroundColor = [UIColor clearColor];
    self.animationTime = 3;
    self.scale = 1.2;
    self.bordWidth = 2;
    self.startAlph = 1;
    self.color = [UIColor whiteColor];
    self.maxCount = 4;
    self.currentCount = 0;
}

//动画时间
-(void)setAnimationTime:(CGFloat)animationTime{
    _animationTime = animationTime;
}
//动画发散的大小
-(void)setScale:(CGFloat)scale{
    _scale = scale;
}
//光圈的宽度
-(void)setBordWidth:(CGFloat)bordWidth{
    _bordWidth = bordWidth;
}
//初始透明度
-(void)setStartAlph:(float)startAlph{
    _startAlph = startAlph;
}
//光圈颜色
-(void)setColor:(UIColor *)color{
    _color = color;
}

//开始水波纹动画
-(void)startWaveAnimationCircleNumber:(NSInteger)number{
    if (self.timer) {
        [self invalidTimer];
    }
    if (number == 0) {
        number = 1;
    }
    self.currentCount = 0;
    self.maxCount = number;
    //每一个圈需要的时间
    CGFloat time = self.animationTime / number;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer setFireDate:[NSDate date]];
}

- (void)timerStart {
//    self.currentCount ++;
//    if (self.currentCount > self.maxCount) {
//        [self invalidTimer];
//        return ;
//    }
    [self start];
}

//停止水波纹
-(void)stopwWaveAnimation{
    [self.layer removeAllAnimations];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self invalidTimer];
}
-(void)invalidTimer{
    [self.timer invalidate];
    self.timer = nil;
}
-(void)start{
    
    CGFloat sizeW = MIN(self.frame.size.width, self.frame.size.height);
    //中心
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = self.bounds;
    layer.opacity = 0.0;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.strokeColor = self.color.CGColor;
    layer.lineWidth = self.bordWidth;
    layer.fillColor = self.color.CGColor;//[self.color colorWithAlphaComponent:0.6].CGColor;
    
    //创建path
    CGRect beginRect = CGRectMake(10, 10, sizeW- 2 * 10, sizeW- 2 * 10);
    UIBezierPath *beiginPath = [UIBezierPath bezierPathWithOvalInRect:beginRect];
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-8, -8, sizeW+16, sizeW+16)];
    layer.path = endPath.CGPath;
    
    CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnim.fromValue = (__bridge id _Nullable)(beiginPath.CGPath);
    pathAnim.toValue = (__bridge id _Nullable)(endPath.CGPath);
    [self.layer addSublayer:layer];

    //设置图层的透明度，使用关键帧动画
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@0.3, @0.6, @1.0, @0.7,@0.5, @0.3, @0,@0];
    opacityAnimation.keyTimes = @[@0.2,@0.3,@0.5, @0.6,@0.7, @0.8,@0.9, @1];

    //圈的宽度变化
    CABasicAnimation *borderAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    borderAnimation.fromValue = @(self.bordWidth);
    borderAnimation.toValue = @(0.2);
    borderAnimation.duration = 0.2;
    
    //动画组
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.animations = @[pathAnim, opacityAnimation,borderAnimation];
    animationGroup.duration = self.animationTime;
    animationGroup.removedOnCompletion = YES;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.repeatCount = MAXFLOAT;
    [layer addAnimation:animationGroup forKey:@""];
    
    //防止layer添加过多
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(removeRipperLayer:) withObject:layer afterDelay:self.animationTime];
    });
    
}

- (void)removeRipperLayer:(CALayer *)layer{
    [layer removeFromSuperlayer];
    layer = nil;
}


@end
