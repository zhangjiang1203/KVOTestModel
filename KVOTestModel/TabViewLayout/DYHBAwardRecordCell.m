//
//  DYHBAwardRecordCell.m
//  DYFunBoxComponent
//
//  Created by zhangjiang on 2023/7/6.
//

#import "DYHBAwardRecordCell.h"
#import <Masonry/Masonry.h>



@interface DYHBAwardRecordCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *chatIconImageView;

@end

@implementation DYHBAwardRecordCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI {
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.image = [UIImage imageNamed:@"header1"];
    self.avatarImageView.layer.cornerRadius = 10;
    self.avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.avatarImageView];
    
    self.chatIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header2"]];
    [self.contentView addSubview:self.chatIconImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"我就是舒服了";
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(16);
        make.width.mas_lessThanOrEqualTo(self.frame.size.width - 80);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.nameLabel.mas_left).offset(-6);
    }];
    
    [self.chatIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(4);
    }];
}

- (void)setWinInfoModel:(NSString *)title {
    self.nameLabel.text = title;
}

@end
