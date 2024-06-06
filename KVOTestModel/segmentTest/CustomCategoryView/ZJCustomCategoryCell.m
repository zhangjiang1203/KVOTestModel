//
//  ZJCustomCategoryCell.m
//  KVOTestModel
//
//  Created by 张江 on 2024/6/5.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

#import "ZJCustomCategoryCell.h"
#import "ZJCustomCategoryCellModel.h"

@interface ZJCustomCategoryCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ZJCustomCategoryCell

- (void)initializeViews {
    [super initializeViews];
    
    _titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor redColor];
    self.titleLabel.clipsToBounds = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(5, 0, 80, 30);
}


- (void)reloadData:(JXCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];
    //刷新展示视图
    ZJCustomCategoryCellModel *model = (ZJCustomCategoryCellModel *)cellModel;
    
    self.titleLabel.text = model.name;

    
}
@end
