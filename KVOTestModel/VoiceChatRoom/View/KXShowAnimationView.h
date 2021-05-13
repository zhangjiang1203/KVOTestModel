//
//  KXShowAnimationView.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KXShowAnimationView : UIView
/// 动画时间
@property (nonatomic,assign) CGFloat duration;
/// 添加圆时间间隔
@property (nonatomic,assign) CGFloat interval;
/// 边框颜色
@property (nonatomic,strong) UIColor *storkColor;
/// 填充颜色
@property (nonatomic,strong) UIColor *fillColor;
/// 初始圆半径
@property (nonatomic,assign) CGFloat startRadius;

- (void)addRippleAnimation;

- (void)removeRippleAnimation;
@end

NS_ASSUME_NONNULL_END
