//
//  ViewController.m
//  KVOTestModel
//
//  Created by zj on 2019/10/11.
//  Copyright © 2019 zhangjiang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray<NSDictionary *> *showDataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMyUI];
}

- (void)initMyUI {
    self.showDataArr = [NSMutableArray arrayWithArray:@[
        @{@"title":@"搜索",@"class":@"QDBaseSearchViewController"},
        @{@"title":@"差值",@"class":@"ClassTestViewController"},
        @{@"title":@"类测试",@"class":@"ClassTestViewController"},
        @{@"title":@"UItableView configuration",@"class":@"ConfigurationViewController"},
        @{@"title":@"归档解档",@"class":@"TestCodeViewController"},
        @{@"title":@"Block测试",@"class":@"TestBlockViewController"},
        @{@"title":@"下载管理器",@"class":@"DownloadViewController"},
        @{@"title":@"RAC 测试",@"class":@"RACTestViewController"},
        @{@"title":@"语聊房",@"class":@"KXLiveRoomViewController"},
        @{@"title":@"协议转发测试",@"class":@"KXMoudleProtocolViewController"},
        @{@"title":@"消息转发",@"class":@"MessageSendViewController"},
        @{@"title":@"图片模糊处理",@"class":@"BlurryViewController"},
        @{@"title":@"多代理处理",@"class":@"MulDelegateViewController"},

    ]];
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, KScreenWidth, KScreenHeight-kNavBarAndStatusBarHeight) style:(UITableViewStylePlain)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.rowHeight = 44;
    [self.view addSubview:self.myTableView];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"systemCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    NSDictionary *dict = self.showDataArr[indexPath.row];
    cell.textLabel.text = dict[@"title"];// self.showDataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showDataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.showDataArr[indexPath.row];
    Class class = NSClassFromString(dict[@"class"]);
    UIViewController *baseVC = [[class alloc]init];
    [self.navigationController pushViewController:baseVC animated:YES];
}

@end
