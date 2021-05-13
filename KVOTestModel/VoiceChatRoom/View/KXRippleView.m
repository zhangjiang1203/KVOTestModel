//
//  KXRippleView.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/11.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "KXRippleView.h"

@interface KXRippleView ()
//定时器动画
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation KXRippleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animationTime = 2;
        self.scale = 1.3;
        self.bordWidth = 1.5;
        self.color = [UIColor whiteColor];
        self.startAlph = 0.8;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.animationTime = 2;
        self.scale = 1.3;
        self.bordWidth = 1.5;
        self.color = [UIColor whiteColor];
        self.startAlph = 0.8;
    }
    return self;
}

- (void)setAnimationTime:(CGFloat)animationTime{
    _animationTime = animationTime;
}

- (void)setScale:(CGFloat)scale{
    _scale = scale;
}

- (void)setBordWidth:(CGFloat)bordWidth{
    _bordWidth = bordWidth;
}

- (void)setColor:(UIColor *)color {
    _color = color;
}

///根据添加的num执行对应的次数

-(void)startWaveAnimationCircleNumber:(NSInteger)number{
    __block NSInteger index = 0;
    if (self.timer) {
        [self invalidateTimer];
    }
    if (number == 0) {
        number = 1;
    }
    //每一个圈需要的时间
    CGFloat time = self.animationTime / number;
    __weak typeof(self) weaKSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:time repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(weaKSelf) strongSelf = weaKSelf;
        index ++;
        if (index > number) {
            [strongSelf invalidateTimer];
            return ;
        }
        [strongSelf addRippleLayer];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer setFireDate:[NSDate date]];
}



//添加水波纹动画
- (void)addRippleAnimation {
    [self startWaveAnimationCircleNumber:3];
}

- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)removeRippleAnimation {
    [self invalidateTimer];
    for(int i = 0; i < [self.layer sublayers].count;i++){
        [[[self.layer sublayers] firstObject] removeFromSuperlayer];
    }
    [self.layer removeAllAnimations];
}


- (void)addRippleLayer{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.position = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    shapeLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.opacity = 0;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [self.color colorWithAlphaComponent:self.startAlph].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = self.bordWidth;
    [self.layer addSublayer:shapeLayer];
    
    //设置动画
    //透明度改变
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:self.startAlph];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
//    opacityAnimation.duration = 0.8;
    
    //圈的大小改变(发散效果)
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @(self.scale);
    
    //圈的宽度变化
    CABasicAnimation *borderAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    borderAnimation.fromValue = @(self.bordWidth);
    borderAnimation.toValue = @(1);
    borderAnimation.duration = 0.2;
    
    //动画组
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.animations = @[opacityAnimation,scaleAnimation,borderAnimation];
    animationGroup.duration = 2;
    animationGroup.removedOnCompletion = YES;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.repeatCount = MAXFLOAT;
    [shapeLayer addAnimation:animationGroup forKey:@""];

    
    
//    CGFloat sizeW = MIN(self.bounds.size.width, self.bounds.size.height);
//
//    CGRect beginRect = CGRectMake(sizeW/2, sizeW/2, 0, 0);
//    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:beginRect];
//    CGRect endRect = CGRectInset(beginRect, -sizeW, -sizeW);
//    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
//
//    shapeLayer.path = endPath.CGPath;
//    shapeLayer.opacity = 0.0;

    //add animation
//    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
//    rippleAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
//    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
//        CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    rippleAnimation.fromValue = @1.0f;//(__bridge id _Nullable)(beginPath.CGPath);
//    rippleAnimation.toValue = @2.4f;//(__bridge id _Nullable)(endPath.CGPath);
//    rippleAnimation.duration = 2;

//    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    opacityAnimation.fromValue = @(0.6);
//    opacityAnimation.toValue = @(0);
//    opacityAnimation.duration = 2;

//    [shapeLayer addAnimation:rippleAnimation forKey:@""];
//    [shapeLayer addAnimation:opacityAnimation forKey:@""];
    
//    [self performSelector:@selector(removeRipperLayer:) withObject:shapeLayer afterDelay:2];
}

- (void)removeRipperLayer:(CALayer *)layer{
    [layer removeFromSuperlayer];
    layer = nil;
}


-(void)addAnimateForView:(UIView *)view withRect:(CGRect)rect{
    CALayer *layer = [CALayer layer];//创建一个layer，最后用来添加到view的图层上展示动画用
    NSInteger repeatCount = 3;//设置重复次数3次
    NSInteger keepTiming = 3;// 设置每段动画持续时间3秒
    
    for (NSInteger i = 0; i< repeatCount; i++) {//每次执行，创建相关动画
        // 每个动画对应一个图层。3个动画，需要有3个图层
        CALayer *animateLayer = [CALayer layer];
        animateLayer.borderColor = [UIColor redColor].CGColor;
        animateLayer.borderWidth = 3.5;
        animateLayer.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        animateLayer.cornerRadius = rect.size.height/2;
        //到此。每一个图层的大小，形状。颜色设置完毕。
        // 设置图层的scale 使用CABasicAnimation
        CABasicAnimation *basicAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        basicAni.fromValue = @1.0f;
        basicAni.toValue = @2.4f;
        
        //设置图层的透明度，使用关键帧动画
        CAKeyframeAnimation *keyani = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        keyani.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        keyani.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
        //我们要让一个动画同时执行scale 和 opacity的变化，需要将他们都加入到layer的动画组
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.fillMode = kCAFillModeBackwards;
        group.duration = keepTiming;
        group.repeatCount = HUGE;
        group.beginTime = CACurrentMediaTime() + (double)i * keepTiming / (double)repeatCount;
        
        group.animations = @[keyani,basicAni];
        [animateLayer addAnimation:group forKey:@"plus"];
        [layer addSublayer:animateLayer];
    }
    [view.layer addSublayer:layer];
}

@end
