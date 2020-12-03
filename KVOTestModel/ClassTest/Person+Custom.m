//
//  Person+Custom.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/4/8.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "Person+Custom.h"


@implementation Person (Custom)

+ (void)personName:(NSString *)name {
    NSLog(@"接收到的name===%@",name);
}

-(void)testCategoryMethord {
    NSLog(@"开始测试");
}

@end

@implementation Person (At)

- (void)setMyAddress:(NSString *)address{
    [self testCategoryMethord];
}

@end
