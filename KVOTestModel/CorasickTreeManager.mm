//
//  CorasickTreeManager.m
//  KVOTestModel
//
//  Created by zhangjiang on 2019/12/5.
//  Copyright © 2019 zhangjiang. All rights reserved.
//

#import "CorasickTreeManager.h"
#import "DebenDataManager.h"
#include "aho_corasick.hpp"
#include <chrono>
#include <iostream>
#include <set>
#include <string>
#include <vector>

namespace ac = aho_corasick;
using trie = ac::trie;
using namespace std;
aho_corasick::trie actrie;

void corasickTest() {
    auto start_time = chrono::high_resolution_clock::now();
    NSArray *tempArr = [DebenDataManager getAllDebenItems];
    for (DebenDataModel *model in tempArr) {
        actrie.insert(model.deID.UTF8String);
        actrie.insert(model.title.UTF8String);
    }
    auto end_time = chrono::high_resolution_clock::now();
    auto time_1 = end_time - start_time;
    cout << "自动机建树时间间隔: " << chrono::duration_cast<chrono::milliseconds>(time_1).count();
    cout << "ms";
    cout << endl;
    
    NSInteger size = sizeof(tempArr);
    NSLog(@"数据内存大小==%zd",size);
    
    auto start_time2 = chrono::high_resolution_clock::now();
    auto result = actrie.parse_text("000008.IB she 00国债11 000003.IB");
    for (auto& text : result) {
        NSLog(@"start %zu===end %zu == key==%s ",text.get_start(),text.get_end(),text.get_keyword().c_str());
    }
    auto result1 = actrie.parse_text("000001.IB she 00国债10 000006.IB");
    auto end_time2 = chrono::high_resolution_clock::now();
    auto time_2 = end_time2 - start_time2;
    cout << "查询时间间隔: " << chrono::duration_cast<chrono::milliseconds>(time_2).count();
    cout << "ms";
    cout << endl;
}

@implementation CorasickTreeManager

+ (instancetype)shareInstance {
    return [[self alloc]init];
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static CorasickTreeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL]init];
    });
    return manager;
}

- (void) clearTrieTree {
    actrie.clearTrie();
}

/// 创建AC自动机
- (NSString *)createTrieTree {
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970]*1000;
    NSArray *tempArr = [DebenDataManager getAllDebenItems];
    for (DebenDataModel *model in tempArr) {
        actrie.insert(model.deID.UTF8String);
        actrie.insert(model.title.UTF8String);
    }
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970]*1000;
    //构造ac自动机
    return [NSString stringWithFormat:@"ac自动机构建===%.0fms",end-start];
}

/// ac自动机查询
- (NSString *) trieFindMyTree:(NSString *)string {
     NSTimeInterval start = [[NSDate date] timeIntervalSince1970]*1000;
    auto result = actrie.parse_text(string.UTF8String);
    for (auto& text : result) {
//        NSLog(@"start %zu===end %zu == key==%s ",text.get_start(),text.get_end(),text.get_keyword().c_str());
        cout << "自动机查询结果: start==" << text.get_start();
        cout << "end==" << text.get_end();
        cout << "key==" << text.get_keyword().c_str();
        cout << endl;
    }
     NSTimeInterval end = [[NSDate date] timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"ac自动机查询===%.0fms",end-start];
}

- (NSString *)forNormalTimeCal:(NSString *)string {
    NSMutableArray* passArray = [NSMutableArray array];
    //设置对应的区域
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970]*1000;
    NSArray *itemModelArr = [DebenDataManager getAllDebenItems];
    //开始进行匹配
    NSString *tempStr = [string copy];
    for(DebenDataModel *model in itemModelArr) {
        @autoreleasepool {
            NSRange idRange = [tempStr rangeOfString:model.deID];
            if (idRange.location != NSNotFound) {
                NSArray *rangeArr = [DebenDataManager getAllSubStringRangeFromString:tempStr withSubString:model.deID];
                for (NSValue *value in rangeArr) {
                    //表示有值
                    DebenDataModel* newRange = [DebenDataModel new];
                    newRange.deID = model.deID;
                    [passArray addObject:newRange];
                }
            }
            NSRange contentRange = [tempStr rangeOfString:model.title];
            if(contentRange.location != NSNotFound) {
                NSArray *rangeArr = [DebenDataManager getAllSubStringRangeFromString:tempStr withSubString:model.title];
                for (NSValue *value in rangeArr) {
                    //表示有值
                    DebenDataModel* newRange = [DebenDataModel new];
                    newRange.title = model.title;
                    [passArray addObject:newRange];
                }
            }
        }
    }
    for (DebenDataModel *value in passArray) {
         NSLog(@"匹配到的值==%@",value);
    }

    NSTimeInterval end = [[NSDate date] timeIntervalSince1970]*1000;

    return [NSString stringWithFormat:@"for循环查找==%.0fms",end-start];
}


@end
