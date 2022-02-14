//
//  CustomShowView.h
//  KVOTestModel
//
//  Created by zhangjiang on 2022/2/11.
//  Copyright © 2022 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomShowView : UIView
/// 视图背景
@property (nonatomic, strong) UIColor *bgColor;
/// 圆环颜色
@property (nonatomic, strong) UIColor *storkeColor;
/// 圆环宽度
@property (nonatomic, assign) CGFloat lineWidth;
/// 当前进度
@property (nonatomic, assign) CGFloat progress;

@end

NS_ASSUME_NONNULL_END
