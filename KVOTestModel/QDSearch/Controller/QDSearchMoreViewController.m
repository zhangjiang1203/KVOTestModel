//
//  QDSearchMoreViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/13.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "QDSearchMoreViewController.h"
#import "QDSearchResultCell.h"
#import "UIButton+ChangeImagePosition.h"

@interface QDSearchMoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIScrollView *myScrollView;

@property (nonatomic,strong) UITableView *departTableView;

@property (nonatomic,strong) UILabel *departNameLabel;

@property (nonatomic,strong) NSMutableArray *searchData;

@end

@implementation QDSearchMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDepartmentViewUI];
}

- (void) setUpDepartmentViewUI{
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat viewOffY = 0;
    if (@available(iOS 13.0, *)) {
        
    } else {
        viewOffY = kNavBarAndStatusBarHeight-56;
    }
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, viewOffY, KScreenWidth, 56)];
    
    self.departNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 16, KScreenWidth-120, 24)];
    self.departNameLabel.textColor = QDHEXColor(0x262D3D, 1);
    self.departNameLabel.text = @"部门";
    self.departNameLabel.textAlignment = NSTextAlignmentCenter;
    self.departNameLabel.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightBold)];
    [topView addSubview:self.departNameLabel];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-50, 13, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"search_department_close"] forState:(UIControlStateNormal)];
    [closeBtn addTarget:self action:@selector(closeDepartmentView) forControlEvents:(UIControlEventTouchUpInside)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:closeBtn];
    [topView addSubview:closeBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 55.5, KScreenWidth, 0.5)];
    lineView.backgroundColor = QDHEXColor(0xE1E6F0, 1);
    [topView addSubview:lineView];
    
    [self.view addSubview:topView];
    
//    UIButton *backToUpperBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [backToUpperBtn setImage:[UIImage imageNamed:@"search_department_close"] forState:(UIControlStateNormal)];
//    [backToUpperBtn addTarget:self action:@selector(closeDepartmentView) forControlEvents:(UIControlEventTouchUpInside)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backToUpperBtn];
    
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)+12, KScreenWidth, 40)];
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    NSArray *titleArr = @[@"部门yier三",@"产品研发部",@"内容展示部门",@"累计效果展示",@"设计部一组"];
    CGFloat totalW = 12;
    for (int i = 0; i < titleArr.count; i++) {
        NSString *titleStr = titleArr[i];
        CGFloat titleW = [titleStr boundingRectWithSize:CGSizeMake(200, 30) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width+10;
        UIButton *dartNameBtn = [[UIButton alloc]initWithFrame:CGRectMake(totalW, 0, titleW, 30)];
        dartNameBtn.tag = i + 10;
        dartNameBtn.selected = i == (titleArr.count - 1);
        [dartNameBtn setTitle:titleStr forState:(UIControlStateNormal)];
        dartNameBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        if(i != titleArr.count -1){
            [dartNameBtn setImage:[UIImage imageNamed:@"search_department_right"] forState:(UIControlStateNormal)];
        }
        [dartNameBtn setTitleColor:QDHEXColor(0x4A70FF, 1) forState:(UIControlStateNormal)];
        [dartNameBtn setTitleColor:QDHEXColor(0xA1ABC2, 1) forState:(UIControlStateSelected)];
        [dartNameBtn setButtonStyle:(QDImageTitleButtonStyle_TitleLeftImageRight) padding:5];
        [self.myScrollView addSubview:dartNameBtn];
        totalW += titleW+5;
    }
    self.myScrollView.contentSize = CGSizeMake(totalW+12, 0);
    [self.view addSubview:self.myScrollView];
    
    self.searchData = [NSMutableArray array];
   for (int i = 0; i < 8;i++){
           QDSearchResultModel *model = [QDSearchResultModel new];
           model.title = [NSString stringWithFormat:@"你好==%d",i];
           model.subTitle = i%2 == 0 ? [NSString stringWithFormat:@"你好subtitle==%d",i] : @"";
           model.avatarURL = i%2 == 0 ? @"header1" : @"header2";
           model.searchText = i%2 == 0 ? @"你" : @"好";
           model.resultType = 1<<7;
           
       [self.searchData addObject:model];
   }
    
    self.departTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myScrollView.frame), KScreenWidth, self.view.frame.size.height-CGRectGetMaxY(self.myScrollView.frame)) style:(UITableViewStylePlain)];
    self.departTableView.delegate = self;
    self.departTableView.dataSource = self;
    self.departTableView.backgroundColor = QDHEXColor(0xF5F6FA, 1);
    self.departTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.departTableView registerClass:[QDSearchResultCell class]  forCellReuseIdentifier:@"QDSearchResultCell"];
    self.departTableView.rowHeight = 64;
    self.departTableView.tableFooterView = [self tableViewFooterView];
    [self.view addSubview:self.departTableView];
    
}

- (void)closeDepartmentView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    QDSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDSearchResultCell"];
    cell.searchModel = self.searchData[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchData.count;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
//    headerView.backgroundColor = [UIColor whiteColor];
//
////    NSDictionary *dict = self.searchData[section];
////    NSArray<QDSearchResultModel*> *resultData = dict[@"data"];
////
//    //添加title 和 按钮
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 9, 200, 22)];
//    titleLabel.textColor = QDHEXColor(0x78849E, 1);
//    titleLabel.font = [UIFont systemFontOfSize:14];
//    titleLabel.text = @"部门";//dict[@"section"];
//    [headerView addSubview:titleLabel];
//    return headerView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if([self.delegate respondsToSelector:@selector(didSelectedCellView:)]){
//        NSDictionary *dict = self.searchData[indexPath.section];
//        NSArray<QDSearchResultModel*> *tempData = dict[@"data"];
//        [self.delegate didSelectedCellView:tempData[indexPath.row]];
//    }
}

- (UIView *)tableViewFooterView{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20,KScreenWidth,20)];
    titleLabel.textColor = QDHEXColor(0xC5CCDB, 1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"没有更多搜索结果";
    [headerView addSubview:titleLabel];
    return headerView;
}



@end
