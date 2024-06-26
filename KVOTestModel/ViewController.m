//
//  ViewController.m
//  KVOTestModel
//
//  Created by zj on 2019/10/11.
//  Copyright © 2019 zhangjiang. All rights reserved.
//

#import "ViewController.h"
//#import <dlfcn.h>
//#import <libkern/OSAtomic.h>

//void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
//                                                    uint32_t *stop) {
//  static uint64_t N;  // Counter for the guards.
//  if (start == stop || *start) return;  // Initialize only once.
//  printf("INIT: %p %p\n", start, stop);
//  for (uint32_t *x = start; x < stop; x++)
//    *x = ++N;  // Guards should start from 1.
//}
//
//void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
//    if (!*guard) return;  // Duplicate the guard check.
//
//    void *PC = __builtin_return_address(0);
//    Dl_info info;
//    dladdr(PC, &info);
//
//    printf("fname=%s \nfbase=%p \nsname=%s\nsaddr=%p \n",info.dli_fname,info.dli_fbase,info.dli_sname,info.dli_saddr);
//
//    char PcDescr[1024];
//    printf("guard: %p %x PC %s\n", guard, *guard, PcDescr);
//}


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
        @{@"title":@"空视图设置",@"class":@"KVOTestModel.EmptyListViewController"},
        @{@"title":@"PythonScript脚本测试",@"class":@"KVOTestModel.PythonScriptViewController"},
        @{@"title":@"addView层级关系",@"class":@"ZJImageMonitorViewController"},
        @{@"title":@"设置item",@"class":@"ZJCustomChooseViewController"},
        @{@"title":@"SVGA播放",@"class":@"ZJSVGAPlayerViewController"},
        @{@"title":@"GCDTimer",@"class":@"GCDTimeViewController"},
        @{@"title":@"swiftTest",@"class":@"KVOTestModel.ZJJSONToModelTestViewController"},
        @{@"title":@"pipeline测试",@"class":@"ZJPipelineTestViewController"},
        @{@"title":@"组件化测试",@"class":@"ZJModuleTestViewController"},
        @{@"title":@"tableView高度",@"class":@"ZJTableLayoutViewController"},
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
        @{@"title":@"文本控制",@"class":@"ZJTextViewController"},
        @{@"title":@"collection测试",@"class":@"ZJShowCollectionViewController"},
        @{@"title":@"分段控制器",@"class":@"ZJSegmentViewController"},
        @{@"title":@"数组包含测试",@"class":@"ZTArrayContainViewController"},
        @{@"title":@"点击事件穿透",@"class":@"ZJTouchEventViewController"},
        @{@"title":@"YogaKit测试",@"class":@"YogaKitTestViewController"},
        @{@"title":@"layer测试",@"class":@"ShowLayerViewController"},
        @{@"title":@"Interview测试",@"class":@"InterviewViewController"},
        @{@"title":@"AR-太阳系",@"class":@"MyARKitViewController"},
        
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
