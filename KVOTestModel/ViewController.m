//
//  ViewController.m
//  KVOTestModel
//
//  Created by zj on 2019/10/11.
//  Copyright © 2019 zhangjiang. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "QDBaseSearchViewController.h"
#import "ZJPopView.h"
#import "ClassTestViewController.h"
#import "ConfigurationViewController.h"
#import "TestCodeViewController.h"
#import "TestBlockViewController.h"
#import "DownloadViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic,strong) UIButton *acButton;
@property (nonatomic,strong) UIButton *forButton;
@property (nonatomic,strong) UIButton *clearButton;
@property (nonatomic,strong) UITextField *findTextField;

@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray<NSString *> *showDataArr;

@property (nonatomic,strong) NSArray<NSString *> *randomArr;

@property (nonatomic,strong) UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试";
    self.view.backgroundColor = [UIColor whiteColor];
//    [ZJPopView managerRun];
    [self initMyUI];
//    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 120, 300, 80)];
//    self.textView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.textView];
//    self.textView.delegate = self;
    
//    [self.textView addta]
    
    //2.监听textView文字改变的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
//
//
//    //监听粘贴事件
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postedTextToAioTextView:) name:UIMenuControllerDidHideMenuNotification object:nil];
////    UIMenuControllerDidShowMenuNotification
////    [self initMyUI];
    
//    [[UIApplication sharedApplication].keyWindow addSubview:[QDFirstLeaderView new]];
    
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"show123123.plist"];
//    NSArray *testArr = @[@"234234",@"4",@"9",@"0",@"100"];
    
//    BOOL isSuccess = [testArr writeToFile:path atomically:YES];
//    NSLog(@"保存状态===%d",isSuccess);
    NSArray *tempArr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *emo = [NSMutableArray array];
    [emo addObjectsFromArray:tempArr];
    NSLog(@"读取的数据的值===%@",emo);
    
    //二次修改值
//    NSMutableArray *testArr1 = @[@"234234",@"4",@"9",@"0",@"100",@"2345"];
//    BOOL isSuccess1 = [testArr1 writeToFile:path atomically:YES];
//    NSArray *tempArr1 = [NSMutableArray arrayWithContentsOfFile:path];
//    NSLog(@"读取的数据的值1===%@",tempArr1);
//
//    [testArr1 removeObject:<#(nonnull id)#>]
    
}

- (void)postedTextToAioTextView:(NSNotification *)noti {
    NSLog(@"开始粘贴===%@",self.textView.text);
}

- (void)textDidChange:(NSNotification *)noti{
    NSLog(@"开始变化===%@",noti.object);
}

- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"开始变化===%@",textView.text);
}


- (void)testQQLockDict{
    
//    QQLockDictionary *lockDict = [QQLockDictionary dictionaryWithMutableDictionary:[NSMutableDictionary dictionaryWithDictionary:@{@"key":@"123",@"key1":@"345",@"key2":@"456",@"key3":@"678"}]];
//    QQLockDictionary *lock1 =  [lockDict copy];
//    QQLockDictionary *lock2 = [lockDict mutableCopy];
    
//    NSLog(@"原始==%p,copy=%p,mutableCopy=%p",lockDict,lock1,lock2);
//    NSLog(@"dict原始==%p,copy=%p,mutableCopy=%p",lockDict->_dict,lock1->_dict,lock2->_dict);
    
}

-(void)testMyName:(NSObject *)obj {
    NSLog(@"修改之前===%@",obj);
    
    NSLog(@"修改之后===%@",obj);
}


- (void)initMyUI {
    self.showDataArr = [NSMutableArray arrayWithArray:@[@"搜索",@"差值",@"类测试",@"UItableView configuration",@"归档解档",@"Block测试",@"下载管理器"]];
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
    cell.textLabel.text = self.showDataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showDataArr.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        QDBaseSearchViewController *baseVC = [[QDBaseSearchViewController alloc]init];
//        [self.navigationController pushViewController:baseVC animated:NO];
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController pushViewController:baseVC animated:NO];
    }else if (indexPath.row == 2){
        ClassTestViewController *baseVC = [[ClassTestViewController alloc]init];
        //        [self.navigationController pushViewController:baseVC animated:NO];
        //        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController pushViewController:baseVC animated:NO];
    }else if (indexPath.row == 3){
        ConfigurationViewController *config = [[ConfigurationViewController alloc]init];
        [self.navigationController pushViewController:config animated:true];
    }else if (indexPath.row == 4){
        TestCodeViewController *vc = [[TestCodeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:true];
    }else if (indexPath.row == 5){
        TestBlockViewController *vc = [[TestBlockViewController alloc]init];
        [self.navigationController pushViewController:vc animated:true];
    }else if (indexPath.row == 6){
        
        DownloadViewController *vc = [[DownloadViewController alloc]init];
        [self.navigationController pushViewController:vc animated:true];
    }
}

@end
