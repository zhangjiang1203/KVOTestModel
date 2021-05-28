//
//  BlurryViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/27.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "BlurryViewController.h"
#import <Accelerate/Accelerate.h>
@interface BlurryViewController ()

@end

@implementation BlurryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片模糊处理";
    [self showTestImageView];
}


- (void)showTestImageView {
    
    NSArray *blurryNameArr = @[
        @"CIBokehBlur",
        @"CIBoxBlur",
        @"CIDepthBlurEffect",
        @"CIDiscBlur",
        @"CIGaussianBlur",
        @"CIMaskedVariableBlur",
        @"CIMedianFilter",
        @"CIMorphologyGradient",
        @"CIMorphologyMaximum",
        @"CIMorphologyMinimum",
        @"CIMotionBlur",
        @"CINoiseReduction",
        @"CIZoomBlur"
    ];
    
    UIImage *image = [UIImage imageNamed:@"test"];
    //创建多个imageVIew
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageW = (viewW-25)/4.0;
    CGFloat padding = 5;
    
    for (int i = 0; i < 20; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(padding + (padding + imageW) * (i % 4),90 + (padding + imageW) * floorf(i / 4.0), imageW, imageW)];
        imageView.clipsToBounds = TRUE;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        if (i == 0) {
//            imageView.image = image;
//        }else if (i == 1){
//            UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:beffect];
//            effectView.frame = imageView.bounds;
//            imageView.image = image;
//            [imageView insertSubview:effectView atIndex:0];
//        }else if (i == 2){
//            imageView.image = [self blurryImage:image withBlurLevel:1.6];
////            UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
////            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:beffect];
////            effectView.frame = imageView.bounds;
////            effectView.alpha = 0.5;
////            [imageView insertSubview:effectView atIndex:0];
//
//        }else{
//            imageView.image = [self coreImageImplement:image blurryName:blurryNameArr[i-3]];
            imageView.image = [self blurryImage:image withBlurLevel:i* 0.1];
//            UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:beffect];
//            effectView.frame = imageView.bounds;
//            effectView.alpha = 0.5;
//            [imageView insertSubview:effectView atIndex:0];

//        }
        [self.view addSubview:imageView];
    }
}
    
    
// 使用CoreImage实现图片模糊
- (UIImage *)coreImageImplement:(UIImage *)image blurryName:(NSString *)blurryName{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciimage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:blurryName];
    [filter setValue:ciimage forKey:kCIInputImageKey];
//    [filter setValue:@8.0f forKey:@"inputRadius"];
    [filter setDefaults];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *bluerImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return bluerImage;
}



- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
//    if (blur < 0.f || blur > 1.f) {
//        blur = 0.5f;
//    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}
@end
