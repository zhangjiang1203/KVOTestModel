//
//  ZJFullBigCell.m
//  KVOTestModel
//
//  Created by zj on 2021/9/10.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJFullBigCell.h"
#import "ZJShowContentView.h"

@interface ZJFullBigCell ()

@property (nonatomic,strong) ZJShowContentView *myContentView;

@end

@implementation ZJFullBigCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.myContentView];
    }
    return self;
}


- (ZJShowContentView *)myContentView{
    if (!_myContentView) {
        _myContentView = [[ZJShowContentView alloc]initWithFrame:self.bounds];
    }
    return _myContentView;
}

@end
