//
//  RACTestViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/7.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "RACTestViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "Person.h"
@interface RACTestViewController ()

@property (nonatomic,strong) RACCommand *command;

@property (nonatomic,strong) NSMutableArray<NSString *> *nameArr;

@end

@implementation RACTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC练习";
    self.nameArr = [NSMutableArray array];
    [self testStringContain];
}

-(void)testStringContain {
    NSString *first = @"zhangjiang";
    NSString *second = @"zhangjiang";
    NSString *third = @"zhang";
    
    if ([first containsString:second]) {
        NSLog(@"first contains second");
    }
    
    if([first containsString:third]){
        NSLog(@"first contains third");
    }
}


- (void)testMapArr {
    NSMutableArray *tempArr1 = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        Person *p = [Person new];
        p.name = [NSString stringWithFormat:@"哈哈--%d",i];
        p.age = i;
        [tempArr1 addObject:p];
    }
    
    NSArray *showArr = [[tempArr1.rac_sequence map:^id _Nullable(Person *_Nullable value) {
        return [NSString stringWithFormat:@"%ld",(long)value.age];
    }] array];
    
    NSArray *subTemArr2 = [tempArr1 subarrayWithRange:NSMakeRange(2, 4)];
    NSArray *showArr1 = [[subTemArr2.rac_sequence map:^id _Nullable(Person *_Nullable value) {
        return [NSString stringWithFormat:@"%ld",(long)value.age];
    }] array];
    
//    NSLog(@"当前的arr===%@",showArr);
    [showArr enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![showArr1 containsObject:obj]) {
            NSLog(@"当前不包含你===%@",obj);
        }
    }];
    
}


- (void)testObserver {
    [[RACObserve(self, nameArr) skip:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"开始变化===%@",x);
    }];
    
//    [[self mutableArrayValueForKey:@"nameArr"] addObject:@"098"];
//    [[self mutableArrayValueForKey:@"nameArr"] addObject:@"654"];
    
    self.nameArr = [NSMutableArray arrayWithArray:@[@"123",@"456",@"345",@"678"]];
    
//    [self.nameArr addObject:@"123"];
//    [self.nameArr addObject:@"345"];
}

- (void)signalTest {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"你好"];
        //执行完毕
        [subscriber sendCompleted];
        return  [RACDisposable disposableWithBlock:^{
            NSLog(@"执行完毕，信号销毁");
        }];
    }];
    
    [signal1 subscribeNext:^(NSString *_Nullable x) {
        NSLog(@"接收信号===%@",x);
    }];
    
    //只会发送订阅后的信号，之前的信号不做处理
    RACSubject<NSString *> *subject = [RACSubject subject];
    [subject sendNext:@"1"];
    [subject subscribeNext:^(NSString *_Nullable x) {
        NSLog(@"开始接收信号===%@",x);
    }];
    
    [subject sendNext:@"哈哈哈"];
    [subject sendCompleted];
    
    //保存订阅信号之前的所有值 发送给订阅者
    RACReplaySubject<NSString *> *reply = [RACReplaySubject subject];
    [reply sendNext:@"2"];
    [reply sendNext:@"3"];
    [reply sendNext:@"4"];
    [reply subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"reply==%@",x);
    }];
    [reply sendNext:@"5"];
    
    // 会保留订阅信息之前的最后一个值
    RACBehaviorSubject *behavior = [RACBehaviorSubject subject];
    [behavior sendNext:@"6"];
    [behavior sendNext:@"7"];
    [behavior sendNext:@"8"];
    [behavior subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"reply==%@",x);
    }];
    [behavior sendNext:@"9"];
    
}

- (void)setSequence{
    NSArray<NSNumber *> *numbers = @[@2,@3,@9,@90,@76];
    [numbers.rac_sequence.signal subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"遍历取值== %d",x.intValue);
    }];
    
    NSDictionary<NSString *,NSString *> *dict = @{@"url":@"http://www.baidu.com",@"type":@"1",@"name":@"baidu"};
    [dict.rac_sequence.signal subscribeNext:^(RACTwoTuple<NSString *,NSString *> * _Nullable x) {
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"字典==key:%@==value:%@",key,value);
    }];
}

- (void)commandTest{
    self.command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //开始执行网络下载任务
        NSLog(@"execution input==%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"开始请求数据"];
            //3.RACCommand中信号如果数据传递完，必须调⽤用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
            // 再次调用 execute:id] 方法也不会执行
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"信号执行完毕");
            }];
        }];
    }];
    [self.command.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"command execution == %@",x);
        }];
    }];
    
    [self.command execute:@1];
    [self.command execute:@2];
    [self.command execute:@3];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.command execute:@"哈哈哈哈   我就是参数"];
    });
    //监听命令是否执行完毕
    [[self.command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            NSLog(@"正在执行");
        }else{
            NSLog(@"执行完毕");
        }
    }];
}

- (void)racDefineTest {
    //1.绑定某个对象的某个属性
    //只要文本框发生改变，就会修改label的文字
    //RAC(self.view,text) = _textFiled.rac_textSignal;
    
    //2. 监听某个对象的某个属性，返回值是信号,center 改变就会触发下面的方法
    [RACObserve(self.view, center) subscribeNext:^(id  _Nullable x) {
        NSLog(@"center %@",x);
    }];
    
    //3.两个配套使用，解决循环引用的问题
    //@weakify(self);  @strongify(self);
    
    
    // RACTuplePack 把数据包装成RACTuple(元组)
//    RACTuple *tuple = RACTuplePack(@"123",@"456");
    
    // 解包元组,把元组的值 按着顺序给参数里面的变量赋值
//    RACTupleUnpack(NSString *name,NSString *age) = tuple;
}

- (void)racAction{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"signalA = 1"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"signalB = 2"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // signalB拼接到signalA后面，signalA发送完成 signalB才会被激活
    // 依次接收signalA和signalB 发送的信号
    RACSignal *concatSignal = [signalA concat:signalB];
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"触发的信号==%@",x);
    }];
    
    
    // then 用于连接两个信号，当第一个信号完成 才会连接then返回的信号
    // 使用then之前的信号会被过滤掉
    RACSignal *signalC = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"signalC = 3"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalD = [signalC then:^RACSignal * _Nonnull{
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"then signal"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [signalD subscribeNext:^(id  _Nullable x) {
        NSLog(@"then ===%@",x);
    }];
    
    
    //merge 将多个信号合并为一个信号，任何一个信号有新值的时候就会调用
    RACSignal *mergeS = [signalA merge:signalB];
    [mergeS subscribeNext:^(id  _Nullable x) {
        NSLog(@"merge ===%@",x);
    }];
    
    // zipWith 两个信号压缩为一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并为一个元组，才会触发压缩流的next事件
    RACSignal *zipSignal = [signalA zipWith:signalB];
    [zipSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"zip result == %@",x);
    }];
    
    // combinelatestWith 将多个信号合并起来，并且拿到各个信号的最新的值，必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号
    RACSignal *combineSignal = [signalA combineLatestWith:signalB];
    [combineSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"combineSignal result = %@",x);
    }];
    
    RACSignal *signalCom = [RACSignal combineLatest:@[signalA,signalB] reduce:^id (NSString *value1,NSString *value2){
        return [value1 stringByAppendingString:value2];
    }];
    [signalCom subscribeNext:^(id  _Nullable x) {
        NSLog(@"combine reduce ==%@",x);
    }];
    
    /*
     filter 过滤信号，获得满足条件的信号
     [_textField.rac_textSignal filter:^BOOL(NSString
     *value) {
             return value.length > 3;
    }];
     
     ignore 忽略完 某些值的信号
     [[_textField.rac_textSignal ignore:@"1"]
     subscribeNext:^(id x) {
     
         NSLog(@"%@",x);
    }];
     
     distinctUntilChanged 当上一次的值和当前的值有明显的变化就会发出信号，否则就会忽略掉
     [[_textField.rac_textSignal distinctUntilChanged]
     subscribeNext:^(id x) {
     
         NSLog(@"%@",x);
    }];
     
     take 从开始一共去N次信号
     RACSubject *signal = [RACSubject subject];
     [[signal take:1] subscribeNext:^(id x) {
         NSLog(@"%@",x);
      }];
     1 不会输出
    [signal sendNext:@1];
    [signal sendNext:@2];
     
     takeLast：取最后N次的信号，前提条件是订阅者必须调用完成，因为只有完成 才知道一共有多少信号
     
     
     takeUntil:获取信号直到执行完整个信号
     监听文本框的改变，直到当前的对象被释放
     [_textField.rac_textSignal takeUntil:self.rac_willDeallocSignal];
     
     skip: 跳过几个信号，不接受
     
     switchToLatest: 用于signalOfSignals(信号的信号)，这里获取最新的信号
     
     
     doNext: 执行next操作，会先执行整个操作
     doCompleted: 执行sendCompleted之前，先执行整个操作
     
     
     deliverOn：内容传递切换到指定的线程中，副作用在原来的线程中,把创建信号时的block中的代码称之为副作用
     subscribeOn: 内容传递和副作用都会切换到指定的线程中
     
     timeout: 每一个signal都可以设置一个超时时间，超时后报错
     interval: 定时 每隔一段时间发出一个signal
     [[RACSignal interval:1 onScheduler:[RACScheduler
     currentScheduler]] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
     
     
     delay 延迟发送next
     
     
     retry 重试 只要失败，就会重新执⾏行行创建信号中的block,直到成功.
     replay重放:当⼀个信号被多次订阅,反复播放内容
     throttle: 节流，当某个信号发送频繁的时候在一定时间内对signal做节流，在设置的时间内不接受任何信号
     
     
     */
}


@end
