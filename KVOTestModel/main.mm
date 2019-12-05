//
//  main.m
//  KVOTestModel
//
//  Created by zj on 2019/10/11.
//  Copyright © 2019 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#include "aho_corasick.hpp"
#include <chrono>
#include <iostream>
#include <set>
#include <string>
#include <vector>

#import "DebenDataManager.h"


namespace ac = aho_corasick;
using trie = ac::trie;

using namespace std;

string gen_str(size_t len) {
    static const char alphanum[] =
            "0123456789"
            "!@#$%^&*"
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            "abcdefghijklmnopqrstuvwxyz";

    string str;
    for (int i = 0; i < len; ++i) {
        str.append(1, alphanum[rand() % (sizeof(alphanum) - 1)]);
    }
    return string(str);
}

size_t bench_naive(vector<string> text_strings, vector<string> patterns) {
    size_t count = 0;
    for (auto& text : text_strings) {
        for (auto& pattern : patterns) {
            size_t pos = text.find(pattern);
            while (pos != text.npos) {
                pos = text.find(pattern, pos);
                count++;
            }
        }
    }
    return count;
}

size_t bench_aho_corasick(vector<string> text_strings, trie& t) {
    size_t count = 0;
    for (auto& text : text_strings) {
        auto matches = t.parse_text(text);
        count += matches.size();
    }
    return count;
}

void normalTimeCal1(NSString *string) {
    NSMutableArray* passArray = [NSMutableArray array];
    //设置对应的区域
    auto start_time = chrono::high_resolution_clock::now();
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

    auto end_time = chrono::high_resolution_clock::now();
    auto time_1 = end_time - start_time;
    cout << "for遍历查询时间间隔: " << chrono::duration_cast<chrono::milliseconds>(time_1).count();
    cout << "ms";
    cout << endl;
}

void corasickTest1() {
    auto start_time = chrono::high_resolution_clock::now();
    NSArray *tempArr = [DebenDataManager getAllDebenItems];
    aho_corasick::trie trie;
//    trie.insert("hers");
//    trie.insert("his");
//    trie.insert("she");
//    trie.insert("he");
//    trie.insert("酸辣粉经济法是否");


    for (DebenDataModel *model in tempArr) {
        trie.insert(model.deID.UTF8String);
        trie.insert(model.title.UTF8String);
    }
    auto end_time = chrono::high_resolution_clock::now();
    auto time_1 = end_time - start_time;
    cout << "自动机建树时间间隔: " << chrono::duration_cast<chrono::milliseconds>(time_1).count();
    cout << "ms";
    cout << endl;

    NSInteger size = sizeof(tempArr);
    NSLog(@"数据内存大小==%zd",size);

    auto start_time2 = chrono::high_resolution_clock::now();
    auto result = trie.parse_text("000008.IB she 00国债11 000003.IB");
    for (auto& text : result) {
        NSLog(@"start %zu===end %zu == key==%s ",text.get_start(),text.get_end(),text.get_keyword().c_str());
    }
    auto result1 = trie.parse_text("000001.IB she 00国债10 000006.IB");
    auto end_time2 = chrono::high_resolution_clock::now();
    auto time_2 = end_time2 - start_time2;
    cout << "查询时间间隔: " << chrono::duration_cast<chrono::milliseconds>(time_2).count();
    cout << "ms";
    cout << endl;
}


int main(int argc, char * argv[]) {
    
//    normalTimeCal1(@"000008.IB she 00国债11 000003.IB");
//
//    corasickTest1();

    
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
