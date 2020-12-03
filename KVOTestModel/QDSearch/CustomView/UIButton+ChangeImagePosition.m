//
//  UIButton+ChangeImagePosition.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/10.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "UIButton+ChangeImagePosition.h"
/**
  PS:扩展就是设置负值。收缩就是设置正值
 
 那么，想实现文字在左，图片在右，就需要文字向左边调整，图片向右边调整
 1.按钮文字向左边调整，就需要按钮文字左边扩展，右边收缩   按钮文字向左边扩展，即left方向需要扩展图片的宽度+间距*0.5； 按钮文字向右边需要收缩，即right方向需要收缩图片的宽度+间距*0.5；
 2.按钮图片向右边调整，就需要按钮图片右边扩展，左边收缩   按钮图片向右边扩展，即right方向需要扩展文字的宽度+间距*0.5； 按钮图片向左边收缩，即left方向需要搜索文字的宽度+间距*0.5
 
 
 如果要实现上下,比如图片在上，文字在下：
 图片上移：顶部向上扩展，底部收缩 因为本身就是垂直居中的，所以移动的距离是：imageHeight*0.5 + padding*0.5
 文字下移：顶部收缩，底部扩展 移动距离是：titleHeight*0.5 + padding*0.5;
 这样做还不够，因为默认图片在左，文字在右。所以还要想办法让他们左右居中：
 1.图片左边收缩，右边扩展 移动的距离是：(titleWidth+imageWidth)*0.5-imageWidth*0.5 即 titleWidth*0.5;
 2.文字左边扩展，右边收缩 移动的距离是：(titleWidth+imageWidth)*0.5-titleWidth*0.5 即 imageWidth*0.5;
 
 其他的以此来类比
 */

@implementation UIButton (ChangeImagePosition)

- (void)setButtonStyle:(QDImageTitleButtonStyle)style padding:(CGFloat)padding{
    CGSize imageSize = [self imageRectForContentRect:self.frame].size;
    CGSize labelSize = [self.titleLabel.text boundingRectWithSize:self.frame.size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleInsets = UIEdgeInsetsZero;
    
    switch (style) {
        
        case QDImageTitleButtonStyle_ImageTopTitleBottom:
            imageInsets = UIEdgeInsetsMake(-(imageSize.height+padding)*0.5, labelSize.width*0.5, (imageSize.height+padding)*0.5, -labelSize.width*0.5);
            titleInsets = UIEdgeInsetsMake((labelSize.height+padding)*0.5, -imageSize.width*0.5, -(labelSize.height+padding)*0.5, imageSize.width*0.5);
            break;
        case QDImageTitleButtonStyle_TitleTopImageBottom:
            imageInsets = UIEdgeInsetsMake((imageSize.height+padding)*0.5, labelSize.width*0.5, -(imageSize.height+padding)*0.5, -labelSize.width*0.5);
            titleInsets = UIEdgeInsetsMake(-(labelSize.height+padding)*0.5, -imageSize.width*0.5, (labelSize.height+padding)*0.5, imageSize.width*0.5);
            break;
        case QDImageTitleButtonStyle_ImageLeftTitleRight:
            imageInsets = UIEdgeInsetsMake(0, 0, 0, padding);
            titleInsets = UIEdgeInsetsMake(0, padding, 0, 0);
            break;
        case QDImageTitleButtonStyle_TitleLeftImageRight:
            imageInsets = UIEdgeInsetsMake(0, labelSize.width+padding*0.5, 0, -(labelSize.width+padding*0.5));
            titleInsets = UIEdgeInsetsMake(0, -(imageSize.width+padding*0.5), 0, imageSize.width+padding*0.5);
            break;
    }
    self.imageEdgeInsets = imageInsets;
    self.titleEdgeInsets = titleInsets;
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
}

@end
