//
//  ZJPreformLabel.m
//  LHPerformanceStatusBar
//
//  Created by 张江 on 2017/11/20.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "ZJPreformLabel.h"

@interface ZJPreformLabel ()

//添加字符串颜色字典
@property (nonatomic,strong) NSMutableDictionary *labelColorDict;


@end


@implementation ZJPreformLabel

-(NSMutableDictionary *)labelColorDict{
    if (_labelColorDict == nil) {
        _labelColorDict = [NSMutableDictionary dictionary];
    }
    return _labelColorDict;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置默认值
        [self initMySetUp];
    }
    return self;
}

-(void)initMySetUp{
    [self setPreformTitleColor:[UIColor colorWithRed:244.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] state:KPreformState_BAD];
    [self setPreformTitleColor:[UIColor orangeColor] state:KPreformState_WARNING];
    [self setPreformTitleColor:[UIColor colorWithRed:66.0/255.0 green:244.0/255.0 blue:89.0/255.0 alpha:1.0] state:KPreformState_GOOD];
    self.labelState = KPreformState_GOOD;
}

-(void)setPreformTitleColor:(UIColor *)color state:(KPreformState)state{
    if (color) {
        [self.labelColorDict setValue:color forKey:[NSString stringWithFormat:@"%zd",state]];
    }else{
        [self.labelColorDict removeObjectForKey:@(state)];
    }
}

-(UIColor *)colorForState:(KPreformState)state{
    return [self.labelColorDict valueForKey:[NSString stringWithFormat:@"%zd",state]];
}

-(void)setLabelState:(KPreformState)labelState{
    _labelState = labelState;
    self.textColor = [self colorForState:self.labelState];
    
}

@end
