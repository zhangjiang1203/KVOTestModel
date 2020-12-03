//
//  QDUISearchResultView.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/10.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "QDUISearchResultView.h"
#import "QDSearchResultCell.h"
#import "QDUISearchEmptyView.h"
#import "UIButton+ChangeImagePosition.h"
#import "QDSearchMoreViewController.h"
#import "QDTableFooterView.h"

#define kTableHeaderHeight 40
#define KTableFooterHeight 10

@interface QDUISearchResultView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) QDUISearchEmptyView *emptyView;

@property (nonatomic,strong) QDSearchResultModel *searchModel;

@property (nonatomic,strong) QDTableFooterView *activityFooterView;

@end

@implementation QDUISearchResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpMyUI];
    }
    return self;
}

- (QDUISearchEmptyView *)emptyView{
    if (_emptyView == nil) {
        _emptyView = [[QDUISearchEmptyView alloc]initWithFrame:self.myTableView.bounds];
    }
    return _emptyView;
}

- (QDTableFooterView *)activityFooterView{
    if (_activityFooterView == nil) {
        _activityFooterView = [[QDTableFooterView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        _activityFooterView.tipsContent = @"加载中……";
        
    }
    return _activityFooterView;
}

-(void)setUpMyUI{
    self.searchData = [NSMutableArray array];
    self.myTableView = [[UITableView alloc]initWithFrame:self.bounds style:(UITableViewStyleGrouped)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = QDHEXColor(0xF5F6FA, 1);
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerClass:[QDSearchResultCell class]  forCellReuseIdentifier:@"QDSearchResultCell"];
    self.myTableView.rowHeight = 64;
    self.myTableView.tableFooterView = self.activityFooterView;//[self tableViewFooterView];
    [self.activityFooterView startLoad];
    [self addSubview:self.myTableView];
}

-(NSMutableArray *)showTestData{
    self.searchData = [NSMutableArray array];
    NSArray *titleArr = @[@"qq好友",@"外部联系人",@"客户",@"同事",@"群聊",@"部门",@"聊天记录",@"功能"];
    for (int i = 0; i < 8;i++){
        int count = arc4random_uniform(2) + 3;
        NSMutableArray *showData = [NSMutableArray array];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for(int j = 0; j < count; j++){
            QDSearchResultModel *model = [QDSearchResultModel new];
            model.title = [NSString stringWithFormat:@"你好==%d",j];
            model.subTitle = j%2 == 0 ? [NSString stringWithFormat:@"你好subtitle==%d",j] : @"";
            model.avatarURL = j%2 == 0 ? @"header1" : @"header2";
            model.searchText = j%2 == 0 ? @"你" : @"好";
            model.resultType = 1<<i;
            [showData addObject:model];
        }
        dict[@"section"] = titleArr[i];
        dict[@"data"] = showData;
        dict[@"type"] = @(1<<i);
        [self.searchData addObject:dict];
    }
    return self.searchData;
}

-(void)setSearchData:(NSMutableArray<NSDictionary *> *)searchData{
    _searchData = searchData;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.searchData.count <= 0) {
            [self.myTableView addSubview:self.emptyView];
        }else{
            [self.emptyView removeFromSuperview];
        }
        [self.myTableView reloadData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.searchData.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    QDSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDSearchResultCell"];
    NSDictionary *dict = self.searchData[indexPath.section];
    NSArray<QDSearchResultModel*> *tempData = dict[@"data"];
    cell.searchModel = tempData[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = self.searchData[section];
    NSArray<QDSearchResultModel*> *tempData = dict[@"data"];
    return tempData.count > 3 ? 3 : tempData.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kTableHeaderHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dict = self.searchData[section];
    NSArray<QDSearchResultModel*> *resultData = dict[@"data"];
    
    //添加title 和 按钮
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, (kTableHeaderHeight-22)/2.0, 200, 22)];
    titleLabel.textColor = QDHEXColor(0x78849E, 1);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = dict[@"section"];
    [headerView addSubview:titleLabel];
    
    //只有群组的时候不展示
    if(resultData.count > 3 && self.searchData.count > 1){
        //获取搜索内容
        self.searchModel = resultData.firstObject;
        UIButton *lookMoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 52, (kTableHeaderHeight-22)/2.0, 40, 22)];
        lookMoreBtn.tag = [dict[@"type"] intValue];
        [lookMoreBtn setImage:[UIImage imageNamed:@"search_department_right"] forState:(UIControlStateNormal)];
        [lookMoreBtn setTitle:@"更多" forState:(UIControlStateNormal)];
        [lookMoreBtn setTitleColor:RGBA(161,171,194,1) forState:(UIControlStateNormal)];
        lookMoreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [lookMoreBtn addTarget:self action:@selector(lookMoreInfoData:) forControlEvents:(UIControlEventTouchUpInside)];
        [lookMoreBtn setButtonStyle:(QDImageTitleButtonStyle_TitleLeftImageRight) padding:0];
        [headerView addSubview:lookMoreBtn];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kTableHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 16;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.delegate respondsToSelector:@selector(didSelectedCellView:)]){
//        NSDictionary *dict = self.searchData[indexPath.section];
//        NSArray<QDSearchResultModel*> *tempData = dict[@"data"];
        [self.delegate didSelectedCellView:[QDSearchResultModel new]];//tempData[indexPath.row]];
    }
    
//    QDSearchMoreViewController *moreVC = [[QDSearchMoreViewController alloc]init];
//    [[self getCurrentViewController] presentViewController:moreVC animated:YES completion:nil];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)lookMoreInfoData:(UIButton*)sender {
    
    if ([self.delegate respondsToSelector:@selector(lookMoreResultAction:)] && self.searchModel) {
        [self.delegate lookMoreResultAction:self.searchModel];
    }
}


//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentViewController
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWindow in windows) {
            if (tmpWindow.windowLevel == UIWindowLevelNormal ) {
                window = tmpWindow;
            }
        }
    }
    UIViewController *rootViewController = window.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    while ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    }
    else {
        // 根视图为非导航类
        if ([rootVC childViewControllers].count)
        {
            UIViewController *tmpVC = [[rootVC childViewControllers] lastObject];
            currentVC = [self getCurrentVCFrom:tmpVC];
        }
        else
        {
            currentVC = rootVC;

        }
    }
    
    return currentVC;
}
@end
