//
//  ZJPipelineTestViewController.m
//  KVOTestModel
//
//  Created by douyu on 2023/3/20.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import "ZJPipelineTestViewController.h"
#import <Masonry/Masonry.h>
#import "ZJPipelineCenter.h"


@interface ZJPipelineTestViewController ()

@property (nonatomic, strong) UIButton *insertBtn;

@property (nonatomic, strong) UIButton *cleanBtn;

@property (nonatomic, strong) ZJPipelineCenter *pipelineCenter;

@end

@implementation ZJPipelineTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}


- (void)setUpUI {
    
    self.pipelineCenter = [[ZJPipelineCenter alloc] init];
    
    _insertBtn = [[UIButton alloc]init];
    _insertBtn.tag = 1;
    [_insertBtn setTitle:@"插入数据" forState:(UIControlStateNormal)];
    [_insertBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [_insertBtn addTarget:self action:@selector(testPipelineAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_insertBtn];
    
    [_insertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(100);
    }];
    
    _cleanBtn = [[UIButton alloc]init];
    _cleanBtn.tag = 2;
    [_cleanBtn setTitle:@"开始清空" forState:(UIControlStateNormal)];
    [_cleanBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [_cleanBtn addTarget:self action:@selector(testPipelineAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_cleanBtn];
    
    [_cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(_insertBtn.mas_bottom).offset(10);
    }];
}

- (void)testPipelineAction:(UIButton *)sender {
    if(sender.tag == 1) {
        [self.pipelineCenter insertMsg:[NSString stringWithFormat:@"我上海测试数据===%zd",arc4random_uniform(1000)]];
    } else {
        [self.pipelineCenter clean];
    }
    
}
@end
