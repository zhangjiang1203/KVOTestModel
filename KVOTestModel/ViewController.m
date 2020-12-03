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
//    if ([obj isKindOfClass:[Person class]]) {
//        Person *person = (Person*)obj;
//        person.age = 18;
//    }else if([obj isKindOfClass:[Dog class]]){
//        Dog *dog = (Dog*)obj;
//        dog.age = 20;
//    }
    
    NSLog(@"修改之后===%@",obj);
}

//-(void)randomString {
//    int index = arc4random_uniform(13);
//    self.findTextField.text = self.randomArr[index];
//}
//
- (void)initMyUI {
    self.showDataArr = [NSMutableArray arrayWithArray:@[@"搜索",@"差值",@"类测试",@"UItableView configuration"]];
//    NSString *timeStr = [[CorasickTreeManager shareInstance] createTrieTree];
//    [self.showDataArr addObject:timeStr];
//
//    CGFloat buttonW = (KScreenWidth - 50)/4;
//    NSArray *tepmStr = @[@"for循环",@"ac自动机",@"KMP算法"];//,@"清空自动机",@"重建自动机"];
//    for (int i = 1; i <= tepmStr.count; i++) {
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10*(i)+buttonW*(i-1), kNavBarAndStatusBarHeight+45, buttonW, 30)];
//        btn.tag = i;
//        btn.backgroundColor = [UIColor redColor];
//        btn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//        [btn setTitle:tepmStr[i-1] forState:(UIControlStateNormal)];
//        [btn addTarget:self action:@selector(actionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
//        [self.view addSubview:btn];
//    }
//
//    self.findTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, kNavBarAndStatusBarHeight, KScreenWidth-40, 40)];
//    self.findTextField.borderStyle = UITextBorderStyleRoundedRect;
//    self.findTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.findTextField.placeholder = @"输入搜索文字";
////    self.findTextField.textColor = [UIColor whiteColor];
//    [self.view addSubview:self.findTextField];
//
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, KScreenWidth, KScreenHeight-kNavBarAndStatusBarHeight) style:(UITableViewStylePlain)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.myTableView.rowHeight = 44;
    [self.view addSubview:self.myTableView];
//    self.randomArr =  @[@"17江苏太仓农村商业银行CD001哦is覅水电费sdfjsdl",
//                        @"16江苏盐城农村商业银行CD007打法胜多负少sfsdafsf",
//                        @"16江苏盐城农村商业银行CD011是否是打发舒服舒服",
//                        @"111697073.IB sfhklsf ",
//                        @"111697073.IBsadflsdkf sdaf",
//                        @"111693786.IBsfsadfdfasdfasf",
//                        @"111693871.IB塑料袋焚枯食淡飞",
//                        @"111695793.IB看手机话费可视对讲",
//                        @"111693960.IB刹帝利方式的f",
//                        @"111694225.IB飞谁知道和田玉",
//                        @"111695314.IB斯维尔无无",
//                        @"111695330.IB4565478465845",
//                        @"111696388.IB转发地址个大概多少个",
//                        @"111696455.IB所得税的任13111695314.IB何人士"];
//    UIButton *temp = [[UIButton alloc]init];
//    [temp setTitle:@"随机" forState:(UIControlStateNormal)];
//    [temp setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
//    [temp addTarget:self action:@selector(randomString) forControlEvents:(UIControlEventTouchUpInside)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:temp];
//
}
//
//
//- (void)actionButtonClick:(UIButton*)sender {
//    if (self.findTextField.text.length <= 0) {
//        return;
//    }
////    if (sender.tag == 3){
////        [[CorasickTreeManager shareInstance] clearTrieTree];
////        [self.showDataArr removeAllObjects];
////        [self.myTableView reloadData];
////        return;
////    }
//    NSString *timeStr = nil;
//    if (sender.tag == 2) {
//        timeStr = [[CorasickTreeManager shareInstance]trieFindMyTree:self.findTextField.text];
//    }else if (sender.tag == 1) {
//        timeStr = [[CorasickTreeManager shareInstance]forNormalTimeCal:self.findTextField.text];
//    }else if (sender.tag == 4){
//        timeStr = [[CorasickTreeManager shareInstance]createTrieTree];
//    }else if (sender.tag == 3){
//        timeStr = [[CorasickTreeManager shareInstance]showKMPTest:self.findTextField.text];
//    }
//    [self.showDataArr insertObject:timeStr atIndex:0];
//    [self.myTableView reloadData];
//}
//
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
    }
}





@end
