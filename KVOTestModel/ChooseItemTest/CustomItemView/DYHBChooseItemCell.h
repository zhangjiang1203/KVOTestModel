//
//  DYHBChooseItemCell.h
//  KVOTestModel
//
//  Created by zhangjiang on 2023/10/12.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYHBChooseItemModel.h"

typedef NS_ENUM(NSUInteger, DYHBChooseItemType) {
    DYHBChooseItem_Filter = 0,        //首页筛选
    DYHBChooseItem_PublishCondition,  //发布房间条件
};

NS_ASSUME_NONNULL_BEGIN

@interface DYHBChooseItemCell : UITableViewCell

@property (nonatomic, assign) DYHBChooseItemType itemType;

@property (nonatomic, strong) NSArray<DYHBChooseItemModel *> *itemsArr;

@property (nonatomic, copy) void(^itemChooseBlock)(DYHBChooseItemModel *item,BOOL isChoose);

@end

NS_ASSUME_NONNULL_END
