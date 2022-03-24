//
//  InterviewViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2022/3/1.
//  Copyright © 2022 zhangjiang. All rights reserved.
//

#import "InterviewViewController.h"
#import <objc/runtime.h>
#import "ZJPerson.h"
#import "UIMonitorinManager.h"

void testChar(){
    char *str = "Logic";
    char *str2 ;
    strcat(str2, str);
    
    printf("str2的值是：%s",str2);
}

void printClassInfo(id obj){
    Class cls = object_getClass(obj);
    Class superCls = class_getSuperclass(cls);
    NSLog(@"self:%s-----super:%s",class_getName(cls),class_getName(superCls));
}



@interface InterviewViewController ()

@property (nonatomic, strong) NSString *strongStr;

@property (nonatomic, copy) NSString *cusStr;

@property (nonatomic, copy) void(^showBlock)(NSString *name);

@end


@implementation InterviewViewController


@synthesize cusStr = _cusStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIMonitorinManager shareInstance] startMonitorWithKey:@"nihao"];
    
//    [self testZomObject];
    [self showTestZombie];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"开始等待");
    sleep(2);
}

- (void)showTestZombie{
    
    for (int i= 0; i<100; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            static void (^testMethod)(int);
            testMethod = ^(int value){
                if (value > 0) {
                  NSLog(@"current value = %d",value);
                  testMethod(value - 1);
                }
            };
            testMethod(10);
        });
    }
//    [self.cusStr length];
//
//    self.showBlock(@"哈哈哈");
}

- (void)testZomObject{
//    ZJPerson *person = [ZJPerson new];
//
//    printClassInfo(person);
//    [person release];
//
//    printClassInfo(person);
}

- (void)getProperty{
    int value = 1;
    int value2 = 4;
    int value3 = 30;
    
    NSLog(@"加载显示===.%2d0,%d0,.%2d",value,value2,value3);
    
    unsigned count = 0;
    Ivar *list = class_copyIvarList([self class], &count);
    for (unsigned i = 0; i < count ; i++) {
        NSString *varName = [NSString stringWithUTF8String:ivar_getName(list[i])];
        NSLog(@"变量名====%@",varName);
    }
}

- (void)testARC{
//    NSObject *object = [[NSObject alloc]init];
//    NSLog(@"reatain Count =%u",[object retainCount]);
//    [object release];
//    NSLog(@"reatain Count =%u",[object retainCount]);
    //两次输出结果 都是1
    //系统知道要回收对象的时候，其reatainCount没必要再次进行减一操作，对象已经回收，其所在的内存区域包括reatinCount都变得没有意义了，这样减少一次内存操作，加速对象的回收
    void(^testName)(NSString *name,NSString *address) = ^(NSString *name,NSString *address){
        NSLog(@"测试数据==%@，%@",name,address);
    };
    testName(@"你好",@"我来了");
}

- (void)testproperty{
    NSString *test1 = @"你好 中国";
    self.strongStr = [test1 copy];
    self.cusStr = [test1 copy];
    NSLog(@"strongStr:%@ %p,copyStr:%@ %p,origin:%p",self.strongStr,self.strongStr,self.cusStr,self.cusStr,test1);

    
    NSMutableString *changeStr = [[NSMutableString alloc]initWithString:@"哈哈哈哈 我是可变化的"];
    
    self.strongStr = [changeStr mutableCopy];
    self.cusStr = [changeStr mutableCopy];
    
    [changeStr appendString:@" 开始变化了"];
    
    NSLog(@"strongStr:%@ %p,copyStr:%@ %p,origin:%p",self.strongStr,self.strongStr,self.cusStr,self.cusStr,changeStr);

}

- (void)dealloc{
    [[UIMonitorinManager shareInstance] stopMonitorWithKey:@"hahahah"];
}
@end




