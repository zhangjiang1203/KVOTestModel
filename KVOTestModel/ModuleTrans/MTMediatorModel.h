//
//  MTMediatorModel.h
//  KVOTestModel
//
//  Created by douyu on 2023/3/6.
//  Copyright © 2023 zhangjiang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTMediatorModel : NSObject

+ (__kindof UIViewController *)detailViewControllerWithURL:(NSString *)detailURL;

@end

NS_ASSUME_NONNULL_END
