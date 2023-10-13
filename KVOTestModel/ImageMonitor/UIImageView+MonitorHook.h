//
//  UIImageView+MonitorHook.h
//  DYPerformanceMonitor
//
//  Created by  liuqi on 2019/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (MonitorHook)

+ (void)dypHookImageAppear;

@end

NS_ASSUME_NONNULL_END
