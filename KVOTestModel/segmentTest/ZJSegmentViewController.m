//
//  ZJSegmentViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/10/14.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJSegmentViewController.h"
#import "ZTSegmentSlider.h"
@interface ZJSegmentViewController ()
@property (nonatomic, strong) ZTSegmentSlider *segmentSlider;

@end

@implementation ZJSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"segment设置";
    [self segmentSetUp];
}

- (void)segmentSetUp{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    _segmentSlider = [[ZTSegmentSlider alloc]initWithFrame:CGRectMake(0, 100, width,40) titles:@[@"我来了",@"你好了",@"哈哈哈吃饭了没",@"就是这样",@"好了",@"开始睡觉吧",@"还有谁",@"等了很久了吧",@"我们的加就是中国"]];
    _segmentSlider.titleNorColor = [UIColor blackColor];
    _segmentSlider.titleSelColor = [UIColor redColor];
    
    _segmentSlider.font = [UIFont systemFontOfSize:14];
    _segmentSlider.segmentBlock = ^(NSInteger clickTag) {
        //选中对应的cell 更新数据源
        
    };
    [self.view addSubview:_segmentSlider];

}



@end
