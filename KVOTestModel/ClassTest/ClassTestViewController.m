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

@end

@implementation ClassTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *person = [Person alloc];
    person.age = 18;
    person.name = @"张三";
    
    NSLog(@"当前的数据=%zd==%@",person.age,person.name);
    [self testPerson:person success:^(NSString *value) {
       //当前的名字
        NSLog(@"block back ===%@",value);
    }];
}

- (void)testPerson:(Person*)person success:(void(^)(NSString *value))successBlock{
    successBlock(person.name);
}



@end
