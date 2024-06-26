//
//  ZJCustomCategoryView.m
//  KVOTestModel
//
//  Created by 张江 on 2024/6/5.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

#import "ZJCustomCategoryView.h"
#import "ZJCustomCategoryCell.h"
#import "ZJCustomCategoryCellModel.h"


@implementation ZJCustomCategoryView

- (void)initializeData{
    [super initializeData];
    self.cellWidth = 80;
    self.cellSpacing = 10;
    self.contentEdgeInsetLeft = 15;
    self.contentEdgeInsetRight = 10;
}

- (void)initializeViews {
    [super initializeViews];
}



- (Class)preferredCellClass {
    return [ZJCustomCategoryCell class];
}


- (void)refreshState {
    [super refreshState];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.data.count];
    for (int i = 0; i < self.data.count; i++) {
        ZJCustomCategoryCellModel *cellModel = [[ZJCustomCategoryCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = [NSArray arrayWithArray:tempArray];
    
}

- (void)refreshSelectedCellModel:(JXCategoryBaseCellModel *)selectedCellModel unselectedCellModel:(JXCategoryBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];
}

- (void)refreshCellModel:(JXCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];
    ZJCustomCategoryCellModel *model = (ZJCustomCategoryCellModel *)cellModel;
    model.name = @"我来了";
    model.cellWidth = 80;
    model.cellSpacing = 10;

}

- (void)refreshLeftCellModel:(JXCategoryBaseCellModel *)leftCellModel rightCellModel:(JXCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    [super refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:ratio];
}

@end
