//
//  KXRippleView.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/11.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KXRippleView : UIView

//bord宽度(一般不修改)
@property (nonatomic,assign) CGFloat bordWidth;
//动画时间
@property (nonatomic,assign) CGFloat animationTime;
//初始透明度
@property (nonatomic,assign) CGFloat startAlph;
//比例
@property (nonatomic,assign) CGFloat scale;
//颜色
@property (nonatomic,strong) UIColor *color;


- (void)addRippleAnimation;

-(void)removeRippleAnimation;

@end

NS_ASSUME_NONNULL_END
