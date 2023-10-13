//
//  DYHBChooseItemCell.m
//  KVOTestModel
//
//  Created by zhangjiang on 2023/10/12.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import "DYHBChooseItemCell.h"

#import <Masonry/Masonry.h>

#define kItemWidth ([UIScreen mainScreen].bounds.size.width - 50)/4.0

static CGFloat const kItemPadding = 10;

static CGFloat const kButtonPadding = 10;

static NSInteger const kDefaultTag = 10;

@interface DYHBChooseItemCell ()

@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIColor *titleDisableColor;

@property (nonatomic, strong) UIColor *bgNormalColor;
@property (nonatomic, strong) UIColor *bgSelectedColor;
@property (nonatomic, strong) UIColor *bgDisableColor;



@end


@implementation DYHBChooseItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setItemType:(DYHBChooseItemType)itemType {
    _itemType = itemType;
    //设置对应的颜色和字体  边框颜色  选中和 禁止点击等状态
}

- (void)setItemsArr:(NSArray<DYHBChooseItemModel *> *)itemsArr {
    _itemsArr = itemsArr;
    
    //移除所有的视图
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    //添加按钮
    NSInteger maxCount = _itemsArr.count;
    [_itemsArr enumerateObjectsUsingBlock:^(DYHBChooseItemModel *obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = [self createCustomViewWithObj:obj.title index:idx];
        if(obj.status == DYHBChooseItem_Disable){
            button.enabled = NO;
        }else{
            button.selected = obj.status == DYHBChooseItem_Choosed;
        }
        [self.contentView addSubview:button];
        //开始布局
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kItemWidth, 25));
            make.left.mas_equalTo(idx%4 * (kItemWidth + kItemPadding) + kButtonPadding);
            make.top.mas_equalTo(idx/4 * (kItemPadding + 25));
            if(maxCount - 1 == idx){
                //最后一个元素设置约束
                make.bottom.mas_equalTo(-kItemPadding);
            }
        }];
    }];
}

- (void)itemButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSInteger index = sender.tag - kDefaultTag;
    if(index >= 0 && index < _itemsArr.count) {
        DYHBChooseItemModel *itemModel = _itemsArr[index];
        !_itemChooseBlock ?: _itemChooseBlock(itemModel,sender.selected);
    }
}

- (UIButton *)createCustomViewWithObj:(NSString *)title index:(NSInteger)tag {
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitle:title forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
    [button setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateDisabled)];
    [button addTarget:self action:@selector(itemButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    button.tag = tag + kDefaultTag;
    
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 12.5;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.borderWidth = 1;
    
    return button;
}

@end
