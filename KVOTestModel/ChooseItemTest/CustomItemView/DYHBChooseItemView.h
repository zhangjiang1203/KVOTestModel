//
//  DYHBChooseItemView.h
//  KVOTestModel
//
//  Created by zhangjiang on 2023/10/12.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYHBChooseItemView : UIView

/// 获取选中的信息
- (NSArray *)getChooseItemData;

/// 重置设置
- (void)resetData;

@end

NS_ASSUME_NONNULL_END
