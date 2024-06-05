//
//  ZJCustomCategoryView.h
//  KVOTestModel
//
//  Created by 张江 on 2024/6/5.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JXCategoryView/JXCategoryView.h>
#import "ZJCustomCategoryCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJCustomCategoryView : JXCategoryIndicatorView

@property (nonatomic, strong) NSArray<ZJCustomCategoryCellModel *> *data;

@end

NS_ASSUME_NONNULL_END
