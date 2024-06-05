//
//  ZJCustomCategoryCellModel.h
//  KVOTestModel
//
//  Created by 张江 on 2024/6/5.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JXCategoryView/JXCategoryIndicatorCellModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZJCustomCategoryCellModel : JXCategoryIndicatorCellModel

@property (nonatomic, copy) NSString *imageURL;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger talentCount;
@end

NS_ASSUME_NONNULL_END
