//
//  UIImage+MonitorHook.m
//  DYPerformanceMonitor
//
//  Created by  liuqi on 2019/6/18.
//

#import "UIImage+DYPMonitorHook.h"
#import "SwizzleHook.h"
#import <objc/runtime.h>

@implementation UIImage (DYPMonitorHook)

+ (void)dypHookSetImageName
{
    dyphookMethod([self class], @selector(imageNamed:), [self class], @selector(dyp_imageNamed:), YES);
    dyphookMethod([self class], @selector(imageWithContentsOfFile:), [self class], @selector(dyp_imageWithContentsOfFile:), YES);
    dyphookMethod([self class], @selector(imageNamed:inBundle:compatibleWithTraitCollection:), [self class], @selector(dyp_imageNamed:inBundle:compatibleWithTraitCollection:), YES);
    dyphookMethod([self class], @selector(initWithContentsOfFile:), [self class], @selector(dyp_initWithContentsOfFile:), NO);
    dyphookMethod([self class], @selector(resizableImageWithCapInsets:), [self class], @selector(dyp_resizableImageWithCapInsets:), NO);
    dyphookMethod([self class], @selector(resizableImageWithCapInsets:resizingMode:), [self class], @selector(dyp_resizableImageWithCapInsets:resizingMode:), NO);
    dyphookMethod([self class], @selector(imageWithRenderingMode:), [self class], @selector(dyp_imageWithRenderingMode:), NO);
    
//    dyphookMethod([self class], @selector(imageWithCGImage:), [self class], @selector(dyp_imageWithCGImage:), YES);
//    dyphookMethod([self class], @selector(imageWithData:), [self class], @selector(dyp_imageWithData:), YES);
    
}

+ (UIImage *)dyp_imageNamed:(NSString *)mImageName{

    UIImage *mTempImg = [self dyp_imageNamed:mImageName];
    
    if (mImageName.length > 0 && mTempImg.accessibilityIdentifier.length == 0) {
        mTempImg.accessibilityIdentifier = mImageName;
    }
    return mTempImg;
}

+ (UIImage *)dyp_imageWithContentsOfFile:(NSString *)path{
    UIImage *mTempImg = [self dyp_imageWithContentsOfFile:path];
    if (path.length > 0 && mTempImg.accessibilityIdentifier.length == 0) {
        mTempImg.accessibilityIdentifier = [path lastPathComponent];
    }
    return mTempImg;
}

+ (UIImage *)dyp_imageNamed:(NSString *)name inBundle:(nullable NSBundle *)bundle compatibleWithTraitCollection:(nullable UITraitCollection *)traitCollection NS_AVAILABLE_IOS(8_0);
{
    UIImage *mTempImg = [self dyp_imageNamed:name inBundle:bundle compatibleWithTraitCollection:traitCollection];
    if (name.length > 0 && mTempImg.accessibilityIdentifier.length == 0) {
        mTempImg.accessibilityIdentifier = name;
    }
    return mTempImg;
}

- (UIImage *)dyp_initWithContentsOfFile:(NSString *)path{
    if (path.length > 0 && self.accessibilityIdentifier.length == 0) {
        self.accessibilityIdentifier = [path lastPathComponent];
    }
    return [self dyp_initWithContentsOfFile:path];
}

- (UIImage *)dyp_imageWithRenderingMode:(UIImageRenderingMode)renderingMode{
    NSString *oldIdentifier = self.accessibilityIdentifier;
    UIImage *newImage = [self dyp_imageWithRenderingMode:renderingMode];
    if (newImage.accessibilityIdentifier.length == 0) {
        newImage.accessibilityIdentifier = oldIdentifier;
    }
    return newImage;
}

- (UIImage *)dyp_resizableImageWithCapInsets:(UIEdgeInsets)capInsets{
    NSString *oldIdentifier = self.accessibilityIdentifier;
    UIImage *newImage = [self dyp_resizableImageWithCapInsets:capInsets];
    if (newImage.accessibilityIdentifier.length == 0) {
        newImage.accessibilityIdentifier = oldIdentifier;
    }
    return newImage;
}


- (UIImage *)dyp_resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode{
    NSString *oldIdentifier = self.accessibilityIdentifier;
    UIImage *newImage = [self dyp_resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
    if (newImage.accessibilityIdentifier.length == 0) {
        newImage.accessibilityIdentifier = oldIdentifier;
    }
    return newImage;
}

+(void)getAllMethods
{
    unsigned int methodCount =0;
    Method* methodList = class_copyMethodList([self class],&methodCount);
    
    for(int i=0;i<methodCount;i++)
    {
        Method temp = methodList[i];
        const char* name_s =sel_getName(method_getName(temp));
        int arguments = method_getNumberOfArguments(temp);
        const char* encoding =method_getTypeEncoding(temp);
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,
              [NSString stringWithUTF8String:encoding]);
    }
    free(methodList);
}
@end
