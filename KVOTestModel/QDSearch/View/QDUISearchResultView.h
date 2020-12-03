//
//  QDUISearchResultView.h
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/10.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDSearchResultModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol QDUISearchResultViewDelegate <NSObject>

//更多按钮点击,返回当前所在的section的第一个模型
- (void) lookMoreResultAction:(QDSearchResultModel *)searchModel;

//点击cell的操作
- (void) didSelectedCellView:(QDSearchResultModel *)orignalModel;


@end


@interface QDUISearchResultView : UIView

@property (nonatomic,weak) id<QDUISearchResultViewDelegate> delegate;

@property (nonatomic,strong) NSMutableArray<NSDictionary*> *searchData;

-(NSMutableArray *)showTestData;

@end

NS_ASSUME_NONNULL_END
