//
//  ConfigurationViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/10/29.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "TestConfigurationCell.h"


@interface ConfigurationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *myTableView;

@end

@implementation ConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"展示的数据";
    self.myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    [self.myTableView registerClass:NSClassFromString(@"TestConfigurationCell") forCellReuseIdentifier:@"TestConfigurationCell"];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestConfigurationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestConfigurationCell"];
    if (cell == nil) {
        cell = [[TestConfigurationCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"TestConfigurationCell"];
    }
    cell.customLabel.text = [NSString stringWithFormat:@"我就是展示的数据==%zd",indexPath.row];
//    cell.defaultContentConfiguration updatedConfigurationForState:(nonnull id<UIConfigurationState>)
    return cell;
}

@end
