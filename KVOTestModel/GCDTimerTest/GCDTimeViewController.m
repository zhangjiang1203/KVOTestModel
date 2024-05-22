//
//  GCDTimeViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2023/7/18.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import "GCDTimeViewController.h"
#import "DYGCDTimer.h"
#import "GCDQueue.h"

#import <Masonry/Masonry.h>
@interface GCDTimeViewController ()

@property (nonatomic, strong) DYGCDTimer *timer;

@property (nonatomic, strong) UILabel *showLabel;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, strong) UIButton *insertBtn;

@property (nonatomic, strong) UIButton *cleanBtn;

@end

@implementation GCDTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _duration = 10;
    [self setUpUI];
}

- (void)testTimer:(UIButton *)sender {
    if(sender.tag == 1){
        [self.timer start];
    }else{
        [self.timer destroy];
        self.duration = 10;
    }
}

- (void)setUpUI {
    
    _showLabel = [[UILabel alloc] init];
    _showLabel.textColor = [UIColor redColor];
    _showLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_showLabel];
    [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(100);
    }];
    
    NSString *titleStr = @"测试展示数据 | hahahah | 我来了兄弟们 | 测试展示数据";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\|" options:(NSRegularExpressionCaseInsensitive) error:nil];
    NSArray<NSTextCheckingResult *> *resultArr = [regex matchesInString:titleStr options:0 range:NSMakeRange(0, titleStr.length)];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:titleStr attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    [resultArr enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
        [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:obj.range];
    }];
    _showLabel.attributedText = attStr;
    
    _insertBtn = [[UIButton alloc]init];
    _insertBtn.tag = 1;
    [_insertBtn setTitle:@"开始" forState:(UIControlStateNormal)];
    [_insertBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [_insertBtn addTarget:self action:@selector(testTimer:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_insertBtn];
    
    [_insertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(130);
    }];
    
    _cleanBtn = [[UIButton alloc]init];
    _cleanBtn.tag = 2;
    [_cleanBtn setTitle:@"结束" forState:(UIControlStateNormal)];
    [_cleanBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [_cleanBtn addTarget:self action:@selector(testTimer:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_cleanBtn];
    
    [_cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(_insertBtn.mas_bottom).offset(10);
    }];
    
    
    UIView *testView = [[UIView alloc] init];
    testView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:testView];
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(250);
        make.height.mas_equalTo(100);
    }];
}


- (DYGCDTimer *)timer {
    if(!_timer){
        _timer = [[DYGCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
        [_timer event:^{
            self.duration -= 1;
            self.showLabel.text = [NSString stringWithFormat:@"倒计时:%zd",self.duration];
            if(self.duration <= 0){
                [self.timer destroy];
            }
        } timeIntervalWithSecs:1];
    }
    return _timer;
}

@end
