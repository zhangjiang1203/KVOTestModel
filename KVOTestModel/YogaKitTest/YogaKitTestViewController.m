//
//  YogaKitTestViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/12/23.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "YogaKitTestViewController.h"
#import "YogaNormalLayoutViewController.h"

//#import <YogaKit/UIView+Yoga.h>

@interface YogaKitTestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSArray *dataSourceArr;

@end

@implementation YogaKitTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YogaKit Test";
    self.view.backgroundColor = [UIColor whiteColor];
//    //设置主界面的layout
//    [self.view configureLayoutWithBlock:^(YGLayout *layout) {
//        layout.isEnabled = YES;
//        layout.paddingTop = YGPointValue(100);
//    }];
//    [self setUpTableView];
//    //父视图执行布局计算并使用结果更新层次结构中视图的帧
//    [self.view.yoga applyLayoutPreservingOrigin:YES];
    
    [self test_dispatch_time];
}

- (void)test_dispatch_time {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self performSelector:@selector(testLogDispatch) withObject:nil];
    [self performSelector:@selector(testLogDispatch) withObject:nil afterDelay:5];
//    });
}

- (void)testLogDispatch{
    NSLog(@"开始执行=====");
}

- (void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSLog(@"开始释放=====");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

}

//设置tableview
- (void)setUpTableView{
    self.dataSourceArr = @[
        @{@"title":@"常规布局",@"class":@"YogaNormalLayoutViewController"},
        @{@"title":@"非常规布局",@"class":@"YogaSpecialLayoutViewController"},
    ];
    
    self.myTableView = [[UITableView alloc]init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
//    self.myTableView.layer.cornerRadius = 10;
//    self.myTableView.layer.masksToBounds = YES;
    [self.view addSubview:self.myTableView];
    
    
    
//    [self.myTableView configureLayoutWithBlock:^(YGLayout *layout) {
//        layout.isEnabled = YES;
//        layout.margin = YGPointValue(0);
//        layout.flexDirection = YGFlexDirectionColumn;
//    }];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"systemCell"];
    }
    NSDictionary *dict = self.dataSourceArr[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataSourceArr[indexPath.row];
    Class class = NSClassFromString(dict[@"class"]);
    UIViewController *baseVC = [[class alloc]init];
    [self.navigationController pushViewController:baseVC animated:YES];
}

@end
