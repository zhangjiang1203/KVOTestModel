//
//  ZTSegmentSlider.h
//  ZTMessageModule
//
//  Created by zhangjiang on 2021/7/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SegmentBlock)(NSInteger clickTag);

@interface ZTSegmentSlider : UIView

/**
 显示底部的横线
 */
@property (nonatomic, assign) BOOL isShowLineLabel;

/**
 未选中颜色
 */
@property (nonatomic, strong) UIColor *titleNorColor;

/**
 选中颜色
 */
@property (nonatomic, strong) UIColor *titleSelColor;

/**
 添加的标题数组
 */
@property (nonatomic, strong) NSArray<NSString*> *titlesArr;

/**
 字体大小
 */
@property (nonatomic, strong) UIFont *font;


@property (nonatomic, copy) SegmentBlock segmentBlock;


- (instancetype)initWithFrame:(CGRect)frame
                      titles:(NSArray<NSString*>*)titles;

/// 指定选择index
- (void)changeCurrentSegmentWithIndex:(NSInteger)currentIndex;
@end

NS_ASSUME_NONNULL_END
