//
//  ZJPopView.h
//  LHPerformanceStatusBar
//
//  Created by pg on 2017/11/19.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJPopView : UIView

+(instancetype)shareInstance;

/**
 开始监控显示
 */
+(void)managerRun;

/**
 停止显示
 */
+(void)managerStop;

@end
