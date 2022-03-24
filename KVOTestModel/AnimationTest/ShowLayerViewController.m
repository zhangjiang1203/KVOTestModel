//
//  ShowLayerViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2022/2/11.
//  Copyright © 2022 zhangjiang. All rights reserved.
//

#import "ShowLayerViewController.h"
#import "CustomShowView.h"

@interface ShowLayerViewController ()

@property (nonatomic, strong) CustomShowView *showView;

@property (nonatomic, strong) UISlider *sliderValue;

@property (nonatomic, strong) NSMutableArray *logMsgArr;

@property (nonatomic, strong) dispatch_queue_t logger_queue;

@property (nonatomic, strong) dispatch_group_t logger_Group;

@end

@implementation ShowLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"layer测试";
    self.logMsgArr = [NSMutableArray array];
    self.logger_queue = dispatch_queue_create("com.shidaiyinuo.NetWorkStudy", DISPATCH_QUEUE_CONCURRENT);
    self.logger_Group = dispatch_group_create();
    [self upSetShowView];
    [self addLoggerMessage];
}


- (void)addLoggerMessage{
    for (int i = 0; i<100; i++) {
        @autoreleasepool {
            NSString *logMsg = [NSString stringWithFormat:@"当前测试数据====%d",i];
            [self.logMsgArr addObject:logMsg];
            if (self.logMsgArr.count >= 20) {
                NSArray *logMsgArr = [self.logMsgArr copy];
                [self setLoggerMessageTest:logMsgArr];
                [self.logMsgArr removeAllObjects];
            }
        }
    }
}

- (void)funcTest{
    int x = 2;
    NSNumber *number = @(3);
    float (^showBlock)(float value) = ^float(float value){
        return value * x;
    };
    
    showBlock(5);
}


- (void)setLoggerMessageTest:(NSArray *)testArr{
//    __weak typeof(self) weakSelf = self;
    
    dispatch_group_async(self.logger_Group, self.logger_queue, ^{ @autoreleasepool {
        for (NSString *logMsg in testArr) {
            NSLog(@"logMsg===%@",logMsg);
        }
    }});
    
    dispatch_group_wait(self.logger_Group, DISPATCH_TIME_FOREVER);
    
}


- (void)upSetShowView{
    self.showView = [[CustomShowView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.showView.storkeColor = [UIColor grayColor];
    [self.view addSubview:self.showView];
    
    self.sliderValue = [[UISlider alloc]initWithFrame:CGRectMake(100, 250, 200, 30)];
    self.sliderValue.value = 0.5;
    [self.sliderValue addTarget:self action:@selector(valueChangeSlider:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:self.sliderValue];
}

- (void)valueChangeSlider:(UISlider *)sender{
    NSLog(@"开始变化=====%f",sender.value);
    self.showView.progress = sender.value;
}

@end
