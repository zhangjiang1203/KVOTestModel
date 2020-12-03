//
//  QDUISearchEmptyView.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/10.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "QDUISearchEmptyView.h"

@implementation QDUISearchEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setEmptyView];
    }
    return self;
}

- (void)setEmptyView{
    
    CGSize size = self.frame.size;
    
    UIImageView *emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake((size.width-140)/2, 160, 140, 113)];
    emptyImageView.image = [UIImage imageNamed:@"search_empty_logo"];
    [self addSubview:emptyImageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((size.width- 100)/2, CGRectGetMaxY(emptyImageView.frame)+ 24,100,22)];
    titleLabel.textColor = QDHEXColor(0x262D3D, 1);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"暂无搜索结果";
    [self addSubview:titleLabel];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
