//
//  QDBaseSearchViewController.m
//  
//
//  Created by zhangjiang on 2020/7/9.
//

#import "QDBaseSearchViewController.h"
#import "QDUISearchBar.h"
#import "QDUISearchResultView.h"
#import "UIButton+ChangeImagePosition.h"
#import "QDSearchMoreViewController.h"

@interface QDBaseSearchViewController ()<QDUISearchBarDelegate,QDUISearchResultViewDelegate>

@property (nonatomic,strong) QDUISearchBar *searchBar;

@property (nonatomic,strong) QDUISearchResultView *searchResultView;

@end

@implementation QDBaseSearchViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.searchModel == nil){
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.searchModel == nil){
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMyUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar textFieldBecomeFirstResponder];
}

-(void)setUpMyUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    if(self.searchModel){
        //搜索所有符合要求的数据
        self.searchBar = [[QDUISearchBar alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-50, 36) preSearch:self.searchModel.searchText];
        self.searchBar.delegate = self;
        self.navigationItem.titleView = self.searchBar;
    }else{
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = self.view.frame;
        [self.view addSubview:effectview];
        self.searchBar = [[QDUISearchBar alloc]initWithFrame:CGRectMake(16, kTopBarSafeHeight, KScreenWidth-32, 36)];
        self.searchBar.delegate = self;
        [self.view addSubview:self.searchBar];
    }
    
    if (@available(iOS 13.0, *)) {
        [[UIScrollView appearance]setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)cancelSearchAction{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)textFieldTextDidChanged:(NSString *)text{
    if (text.length) {
        if(![self.view.subviews containsObject:self.searchResultView]){
            [self.view addSubview:_searchResultView];
        }
//        //开始搜索
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.searchResultView.searchData = [self.searchResultView showTestData];
        });
        
    }else{
        [self.searchResultView removeFromSuperview];
    }
}

- (QDUISearchResultView *)searchResultView{
    if (_searchResultView == nil) {
        _searchResultView = [[QDUISearchResultView alloc]initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, KScreenWidth, KScreenHeight-kNavBarAndStatusBarHeight)];
        _searchResultView.delegate = self;
    }
    return _searchResultView;
}

#pragma mark - QDUISearchResultViewDelegate

- (void)lookMoreResultAction:(QDSearchResultModel *)searchModel{
    QDBaseSearchViewController *moreVC = [[QDBaseSearchViewController alloc]init];
    moreVC.searchModel = searchModel;
    [self.navigationController pushViewController:moreVC animated:true];
    
}

- (void)didSelectedCellView:(QDSearchResultModel *)orignalModel{
//    if (orignalModel.resultType == SearchResultType_Department) {
    NSLog(@"开始执行=====");
        QDSearchMoreViewController *moreVC = [[QDSearchMoreViewController alloc]init];
        [self presentViewController:moreVC animated:YES completion:nil];
//    }
}


@end
