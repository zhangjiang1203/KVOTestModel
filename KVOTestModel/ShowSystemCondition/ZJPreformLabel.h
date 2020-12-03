//
//  ZJPreformLabel.h
//  LHPerformanceStatusBar
//
//  Created by 张江 on 2017/11/20.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,KPreformState){
    KPreformState_BAD,
    KPreformState_GOOD,
    KPreformState_WARNING,
};

@interface ZJPreformLabel : UILabel

@property (nonatomic,assign) KPreformState labelState;

//设置状态的颜色
-(void)setPreformTitleColor:(UIColor*)color state:(KPreformState)state;

//根据状态值获取对应的颜色
-(UIColor*)colorForState:(KPreformState)state;
@end
