//
//  ZJTableLayoutViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2022/7/25.
//  Copyright © 2022 zhangjiang. All rights reserved.
//

#import "ZJTableLayoutViewController.h"
#import <Masonry/Masonry.h>

@interface ZJTableLayoutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *titleDatasArr;

@end

@implementation ZJTableLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试tableView";
    self.titleDatasArr = [NSMutableArray array];
    [self setUpTablView];
}

- (void)setUpTablView {
    
    for (int i = 0; i<2; i++) {
        NSString *temStr = [NSString stringWithFormat:@"我就是测试展示数据你好结了婚地方%d",i];
        [self.titleDatasArr addObject:temStr];
    }
    
    /// 添加按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 100, 30)];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btn setTitle:@"添加数据" forState:(UIControlStateNormal)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(addTestData:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor redColor];
    self.myTableView.estimatedRowHeight = 55;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-40);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(self.titleDatasArr.count * 55);
    }];
}

- (void)addTestData:(UIButton *)sender {
    NSString *showName = [NSString stringWithFormat:@"再来一次数据，hah=%d",arc4random_uniform(100)+100];
    [self.titleDatasArr addObject:showName];
    CGFloat height = self.titleDatasArr.count * 55;
    if (height >= 350) {
        height = 350;
    }
    [self.myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    [self.myTableView reloadData];
    [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.titleDatasArr.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
}

#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleDatasArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"systemCell"];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = self.titleDatasArr[indexPath.row];
    return cell;
}
@end
