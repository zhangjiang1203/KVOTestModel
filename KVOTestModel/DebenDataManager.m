//
//  DebenDataManager.m
//  KVOTestModel
//
//  Created by zhangjiang on 2019/12/4.
//  Copyright © 2019 zhangjiang. All rights reserved.
//

#import "DebenDataManager.h"
#import <FMDB/FMDB.h>
@implementation DebenDataModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"id=%@--title=%@--value=%@", self.deID,self.title,self.rectValue];
}

@end


@interface DebenDataManager ()

@property (nonatomic, strong) FMDatabase *qdDataBase;

@end

@implementation DebenDataManager

+ (instancetype)shareInstance {
    
    return [[self alloc]init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.qdDataBase = [FMDatabase databaseWithPath:[DebenDataManager getDBPath]];
        [self.qdDataBase open];
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static DebenDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL]init];
    });
    return manager;
}

// 获取数据库路径
+ (NSString*) getDBPath {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"qt_data" ofType:@"db"];
    return path;
}

+ (NSArray<DebenDataModel *> *)getAllDebenItems {
    if ([DebenDataManager shareInstance].qdDataBase == nil){
        assert("数据库为空");
    }
    BOOL isOpen = [[DebenDataManager shareInstance].qdDataBase open];
    NSAssert(isOpen != false, @"数据库打开失败");
    FMResultSet *result = [[DebenDataManager shareInstance].qdDataBase executeQuery:@"SELECT * FROM qt_data WHERE title ORDER BY LENGTH(title)DESC , LENGTH(id) DESC;"];
    NSMutableArray *tempArr = [NSMutableArray array];
    while ([result next]) {
        DebenDataModel *model = [[DebenDataModel alloc]init];
        model.deID = [result stringForColumn:@"id"];
        model.title = [result stringForColumn:@"title"];
        [tempArr addObject:model];
    }
    [[DebenDataManager shareInstance].qdDataBase close];
    return tempArr;
}

-(NSArray *)debenItemsArr{
    if (!_debenItemsArr) {
        _debenItemsArr = [DebenDataManager getAllDebenItems];
    }
    return _debenItemsArr;
}

/// 获取父串中的所有子串，返回对应的range
+ (NSMutableArray<NSValue *> *)getAllSubStringRangeFromString:(NSString*)string withSubString:(NSString*)subString {
//    NSInteger subLength = subString.length;
    NSMutableArray *locationArr = [NSMutableArray array];
    NSRange range = [string rangeOfString:subString];
    if (range.location == NSNotFound) {
        return locationArr;
    }
    //添加第一次匹配结果
    [locationArr addObject:[NSValue valueWithRange:range]];
    NSString *tempStr = string;
    while (range.location != NSNotFound) {
        //删除匹配到的字符串
//        tempStr = [tempStr stringByReplacingCharactersInRange:range withString:@""];
//        range = [tempStr rangeOfString:subString];
        //每次都要添加之前删掉的range长度,以数组中的个数来计算
//        if (range.location == NSNotFound) {
//            continue;
//        }
//        NSValue *rangeValue = [NSValue valueWithRange:NSMakeRange(range.location + locationArr.count * subLength, subLength)];
//        [locationArr addObject:rangeValue];
        NSInteger location = range.location + range.length;
        range = [tempStr rangeOfString:subString options:(NSLiteralSearch) range:NSMakeRange(location, tempStr.length-location)];
        if (range.location == NSNotFound){
            continue;
        }
        [locationArr addObject:[NSValue valueWithRange:range]];
    }
    return locationArr;
}



@end
