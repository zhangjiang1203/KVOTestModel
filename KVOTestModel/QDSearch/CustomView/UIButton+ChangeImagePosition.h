//
//  UIButton+ChangeImagePosition.h
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/10.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QDImageTitleButtonStyle) {
    QDImageTitleButtonStyle_ImageTopTitleBottom = 1,    //图上字下
    QDImageTitleButtonStyle_TitleTopImageBottom,        //图下字上
    QDImageTitleButtonStyle_ImageLeftTitleRight,        //图左字右
    QDImageTitleButtonStyle_TitleLeftImageRight,        //图右字左

};

@interface UIButton (ChangeImagePosition)
- (void)setButtonStyle:(QDImageTitleButtonStyle)style padding:(CGFloat)padding;
@end

NS_ASSUME_NONNULL_END
