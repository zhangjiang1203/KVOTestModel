//
//  DYHBLuckyBagInfoCell.m
//  DYFunBoxComponent
//
//  Created by zhangjiang on 2023/7/13.
//

#import "DYHBLuckyBagInfoCell.h"
#import <Masonry/Masonry.h>

@interface DYHBLuckyBagInfoCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *luckyStatusBtn;

@property (nonatomic, strong) UILabel *grantTimeLabel;

@property (nonatomic, strong) UIButton *checkAwardBtn;


@end

@implementation DYHBLuckyBagInfoCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setUpBGView];
        [self setUpTopView];
        [self setUpCenterView];
        [self setUpBottomView];
    }
    return self;
}

- (void)setUpBGView {
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 13;
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 10, 16));
    }];
}

- (void)setUpTopView {
    self.topView = [[UIView alloc] init];
    [self.bgView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(40.5);
    }];
    
    self.titleLabel = [self createLabelWithColor:@"#333333" fontSize:14 weight:(UIFontWeightBold)];
    self.titleLabel.text = @"我是测试礼物";
    [self.topView addSubview:self.titleLabel];
    
    self.luckyStatusBtn = [[UIButton alloc] init];
    [self.luckyStatusBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [self.luckyStatusBtn setTitle:@"发放中" forState:(UIControlStateNormal)];
    self.luckyStatusBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [self.luckyStatusBtn addTarget:self action:@selector(luckyBagButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:self.luckyStatusBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor];
    [self.topView addSubview:lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(20);
    }];
    
    [self.luckyStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(20);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setUpCenterView {
    self.centerView = [[UIView alloc] init];
    [self.bgView addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
    
    //创建数据
    NSArray *dataArr = @[@{@"title":@"参与奖励",@"subTitle":@"奖励等级名称：道具名称（无限量）\n奖励等级名称：道具名称（无限量）\n奖励等级名称：道具名称（无限量）",@"desc":@""},
                         @{@"title":@"参与条件",@"subTitle":@"赠送礼物 棒棒糖*1",@"desc":@""},
                         @{@"title":@"氛围弹幕",@"subTitle":@"弹幕内容在这里，弹幕内容在这里，弹幕内容",@"desc":@"（用户参与福袋活动会自动发送此弹幕）"},
                         @{@"title":@"开奖时间",@"subTitle":@"10分钟",@"desc":@""},
    ];
    
    UIView *tempView;
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        UIView *contentView = [self createLuckybagInfoView:dict[@"title"] subTitle:dict[@"subTitle"] desc:dict[@"desc"]];
        [self.centerView addSubview:contentView];
        if(tempView){
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(tempView.mas_bottom);
                if(i == 3) {//最后一个视图
                    make.bottom.mas_equalTo(-8);
                }
            }];
        }else{
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(8);
                make.left.right.mas_equalTo(0);
            }];
        }
        tempView = contentView;
    }
}

- (void)setUpBottomView {
    self.bottomView = [[UIView alloc] init];
    [self.bgView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.centerView.mas_bottom);
        make.height.mas_equalTo(51);
        make.bottom.mas_offset(0);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor];
    [self.bottomView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *titleLabel = [self createStaticTitleLabel:@"发放时间"];
    [self.bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(14);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(20);
    }];
    
    self.grantTimeLabel = [self createLabelWithColor:@"#666666" fontSize:12 weight:(UIFontWeightRegular)];
    self.grantTimeLabel.text = @"带来十分吉林师范";
    [self.bottomView addSubview:self.grantTimeLabel];
    [self.grantTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.centerY.mas_equalTo(titleLabel);
        make.height.mas_equalTo(20);
    }];
    
    self.checkAwardBtn = [[UIButton alloc] init];
    self.checkAwardBtn.layer.cornerRadius = 4;
    self.checkAwardBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.checkAwardBtn.backgroundColor = [UIColor blueColor];
    [self.checkAwardBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.checkAwardBtn setTitle:@"查看中奖名单" forState:(UIControlStateNormal)];
    self.checkAwardBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [self.checkAwardBtn addTarget:self action:@selector(luckyBagButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.checkAwardBtn];
    [self.checkAwardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(titleLabel);
        make.height.mas_equalTo(24);
    }];
}

#pragma mark -按钮点击事件
- (void)luckyBagButtonAction:(UIButton *)sender {
    
}

- (UIView *)createLuckybagInfoView:(NSString *)title subTitle:(NSString *)subTitle desc:(NSString *)desc {
    UIView *bgView = [[UIView alloc] init];
    
    UILabel *titleLabel = [self createStaticTitleLabel:title];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(6);
    }];
    
    UILabel *subTitleLabel = [self createLabelWithColor:@"#666666" fontSize:12 weight:(UIFontWeightRegular)];
    subTitleLabel.text = subTitle;
    [bgView addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(80);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-6);
    }];
    
    if(desc.length){
        UILabel *descLabel = [self createLabelWithColor:@"#999999" fontSize:10 weight:(UIFontWeightRegular)];
        descLabel.text = desc;
        [bgView addSubview:descLabel];
        
        [subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.mas_equalTo(80);
            make.right.mas_equalTo(-6);
        }];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(subTitleLabel.mas_bottom).offset(4);
            make.left.mas_equalTo(80);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-6);
        }];
    }
    return bgView;
}


#pragma mark -便利方法
- (UILabel *)createStaticTitleLabel:(NSString *)title {
    UILabel *titleLabel = [self createLabelWithColor:@"#333333" fontSize:12 weight:(UIFontWeightBold)];
    titleLabel.text = title;
    return titleLabel;
}

- (UILabel *)createLabelWithColor:(NSString *)textColor fontSize:(CGFloat)fontSize weight:(UIFontWeight)weight {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:fontSize weight:weight];
    return titleLabel;
}

@end
