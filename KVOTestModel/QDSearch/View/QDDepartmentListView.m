//
//  QDDepartmentListView.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/14.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "QDDepartmentListView.h"
#import "QDSearchResultCell.h"

@interface QDDepartmentListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIScrollView *myScrollView;

@property (nonatomic,strong) UITableView *departTableView;

@end

@implementation QDDepartmentListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void) setUpDepartmentViewUI{
    
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.myScrollView];
    
    self.departTableView = [[UITableView alloc]initWithFrame:self.bounds style:(UITableViewStyleGrouped)];
    self.departTableView.delegate = self;
    self.departTableView.dataSource = self;
    self.departTableView.backgroundColor = QDHEXColor(0xF5F6FA, 1);
    self.departTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.departTableView registerClass:[QDSearchResultCell class]  forCellReuseIdentifier:@"QDSearchResultCell"];
    self.departTableView.rowHeight = 64;
//    self.departTableView.tableFooterView = [self tableViewFooterView];
    [self addSubview:self.departTableView];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    QDSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDSearchResultCell"];
//    NSDictionary *dict = self.searchData[indexPath.section];
//    NSArray<QDSearchResultModel*> *tempData = dict[@"data"];
//    cell.searchModel = tempData[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSDictionary *dict = self.searchData[section];
//    NSArray<QDSearchResultModel*> *tempData = dict[@"data"];
//    return tempData.count > 3 ? 3 : tempData.count;
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    
//    NSDictionary *dict = self.searchData[section];
//    NSArray<QDSearchResultModel*> *resultData = dict[@"data"];
//
//    //添加title 和 按钮
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, (kTableHeaderHeight-22)/2.0, 200, 22)];
//    titleLabel.textColor = QDHEXColor(0x78849E, 1);
//    titleLabel.font = [UIFont systemFontOfSize:14];
//    titleLabel.text = dict[@"section"];
//    [headerView addSubview:titleLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 16;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if([self.delegate respondsToSelector:@selector(didSelectedCellView:)]){
//        NSDictionary *dict = self.searchData[indexPath.section];
//        NSArray<QDSearchResultModel*> *tempData = dict[@"data"];
//        [self.delegate didSelectedCellView:tempData[indexPath.row]];
//    }
}

- (UIView *)tableViewFooterView{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24,self.frame.size.width,20)];
    titleLabel.textColor = QDHEXColor(0xC5CCDB, 1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"没有更多搜索结果";
    [headerView addSubview:titleLabel];
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}




@end
