//
//  ZJTableLayoutViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2022/7/25.
//  Copyright © 2022 zhangjiang. All rights reserved.
//

#import "ZJTableLayoutViewController.h"
#import <Masonry/Masonry.h>
#import "DYHBLuckyBagInfoCell.h"
#import "DYHBAwardRecordCell.h"
#import <CoreText/CoreText.h>
#import "Person.h"

#import <YYText/YYText.h>

static NSString *const kSplitKey = @"*&!&*";

@interface ZJTableLayoutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *titleDatasArr;

@end

@implementation ZJTableLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试tableView";
    self.titleDatasArr = [NSMutableArray array];
    
    NSString *tem = [NSString stringWithFormat:@"数量客服经理可视对讲%@878978787",kSplitKey];
    NSString *key = [tem componentsSeparatedByString:kSplitKey].firstObject;
    NSLog(@"当前获取的key:%@",key);
    
    UIImageView *avatarImageView = [UIImageView new];
    avatarImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:avatarImageView];
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *giftNameLabel = [[UILabel alloc] init];
    giftNameLabel.text = @"我就是我";
    giftNameLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    giftNameLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:giftNameLabel];
    [giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(avatarImageView.mas_bottom).mas_equalTo(40);
    }];
    
    
    
//    for (int i = 0; i<10; i++) {
//        NSString *temStr = [NSString stringWithFormat:@"%d",i];
//        temStr = [temStr stringByAppendingString:i%2 == 0 ? @"我是偶数斐林试剂防晒衣一哦送达飞机发撒发大水发大水水电费水电费" : @"我是奇数"];
//        [self.titleDatasArr addObject:temStr];
//    }
//    [self setUpTablView];
//    [self arrayTest];
//    [self showNameTest];
//    [self testMulDict];
}

- (void)testMulDict {
    
    NSTimeInterval interval = 0;//[DYRequestAuthUtil serverTimeDiffer];
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval duration = 1695019547 - currentInterval;
    // 提前三天更新accessToken
    if(duration < 3 * 24 * 60 * 60){
        NSLog(@"更新用户token");
    }
    
//    NSMutableArray *tempArr = [NSMutableArray array];
//    for (id obj in tempArr.reverseObjectEnumerator) {
//        NSLog(@"11111");
//    }

//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
//
//    for (int i = 0; i< 20; i++) {
//        dict[@(i)] = @(i);
//    }
//    NSLog(@"当前数组中的值===%zd",dict.count);
}

- (void)showNameTest {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[@"我就是我一不要难过" dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 weight:UIFontWeightBold] range:NSMakeRange(0, attrStr.length)];
    
    NSMutableAttributedString *copyStr = [attrStr copy];
    
    NSLog(@"当前设置的内容==%p,copy:%p",attrStr,copyStr);
}

- (void)arrayTest {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:6];
    
    [arr insertObject:@(2) atIndex:5];
    [arr insertObject:@(4) atIndex:0];
    
    NSLog(@"arr==%@",arr);
}

- (void)versionCompare {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSComparisonResult result = [appVersion compare:@"2.0.1"];
    if(result == NSOrderedAscending){
        NSLog(@"本地版本号 小于给定版本号");
    }else if(result == NSOrderedSame){
        NSLog(@"版本号相同");
    }else{
        NSLog(@"本地版本号 大于给定版本号");
    }
}

- (void)numberTest {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.maximumFractionDigits = 2;
    formatter.roundingMode = NSNumberFormatterRoundUp;
    NSNumber *number = [NSNumber numberWithFloat:131.3];
    NSString *ret = [formatter stringFromNumber:number];
    NSLog(@"得到的数据===%@",ret);
//
//    NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
//    [formatter1 setNumberStyle:NSNumberFormatterDecimalStyle];
//    [formatter1 setMaximumFractionDigits:2];
//
//    NSString *formattedString = [formatter1 stringFromNumber:number];
//    NSLog(@"%@", formattedString);
    
    // 创建NSNumberFormatter实例
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setMaximumFractionDigits:2]; // 设置最大保留两位小数
//
//    // 将数字转换成字符串
//    NSNumber *number = [NSNumber numberWithFloat:131.3];
//    NSString *formattedNumberString = [numberFormatter stringFromNumber:number];
//
//    // 去掉尾部的0和小数点
//    NSRange range = [formattedNumberString rangeOfString:@"."];
//    if (range.location != NSNotFound) {
//        NSString *subString = [formattedNumberString substringFromIndex:range.location];
//        if ([subString isEqualToString:@".00"] || [subString isEqualToString:@".0"]) {
//            formattedNumberString = [formattedNumberString substringToIndex:range.location];
//        }
//    }

    // 输出结果
//    NSLog(@"%@", formattedNumberString);
}

- (void)testPredicationArr {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i < 30; i++) {
        Person *person = [Person new];
        person.age = i;
        if(i == 20){
            person.name = @"zhangjiang";
        }else{
            person.name = [NSString stringWithFormat:@"测试展示数据===%d",i];
        }
        [tempArr addObject:person];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",@"zhangjiang"];
    
    NSArray *testNet = [tempArr filteredArrayUsingPredicate:predicate];
    
    
    NSLog(@"当前数组===%@",testNet);
    
}

- (void)setUpTablView {
    //数据处理
    NSArray *showName = nil;
    
    NSLog(@"最后一个展示的数据==%@",showName.lastObject);
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        for (int i = 0; i<10; i++) {
//            NSString *temStr = [NSString stringWithFormat:@"%d",i];
//            temStr = [temStr stringByAppendingString:i%2 == 0 ? @"我是偶数斐林试剂防晒衣一哦送达飞机发撒发大水发大水水电费水电费" : @"我是奇数"];
//            [self.titleDatasArr addObject:temStr];
//        }
//
//
//        [self.titleDatasArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSLog(@"========%@===%@",obj,self);
//        }];
//
//    });
    
    /// 添加按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 100, 30)];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btn setTitle:@"添加数据" forState:(UIControlStateNormal)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(addTestData:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    self.myTableView.backgroundColor = [UIColor redColor];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.estimatedRowHeight = 55;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    [self.myTableView registerClass:[DYHBAwardRecordCell class] forCellReuseIdentifier:[DYHBAwardRecordCell reuseIdentifier]];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"systemCell"];
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(self.titleDatasArr.count * 55);
        make.top.mas_equalTo(btn.mas_bottom);
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 55;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
    if (cell != nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:[DYHBAwardRecordCell reuseIdentifier]];
        DYHBAwardRecordCell *awardCell = ( DYHBAwardRecordCell *)cell;
        [awardCell setWinInfoModel:self.titleDatasArr[indexPath.row]];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [self createTableViewHeaderView:@"收到浪费吉林省首单礼金法律手段看风景了三大发大水发大水李开复电视剧斐林试剂发来的风扇电机发多少打发时间到付件圣诞快乐飞机 "];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

/// 构建tableview headerview
- (UIView *)createTableViewHeaderView:(NSString *)title {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.bounds = CGRectMake(0, 0, KScreenWidth - 32, 40);
    [headerView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    
    UIView *contentView = [UIView new];
    [bgView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_lessThanOrEqualTo(KScreenWidth - 80);
    }];
    
    
    NSString *awardStr = [NSString stringWithFormat:@"  %@  ",@"一等奖"];
    
    UIButton *levelBtn = [[UIButton alloc] init];
    levelBtn.enabled = NO;
    levelBtn.layer.cornerRadius = 4;
    [levelBtn setTitle:awardStr forState:(UIControlStateNormal)];
    levelBtn.titleLabel.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightRegular)];
    [levelBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    levelBtn.backgroundColor = [UIColor grayColor];
    [contentView addSubview:levelBtn];
    [levelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    
//    CGFloat strWidth = [awardStr contentWidthWithFont:[UIFont systemFontOfSize:11 weight:(UIFontWeightRegular)]];
    
    UILabel *awardNameLabel = [UILabel new];
    awardNameLabel.text = title;
    [contentView addSubview:awardNameLabel];
    [awardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(levelBtn.mas_right).offset(7);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    
    UILabel *countLabel = [UILabel new];
    NSString *awardNameStr = [NSString stringWithFormat:@"（%d人中奖）",10];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:awardNameStr attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:[awardNameStr rangeOfString:[NSString stringWithFormat:@"%d",10]]];
    countLabel.attributedText = attStr;
    [contentView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(awardNameLabel.mas_right);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor];
    [bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
//    [UIView clipCorerView:bgView radius:6 RectCorner:(UIRectCornerTopLeft| UIRectCornerTopRight)];
    
    return headerView;
}
@end
