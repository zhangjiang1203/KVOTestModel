//
//  ZJCustomChooseViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2023/10/12.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import "ZJCustomChooseViewController.h"
#import "DYHBChooseItemView.h"
#import "ZJPerson.h"

#import <Masonry/Masonry.h>

typedef NS_ENUM(NSUInteger, ZJTestEnum) {
    ZJTestEnum_1 = 0,
    ZJTestEnum_2,
    ZJTestEnum_3
};

typedef NS_ENUM(NSUInteger, DYMessageProgressType) {
    DYMessageProgress_Fail      = 0 ,
    DYMessageProgress_Success   = 1 ,
    DYMessageProgress_Text      = 2 ,
};



@interface ZJCustomChooseViewController ()

@property (nonatomic, strong) DYHBChooseItemView *chooseItemView;

@property (nonatomic, strong) NSHashTable *hashTable;

@end

@implementation ZJCustomChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择列表";
    
    [self testHTMLString];
}

- (void)testHTMLString {
    
    NSString *showName = @"/User/Name/Test/hhahh.txt";
    showName = [showName lastPathComponent];
    NSLog(@"哈哈哈哈==%@",showName);
    
//    NSString *htmlStr = @"<b style=\"color:#908909; font-size:30\">你今日参与 <b style=\"color:#786756; font-size:40; font-weight: bold\">咕咕矿工</b>玩法，已达消费上限</b> ";
    
    
    NSString *htmlStr = @"<span style=\"color:#757575; font-size:30\">你今日参与</span> <span style=\"color:ff0000; font-size:40; font-weight: bold\">咕咕矿工</span> <span style=\"color:#757575; font-size:30\">玩法，已达消费上限</span>";

    NSAttributedString *attrString = nil;
    @autoreleasepool {
        NSData *htmlData = [htmlStr dataUsingEncoding:NSUnicodeStringEncoding];
        
        attrString = [[NSAttributedString alloc] initWithData:htmlData options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    }
    
    //展示内容数据
    UILabel *showLabel = [UILabel new];
    showLabel.numberOfLines = 0;
    showLabel.textColor = [UIColor blueColor];
    showLabel.attributedText = attrString;
    [self.view addSubview:showLabel];
    [showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(100);
    }];
}


- (void)testNumFormatter:(NSInteger)num{
    CGFloat value = num / 1000;
    CGFloat endData = value/ 10.0;
    
    NSString *end = [NSString stringWithFormat:@"%f",endData];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.maximumFractionDigits = 1;
    formatter.minimumFractionDigits = 0;
    formatter.decimalSeparator = @".";
    formatter.roundingMode = NSNumberFormatterRoundDown;
    
    NSNumber *ret = [formatter numberFromString:end];
    NSLog(@"处理结果===%@",ret.stringValue);
}

- (ZJPerson *)testData {
    NSMutableArray *dataArr = [NSMutableArray array];
   //构造数据
    for (int i = 0; i< 10; i++) {
        ZJPerson *person = [ZJPerson new];
        person.showName = [NSString stringWithFormat:@"数据==%d",i];
        person.sex = i % 2 == 0 ? @"男" : @"女";
        if (i == 3) {
            NSMutableArray *students = [NSMutableArray array];
            for (int j=0; j<3; j++) {
                ZJPerson *person1 = [ZJPerson new];
                person1.showName = [NSString stringWithFormat:@"测试==%d",j];
                person1.sex = j % 2 == 0 ? @"男" : @"女";
                [students addObject:person1];
            }
            person.students = students;
        }
        [dataArr addObject:person];
    }
    
    ZJPerson *testPerson;
    for (ZJPerson *person in dataArr) {
        if ([person.showName isEqualToString:@"111"]) {
            testPerson = person;
            return person;
        }else{
            if (person.students.count) {
                for (ZJPerson *stu in person.students) {
                    if ([stu.showName isEqualToString:@"测试==2"]) {
                        NSMutableArray *temData = [NSMutableArray arrayWithArray:person.students];
                        [temData removeObject:stu];
                        person.students = [temData copy];
                        break;
                    }
                }
            }

        }
        NSLog(@"执行测试===%@",person.showName);
    }
    NSLog(@"shouDataArr==%@",dataArr);
    return nil;
}


- (void)setUpChooseItemView {
    for (int i = 0; i < 12; i++) {
        NSLog(@"展示数据===================i:%d",i);
        for (int j = 0; j < 10; j++) {
            if (j == 5) {
                NSLog(@"当前数值===%d",j);
                break;
            }else{
                NSLog(@"当前数值===%d",j);
            }
        }
    }
    
    
    self.chooseItemView = [[DYHBChooseItemView alloc] init];
    [self.view addSubview:self.chooseItemView];
    
    [self.chooseItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.hashTable addObject:self.chooseItemView];
    [self.hashTable addObject:self.chooseItemView];
    
//    NSMutableArray *optionsArr = [NSMutableArray arrayWithArray:nil];
//    NSLog(@"当前的数组===%@",optionsArr);
    NSNumber *test1 = @5;
    NSNumber *test2 = @5;
//    if (test1 == test2) {
//        NSLog(@"数值一致");
//    }
    
    NSArray<NSDictionary<NSNumber *,NSNumber *> *> *testArr = @[@{@5:@8}];
    [testArr enumerateObjectsUsingBlock:^(NSDictionary<NSNumber *,NSNumber *> *obj, NSUInteger idx, BOOL *stop) {
        NSNumber *groupId = obj.allKeys.firstObject;
        if (groupId == test2) {
            NSLog(@"字典中包含的数值一致====");
        }
    }];
}

@end
