//
//  ZTSegmentSlider.m
//  ZTMessageModule
//
//  Created by zhangjiang on 2021/7/23.
//

#import "ZTSegmentSlider.h"


#define KTAG 10
#define KANIMATION 0.5
#define KDefaultNorColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define KDefaultSelColor [UIColor colorWithRed:1 green:0 blue:0 alpha:1]
@interface ZTSegmentSlider ()<UIScrollViewDelegate>
{
    NSInteger maxWidth;
}

//添加视觉差动画效果显示
@property (strong,nonatomic)UIView *bottomView;

@property (strong,nonatomic)UIView *centerView;

@property (strong,nonatomic)UIView *topView;

@property (strong,nonatomic)UIScrollView *myScrollView;

@property (strong,nonatomic)UILabel *lineLabel;

@property (strong,nonatomic)UIButton *selectedBtn;

@property (nonatomic, strong) NSArray *allWidthsArr;

@end

@implementation ZTSegmentSlider

-(void)setTitleNorColor:(UIColor *)titleNorColor{
    _titleNorColor = titleNorColor;
    for (UIView *view in self.bottomView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)view;
            label.textColor = _titleNorColor;
        }
    }
}

-(void)setTitleSelColor:(UIColor *)titleSelColor{
    _titleSelColor = titleSelColor;
    for (UIView *view in self.topView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)view;
            label.textColor = _titleSelColor;
        }
    }
}

- (void)setFont:(UIFont *)font{
    _font = font;
    //重新计算当前的值
    [self removeAllSubviews];
    [self setMyTitleData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleConfig];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
                      titles:(NSArray<NSString*>*)titles{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleConfig];
        if (titles.count) {
            self.titlesArr = titles;
            [self setMyTitleData];
        }
    }
    return self;
}

- (void)setTitleConfig{
    self.titleNorColor = KDefaultNorColor;
    self.titleSelColor = KDefaultSelColor;
    self.isShowLineLabel = YES;
    self.allWidthsArr = [NSArray array];
    self.font = [UIFont systemFontOfSize:14];
    [self setUpMyScrollView];
}

-(void)setUpMyScrollView{
    
    self.myScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.myScrollView.delegate = self;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.bounces = YES;
    [self addSubview:self.myScrollView];
}

-(void)setMyTitleData{
    
    if (!(_titlesArr && _titlesArr.count > 0)) {
        return;
    }
    
    CGFloat viewHeight = self.bounds.size.height;
//    CGFloat viewWidth = self.bounds.size.width;
    //计算当前所有标题的最大长度
    NSMutableArray *widthArr = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [self.titlesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(self) strongSelf = weakSelf;
        CGFloat height = [strongSelf getSuitSizeWidthWithString:obj font:strongSelf.font height:viewHeight];
        [widthArr addObject:@(height)];
    }];

    self.allWidthsArr = [NSArray arrayWithArray:widthArr];
    //拿出标题最大的宽度
//    [widthArr enumerateObjectsUsingBlock:^(NSNumber*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (maxWidth < [obj integerValue]) {
//            maxWidth = [obj integerValue];
//        }
//    }];
//    maxWidth = maxWidth*widthArr.count > viewWidth?maxWidth:(viewWidth/widthArr.count);
    CGFloat contentWidth = [self calculateArrayWidthWithIndex:self.allWidthsArr.count];
    _myScrollView.contentSize = CGSizeMake(contentWidth, 0);
    
    //初始化三个显示的视图
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, contentWidth, viewHeight)];
    [self.myScrollView addSubview:_bottomView];
    self.centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self.allWidthsArr[0] floatValue], viewHeight)];
    self.centerView.clipsToBounds = YES;
    [self.myScrollView addSubview:self.centerView];
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, contentWidth, viewHeight)];
    [self.centerView addSubview:self.topView];
    
    //添加按钮
    [self.titlesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(self) strongSelf = weakSelf;
        CGFloat buttonX = [self calculateArrayWidthWithIndex:idx];
        CGRect rect = CGRectMake(buttonX,0, [self.allWidthsArr[idx] floatValue], viewHeight);
        //添加文字标签
        UILabel *bottomLabel = [[UILabel alloc]initWithFrame:rect];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.text = obj;
        bottomLabel.font = weakSelf.font;
        bottomLabel.textColor = weakSelf.titleNorColor;
        [weakSelf.bottomView addSubview:bottomLabel];
        
        UILabel *topLabel = [[UILabel alloc]initWithFrame:rect];
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.text = obj;
        topLabel.font = weakSelf.font;
        topLabel.textColor = weakSelf.titleSelColor;
        [weakSelf.topView addSubview:topLabel];
        
        UIButton *titleBtn = [[UIButton alloc]initWithFrame:rect];
        titleBtn.tag = idx + KTAG;
//                titleBtn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
//                [titleBtn setTitle:obj forState:UIControlStateNormal];
//                [titleBtn setTitleColor:self.titleNorColor forState:UIControlStateNormal];
//                [titleBtn setTitleColor:self.titleSelColor forState:UIControlStateSelected];
        [titleBtn addTarget:strongSelf action:@selector(titleButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [strongSelf.myScrollView addSubview:titleBtn];
    }];
    //默认选中第一个
    [self titleButtonClickAction:[self viewWithTag:KTAG]];
    
//    self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, viewHeight-1, maxWidth, 1)];
//    self.lineLabel.backgroundColor = self.titleSelColor;
//    self.lineLabel.hidden = !self.isShowLineLabel;
//    [self.myScrollView addSubview:self.lineLabel];

}

/// 计算数组中的和
- (CGFloat)calculateArrayWidthWithIndex:(NSInteger)index{
    CGFloat width = 0;
    for (int i = 0; i < index; i++) {
        width += [self.allWidthsArr[i] floatValue];
    }
    return width;
}

-(void)setTitlesArr:(NSArray<NSString *> *)titlesArr{
    _titlesArr = titlesArr;
    //按钮全部移除 在添加
    [self removeAllSubviews];
    [self setMyTitleData];
}

- (void)removeAllSubviews{
    //按钮全部移除 在添加
    [self.bottomView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.topView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    [self.lineLabel removeFromSuperview];

}

-(void)setIsShowLineLabel:(BOOL)isShowLineLabel{
    _isShowLineLabel = isShowLineLabel;
    self.lineLabel.hidden = !_isShowLineLabel;
}

- (void)changeCurrentSegmentWithIndex:(NSInteger)currentIndex{
    UIButton *sender = (UIButton *)[self viewWithTag:currentIndex + KTAG];
    if (sender) {
        [self titleButtonClickAction:sender];        
    }
}

-(void)titleButtonClickAction:(UIButton*)sender{
    
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    
    CGFloat originX = [self calculateArrayWidthWithIndex:sender.tag - KTAG];
    CGFloat width = [self.allWidthsArr[sender.tag - KTAG] floatValue];
    CGRect lineRect = self.lineLabel.frame;
    lineRect.origin.x = originX;
    lineRect.size.width = width;
    
    //改变centerView和topView的相对位置
    CGRect centerRect = self.centerView.frame;
    centerRect.origin.x = originX;
    centerRect.size.width = width;
    
    CGRect topRect = self.topView.frame;
    topRect.origin.x = -originX;
    topRect.size.width = width;
    
    [UIView animateWithDuration:KANIMATION animations:^{
        self.centerView.frame = centerRect;
        self.topView.frame = topRect;
//        self.lineLabel.frame = lineRect;
    }];
    [self setScrollOffset:sender.tag];
    self.segmentBlock?self.segmentBlock(sender.tag-KTAG):nil;
    
}

-(void)setSegmentMoveToIndex:(NSInteger)index{
    UIButton *sender = (UIButton*)[self viewWithTag:index+KTAG];
    [self titleButtonClickAction:sender];
}

//设置scrollview的移动位置
- (void)setScrollOffset:(NSInteger)index{
    UIButton *sender = (UIButton*)[self viewWithTag:index];
    CGRect rect = sender.frame;
    float midX = CGRectGetMidX(rect);
    float offset = 0;
    float contentWidth = _myScrollView.contentSize.width;
    if (contentWidth <= self.bounds.size.width) {
        return;
    }
    
    float halfWidth = CGRectGetWidth(self.bounds) / 2.0;
    if (midX < halfWidth) {
        offset = 0;
    }else if (midX > contentWidth - halfWidth){
        offset = contentWidth - 2 * halfWidth;//[self calculateArrayWidthWithIndex:index-KTAG];
    }else{
        offset = midX - halfWidth;
    }
    NSLog(@"当前滚动距离=====%f",offset);
    [UIView animateWithDuration:KANIMATION animations:^{
        [self.myScrollView setContentOffset:CGPointMake(offset, 0) animated:NO];
    }];
}

/**
 *  @brief 计算文字的宽度
 */
 -(CGFloat)getSuitSizeWidthWithString:(NSString *)text font:(UIFont *)font height:(float)height{
 
     CGSize constraint = CGSizeMake(MAXFLOAT, height);
     NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
     // 返回文本绘制所占据的矩形空间。
     CGSize contentSize = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
     return contentSize.width+15;
 }

@end
