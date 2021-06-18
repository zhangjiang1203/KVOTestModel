//
//  MulDelegateViewController.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/14.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//组合式 枚举
typedef NS_ENUM(NSUInteger, ShowViewListType) {
    ShowView_Type1 = 0,
    ShowView_Type2 = 1 << 0,
    ShowView_Type3 = 1 << 1,
    ShowView_Type4 = 1 << 2,
    ShowView_Type5 = 1 << 3,
    ShowView_Type6 = 1 << 4,
};


@interface MulDelegateViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
