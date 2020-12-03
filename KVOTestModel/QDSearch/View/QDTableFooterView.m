//
//  QDTableFooterView.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/14.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "QDTableFooterView.h"

@interface QDTableFooterView ()

@property (nonatomic,strong) UIActivityIndicatorView *activityView;

@property (nonatomic,strong) UILabel *infoLabel;

@property (nonatomic,assign) BOOL isAnimating;

@end

@implementation QDTableFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.activityView = [UIActivityIndicatorView new];
        self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:self.activityView];
        
        self.infoLabel = [UILabel new];
        self.infoLabel.textColor = QDHEXColor(0x262D3D, 1);
        self.infoLabel.font = [UIFont systemFontOfSize:16];
        self.infoLabel.text = @"暂无搜索结果";
        [self addSubview:self.infoLabel];
        
    }
    return self;
}

- (void)startLoad{
    if (!self.activityView.animating) {
        [self.activityView startAnimating];
    }
}

- (void)stopLoad{
    if (self.activityView.animating) {
        [self.activityView startAnimating];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize viewSize = self.bounds.size;
    
    CGSize size = [self.tipsContent boundingRectWithSize:CGSizeMake(200, 20) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.infoLabel.frame = CGRectMake((viewSize.width - size.width)/2.0+20, 20, size.width, 20);
    
    self.activityView.frame = CGRectMake(CGRectGetMinX(self.infoLabel.frame)-20, 20, 20, 20);
    
}

- (void)setTipsContent:(NSString *)tipsContent{
    _tipsContent = tipsContent;
    _infoLabel.text = _tipsContent;
    //重新布局
    [self setNeedsLayout];
}

@end
