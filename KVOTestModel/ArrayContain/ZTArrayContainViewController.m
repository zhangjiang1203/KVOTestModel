//
//  ZTArrayContainViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/10/21.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZTArrayContainViewController.h"
#import "ZJPersonModel.h"

@interface ZTArrayContainViewController ()

@end

@implementation ZTArrayContainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数组包含测试";
    [self testArrContain];
}

- (void)testArrContain{
    
    NSMutableArray *persons = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        ZJPersonModel *model = [ZJPersonModel new];
        model.userId  = [NSString stringWithFormat:@"%d0987%d",i,i+2];
        [persons addObject:model];
    }
    
    
    ZJPersonModel *model1 = [ZJPersonModel new];
    model1.userId = @"009872";
    
    BOOL result = [persons containsObject:model1];
    NSLog(@"测试数据===%d",result);

    
}

@end
