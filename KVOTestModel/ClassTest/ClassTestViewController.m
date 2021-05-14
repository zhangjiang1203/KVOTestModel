//
//  ClassTestViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/10/9.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "ClassTestViewController.h"
#import "Person.h"
#import "Person+Custom.h"

typedef void(^HttpResult)(NSString *value);

@interface ClassTestViewController ()

@property (nonatomic,copy) NSArray *testCopyArr;
@property (nonatomic,strong) NSArray *strongArr;


@property (nonatomic,copy) NSMutableArray *testCopyMutableArr;
@property (nonatomic,strong) NSMutableArray *strongMutableArr;

@end

@implementation ClassTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *person1 = [Person alloc];
    person1.age = 18;
    person1.name = @"张三";
    
    Person *person2 = [Person alloc];
    person2.age = 18;
    person2.name = @"张三";
    
    Person *person3 = [Person alloc];
    person3.age = 18;
    person3.name = @"张三";
    
    Person *person4 = [Person alloc];
    person4.age = 18;
    person4.name = @"张三";
    
    self.testCopyArr = @[person1,person2,person3,person4];
    self.strongArr = @[person1,person2,person3,person4];
    
//    NSArray *test1 = [self.testCopyArr copy];
//    NSArray *test2 = [self.strongArr copy];
    
//    NSArray *test3 = [self.testCopyArr mutableCopy];
//    NSArray *test4 = [self.strongArr mutableCopy];
    
//    NSLog(@"当前数据==%@==%@",test1,test2);
    
    //1.用copy修饰生成的是一个不可变的数组，调用可变数组的一些方法会直接奔溃，
    self.testCopyMutableArr = [NSMutableArray arrayWithArray:@[@"23",@"456",@"456"]];
//    [self.testCopyMutableArr addObject:@"3444"];
    
    
    
    //2.用strong修饰的为可变数组，赋值给一个不可变数组(也用strong修饰)，两个变量都指向同一个内存地址，不可变数组变为可变数组
    self.strongMutableArr = [NSMutableArray arrayWithArray:@[@"23",@"456",@"456"]];
    self.strongArr = self.strongMutableArr;
    /// 此时修改可变数组中的值，不可变数组中的数据也跟着发生变化
    [self.strongMutableArr addObject:@"888"];
    
    //3.copy修饰不可变数组 strong修饰可变数组， 可变数组数据发生变化，不可变数组没有影响 相当于复制了一份
    self.testCopyArr = self.strongMutableArr;
    
    [self.strongMutableArr addObject:@"9999"];
    
//    NSMutableArray *array1 = [self.testCopyMutableArr copy];
//    NSMutableArray *array2 = [self.testCopyMutableArr mutableCopy];
    
    
    
    NSLog(@"当前的数据=%zd==%@",person1.age,person1.name);
    [self testPerson:person1 success:^(NSString *value) {
       //当前的名字
        NSLog(@"block back ===%@",value);
    }];
}

- (void)testPerson:(Person*)person success:(void(^)(NSString *value))successBlock{
    successBlock(person.name);
}



@end
