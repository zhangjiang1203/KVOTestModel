//
//  ZJSmallOneCell.m
//  KVOTestModel
//
//  Created by zj on 2021/9/10.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJSmallOneCell.h"

@implementation ZJSmallOneCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.textColor = [UIColor whiteColor];
        label.text = @"你好";
        [self.contentView addSubview:label];
    }
    return self;
}



@end
