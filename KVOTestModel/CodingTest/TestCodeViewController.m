//
//  TestCodeViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/12/4.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "TestCodeViewController.h"
#import "CodePersonModel.h"
#import "CodeStudentModel.h"
#import "NSObject+Coding.h"

@interface TestCodeViewController ()

@end

@implementation TestCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CodePersonModel *model = [[CodePersonModel alloc]init];
    model.name = @"你好";
    model.address = @"上海";
    model.email = @"896884553";
    
    CodeStudentModel *student = [[CodeStudentModel alloc]init];
    student.nickName = @"再见了";
    student.stuNum = @"123456";

    NSString *path1 = [NSString stringWithFormat:@"%@/person.plist", NSHomeDirectory()];
    [NSKeyedArchiver archiveRootObject:model toFile:path1];
    
    NSString *path2 = [NSString stringWithFormat:@"%@/student.plist", NSHomeDirectory()];
    [NSKeyedArchiver archiveRootObject:model toFile:path2];
    
    CodePersonModel *person = [NSKeyedUnarchiver unarchiveObjectWithFile:path1];
    NSLog(@"person===%@",person);
    
    CodeStudentModel *student1 = [NSKeyedUnarchiver unarchiveObjectWithFile:path2];
    NSLog(@"student1===%@",student1);

    NSDictionary *dict = [student convertModelToDictionary];
    NSLog(@"过滤字典==%@==%@",dict,dict[@"name"]);
    
    NSDictionary *showDict = @{@"address":@"上海",@"email":@"896884553",@"name":@"来吧"};
//    CodePersonModel *model1 = [CodePersonModel new];
    CodePersonModel *model1 = [[CodePersonModel alloc] zj_initWithDict:showDict];
    NSLog(@"生成实例==%@==%@",model1.name,model1.address);
    
    for (int i =0; i< 20; i++) {
        [self getRandomUUID];
    }
    
}

-(void)getRandomUUID{
    NSString *result;
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0)
    {
       result = [[NSUUID UUID] UUIDString];
    }
    else
    {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        result = (__bridge_transfer NSString *)uuid;
    }
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *value = [[result componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
    if (value.length > 16) {
        value = [value substringToIndex:16];
    }
    //获取随机的长度的值
    NSLog(@"UUID=%@,value=%@,toLong=%lld,&value=%lld",result,value,value.longLongValue,value.longLongValue & LONG_MAX);
}


@end
