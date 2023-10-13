//
//  UIImageView+MonitorHook.m
//  DYPerformanceMonitor
//
//  Created by  liuqi on 2019/6/18.
//

#import "UIImageView+MonitorHook.h"
#import "SwizzleHook.h"
#import <objc/runtime.h>
#import <SDWebImage/UIView+WebCache.h>
//#import "DYPerformanceSDKManager.h"
//#import "ImageMonitor.h"

@implementation UIImageView (MonitorHook)

+ (void)dypHookImageAppear
{
    dyphookMethod([self class], @selector(setImage:), [self class], @selector(dyp_setImage:), NO);
}

- (void)dyp_setImage:(UIImage *)mLocalImg{
    if (mLocalImg) {
        NSURL *mServerUrl = [self sd_imageURL];
        NSString *imagePath = [self getViewPathByView:self];
//        ImageMonitor *monitor = (ImageMonitor *)[[DYPerformanceSDKManager shareInstance] getExistedMonitorWithType:MonitorType_BigImage];
        if ([mServerUrl isKindOfClass:NSURL.class] && mServerUrl.absoluteString.length > 0) {
            NSString *assetName = mLocalImg.accessibilityIdentifier;
            //可能是占位图，占位图先过滤
            if (assetName.length == 0) {
                CGFloat animatedImageDataSize = CGImageGetBytesPerRow(mLocalImg.CGImage) * CGImageGetHeight(mLocalImg.CGImage);
//                if (monitor.isRunning) {
//                    [monitor doMonitorWithUrl:mServerUrl.absoluteString imageSize:animatedImageDataSize imagePath:imagePath];
//                }
            }
        }
        else {
            NSString *assetName = mLocalImg.accessibilityIdentifier;
//            if([assetName containsString:@"-"] && ![assetName hasPrefix:@"dyp_"]){
//                assetName = [NSString stringWithFormat:@"dyp_unknown_%@",assetName];
//            }
            CGFloat animatedImageDataSize = CGImageGetBytesPerRow(mLocalImg.CGImage) * CGImageGetHeight(mLocalImg.CGImage);
            
//            if (monitor.isRunning) {
//                [monitor doMonitorWithUrl:assetName imageSize:animatedImageDataSize imagePath:imagePath];
//            }
        }
    }
    
    [self dyp_setImage:mLocalImg];
}

-(NSMutableString*)getViewPathByView:(UIView *)mView{
    NSMutableString *mViewPath = [[NSMutableString alloc] initWithString:@"ViewPath:"];
    NSInteger index = 0;
    for(UIView *next = mView ; next ;next = next.superview){
        UIResponder *nextResponder = [next nextResponder];
        if(nextResponder){
            if(index == 0) {
                [mViewPath appendString:NSStringFromClass(nextResponder.class)];
            }
            else{
                [mViewPath appendFormat:@"->%@",NSStringFromClass(nextResponder.class)];
            }
            index++;
            if([nextResponder isKindOfClass:[UIViewController class]]){
                break;
            }
        }
    }
    return mViewPath;
}
@end
