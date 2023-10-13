//
//  ZJCustomChooseViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2023/10/12.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import "ZJCustomChooseViewController.h"
#import "DYHBChooseItemView.h"

#import <Masonry/Masonry.h>
@interface ZJCustomChooseViewController ()

@property (nonatomic, strong) DYHBChooseItemView *chooseItemView;

@end

@implementation ZJCustomChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择列表";
    [self setUpChooseItemView];
}


- (void)setUpChooseItemView {
    self.chooseItemView = [[DYHBChooseItemView alloc] init];
    [self.view addSubview:self.chooseItemView];
    
    [self.chooseItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end
