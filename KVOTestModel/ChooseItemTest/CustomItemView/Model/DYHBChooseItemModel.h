//
//  DYHBChooseItemModel.h
//  KVOTestModel
//
//  Created by zhangjiang on 2023/10/12.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DYHBChooseItemStatus) {
    DYHBChooseItem_UnChoosed = 0,
    DYHBChooseItem_Choosed,
    DYHBChooseItem_Disable,
};

@class DYHBChooseItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface DYHBItemInfoModel : NSObject

@property (nonatomic, copy) NSString *sectionTitle;

@property (nonatomic, strong) NSArray<DYHBChooseItemModel *> *items;

@end



@interface DYHBChooseItemModel : NSObject

@property (nonatomic, assign) NSInteger itemId;

@property (nonatomic, copy) NSString *title;
// 未可选 已选中 不可用
@property (nonatomic, assign) DYHBChooseItemStatus status;

@end

NS_ASSUME_NONNULL_END
