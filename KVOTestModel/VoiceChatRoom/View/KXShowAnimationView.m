//
//  KXShowAnimationView.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "KXShowAnimationView.h"

@interface KXShowAnimationView ()

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation KXShowAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self initAnimationValue];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        [self initAnimationValue];
    }
    return self;
}

- (void)initAnimationValue{
    self.duration = 2;
    self.interval = 0.3;
    self.storkColor = [UIColor blueColor];
    self.fillColor = [UIColor clearColor];
    self.startRadius = 10;
    
}

- (void)setDuration:(CGFloat)duration{
    _duration = duration;
}

- (void)setInterval:(CGFloat)interval{
    _interval = interval;
}

- (void)setFillColor:(UIColor *)fillColor{
    _fillColor = fillColor;
}

- (void)setStorkColor:(UIColor *)storkColor{
    _storkColor = storkColor;
}

- (void)setStartRadius:(CGFloat)startRadius{
    _startRadius = startRadius;
}


//添加水波纹动画
- (void)addRippleAnimation {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(startAnimationLayer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeRippleAnimation {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    for(int i = 0; i < [self.layer sublayers].count;i++){
        [[[self.layer sublayers] firstObject] removeFromSuperlayer];
    }
    [self.layer removeAllAnimations];
}


- (void)startAnimationLayer{
    CGFloat sizeW = MIN(self.frame.size.width, self.frame.size.height);
    
    CAShapeLayer *shaperLayer = [CAShapeLayer new];
    shaperLayer.frame = self.bounds;
    shaperLayer.strokeColor = self.storkColor.CGColor;
    shaperLayer.lineWidth = 2;
    shaperLayer.fillColor = self.fillColor.CGColor;
    shaperLayer.opacity = 0;
    
    
    //创建path
    CGRect beginRect = CGRectMake((sizeW-_startRadius)/2.0, (sizeW-_startRadius)/2.0, _startRadius, _startRadius);
    UIBezierPath *beiginPath = [UIBezierPath bezierPathWithOvalInRect:beginRect];
    shaperLayer.path = beiginPath.CGPath;
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(beginRect, -sizeW/2, -sizeW/2)];
    shaperLayer.path = endPath.CGPath;
    [self.layer addSublayer:shaperLayer];
    
    CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnim.fromValue = (__bridge id _Nullable)(beiginPath.CGPath);
    pathAnim.toValue = (__bridge id _Nullable)(endPath.CGPath);
    pathAnim.duration = self.duration;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(0.6);
    opacityAnimation.toValue = @(0);
    opacityAnimation.duration = self.duration;
    
    [shaperLayer addAnimation:pathAnim forKey:@""];
    [shaperLayer addAnimation:opacityAnimation forKey:@""];
    
    //防止layer添加过多
    [self performSelector:@selector(removeRipperLayer:) withObject:shaperLayer afterDelay:2];
}

- (void)removeRipperLayer:(CALayer *)layer{
    [layer removeFromSuperlayer];
    layer = nil;
}

@end
