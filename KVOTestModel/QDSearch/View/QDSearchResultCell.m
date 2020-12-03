//
//  QDSearchResultCell.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/9.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "QDSearchResultCell.h"

#define kHighLightColor QDHEXColor(0x44A3FE, 1)
#define kTitleHeight 22
#define kSubTitleHeight 17

@interface QDSearchResultCell()

@property (nonatomic,strong) UIImageView *headerImageView;

@property (nonatomic,strong) UILabel *searchTitleLabel;

@property (nonatomic,strong) UILabel *searchSubTitleLabel;

@end

@implementation QDSearchResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSearchResultUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize cellSize = self.frame.size;
    CGRect imageframe = CGRectMake(12, (cellSize.height-40)/2.0, 40, 40);
    self.headerImageView.frame = imageframe;
    CGFloat maxWidth = cellSize.width - CGRectGetMaxX(imageframe) - 8 - 16;
    if(_searchModel.subTitle.length){
        self.searchTitleLabel.frame = CGRectMake(CGRectGetMaxX(imageframe)+8, CGRectGetMinY(imageframe), maxWidth, kTitleHeight);
    }else{
        self.searchTitleLabel.frame = CGRectMake(CGRectGetMaxX(imageframe)+8, (cellSize.height-kTitleHeight)/2.0, maxWidth, kTitleHeight);
    }
    
    self.searchSubTitleLabel.frame = CGRectMake(CGRectGetMaxX(imageframe)+8, CGRectGetMaxY(imageframe)-kSubTitleHeight, maxWidth, kSubTitleHeight);
    
//    //根据数据类型修改UI展示
//       if (_searchModel.subTitle.length) {
//           CGRect rect = self.searchTitleLabel.frame;
//           rect.origin.y = CGRectGetMinY(self.headerImageView.frame);
//           self.searchTitleLabel.frame = rect;
//       }else{
//           CGRect rect = self.searchTitleLabel.frame;
//           rect.origin.y = (self.frame.size.height - rect.size.height)/2.0;
//           self.searchTitleLabel.frame = rect;
//       }
//
}

-(void)setSearchResultUI{
    
    self.headerImageView = [UIImageView new];
    
    [self.contentView addSubview:self.headerImageView];
    
    self.searchTitleLabel = [[UILabel alloc]init];
    self.searchTitleLabel.textColor = QDHEXColor(0x000000, 1);
    self.searchTitleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.searchTitleLabel];
    
    self.searchSubTitleLabel = [[UILabel alloc]init];
    self.searchSubTitleLabel.textColor = QDHEXColor(0x888C99, 1);//RGBA(136,140,153,1);
    self.searchSubTitleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.searchSubTitleLabel];

}

-(void)setSearchModel:(QDSearchResultModel *)searchModel{
    _searchModel = searchModel;
    //设置对应的数据和展示效果
    self.headerImageView.image = [UIImage imageNamed:_searchModel.avatarURL];
    
    NSRange titleRange = [_searchModel.title rangeOfString:_searchModel.searchText];
    if (titleRange.location == NSNotFound) {
        self.searchTitleLabel.text = _searchModel.title;
    }else{
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:_searchModel.title];
        [titleStr addAttributes:@{NSForegroundColorAttributeName:kHighLightColor} range:titleRange];
        self.searchTitleLabel.attributedText = titleStr;
    }
    
    NSRange subTitleRange = [_searchModel.subTitle rangeOfString:_searchModel.searchText];
    if (subTitleRange.location == NSNotFound) {
        self.searchSubTitleLabel.text = _searchModel.subTitle;
    }else{
        NSMutableAttributedString *subTitleStr = [[NSMutableAttributedString alloc]initWithString:_searchModel.subTitle];
        [subTitleStr addAttributes:@{NSForegroundColorAttributeName:kHighLightColor} range:subTitleRange];
        self.searchSubTitleLabel.attributedText = subTitleStr;
    }
    
   
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
