//
//  ViewController.m
//  KVOTestModel
//
//  Created by zj on 2019/10/11.
//  Copyright © 2019 zhangjiang. All rights reserved.
//

#import "ViewController.h"
#import "CorasickTreeManager.h"

#define KScreenWidth [[UIScreen mainScreen]bounds].size.width
#define KScreenHeight [[UIScreen mainScreen]bounds].size.height
#define kIs_iPhoneX KScreenWidth >=375.0f && KScreenHeight >=812.0f
 
/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(kIs_iPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIButton *acButton;
@property (nonatomic,strong) UIButton *forButton;
@property (nonatomic,strong) UIButton *clearButton;
@property (nonatomic,strong) UITextField *findTextField;

@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray<NSString *> *showDataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMyUI];
    
}

- (void)initMyUI {
    self.showDataArr = [NSMutableArray array];
    NSString *timeStr = [[CorasickTreeManager shareInstance] createTrieTree];
    [self.showDataArr addObject:timeStr];
    
    CGFloat buttonW = (KScreenWidth - 50)/4;
    NSArray *tepmStr = @[@"for循环",@"ac自动机",@"清空自动机",@"重建自动机"];
    for (int i = 1; i < 5; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10*(i+1)+buttonW*i, kNavBarAndStatusBarHeight+45, buttonW, 30)];
        btn.tag = i;
        btn.backgroundColor = [UIColor redColor];
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [btn setTitle:tepmStr[i] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(actionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:btn];
    }
    
    self.findTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, kNavBarAndStatusBarHeight, KScreenWidth-40, 40)];
    self.findTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.findTextField.placeholder = @"输入搜索文字";
//    self.findTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:self.findTextField];
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight+80, KScreenWidth, KScreenHeight-100-kNavBarAndStatusBarHeight) style:(UITableViewStylePlain)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.rowHeight = 30;
    [self.view addSubview:self.myTableView];
   
}


- (void)actionButtonClick:(UIButton*)sender {
    if (self.findTextField.text.length <= 0) {
        return;
    }
    if (sender.tag == 3){
        [[CorasickTreeManager shareInstance] clearTrieTree];
        [self.showDataArr removeAllObjects];
        [self.myTableView reloadData];
        return;
    }
    NSString *timeStr = nil;
    if (sender.tag == 2) {
        timeStr = [[CorasickTreeManager shareInstance]trieFindMyTree:self.findTextField.text];
    }else if (sender.tag == 1) {
        timeStr = [[CorasickTreeManager shareInstance]forNormalTimeCal:self.findTextField.text];
    }else if (sender.tag == 4){
        timeStr = [[CorasickTreeManager shareInstance]createTrieTree];
    }
    [self.showDataArr insertObject:timeStr atIndex:0];
    [self.myTableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"systemCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    cell.textLabel.text = self.showDataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showDataArr.count;
}


@end
