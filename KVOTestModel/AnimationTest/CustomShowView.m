//
//  CustomShowView.m
//  KVOTestModel
//
//  Created by zhangjiang on 2022/2/11.
//  Copyright © 2022 zhangjiang. All rights reserved.
//

#import "CustomShowView.h"


@interface CustomShowView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation CustomShowView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.bgColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.storkeColor = [UIColor whiteColor];
        self.lineWidth = MIN(frame.size.width, frame.size.height)/2.0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self setProgressLayer];
    }
    return self;
}

- (void)setProgressLayer{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //计算绘制圆形区域
    [path addArcWithCenter:CGPointMake(self.lineWidth, self.lineWidth) radius:self.lineWidth/2 startAngle:-M_PI_2  endAngle:1.5 * M_PI clockwise:YES];
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = self.storkeColor.CGColor;
    self.shapeLayer.lineWidth = self.lineWidth;
    self.shapeLayer.frame = self.bounds;
    self.shapeLayer.path = path.CGPath;
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 1;
    
    [self.layer addSublayer:self.shapeLayer];
}

/// 设置相关属性
-(void)setStorkeColor:(UIColor *)storkeColor{
    _storkeColor = storkeColor;
    self.shapeLayer.strokeColor = _storkeColor.CGColor;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    self.shapeLayer.strokeStart = progress;
}

@end
