////
////  CorasickTreeManager.m
////  KVOTestModel
////
////  Created by zhangjiang on 2019/12/5.
////  Copyright © 2019 zhangjiang. All rights reserved.
////
//
//#import "CorasickTreeManager.h"
//#import "DebenDataManager.h"
//#include "aho_corasick.hpp"
//#include <chrono>
//#include <iostream>
//#include <set>
//#include <string>
//#include <vector>
//#include <wchar.h>
//#include <locale.h>
//
//namespace ac = aho_corasick;
//using trie = ac::trie;
//using namespace std;
//aho_corasick::trie actrie;
//
/////获取next数组
//void GetNextval(wchar_t* p, int next[])
//{
//    NSInteger pLen = wcslen(p);
//    next[0] = -1;
//    int k = -1;
//    int j = 0;
//    while (j < pLen - 1)
//    {
//        //p[k]表示前缀，p[j]表示后缀
//        if (k == -1 || p[j] == p[k])
//        {
//            ++j;
//            ++k;
//            //较之前next数组求法，改动在下面4行
//            if (p[j] != p[k])
//                next[j] = k;   //之前只有这一行
//            else
//                //因为不能出现p[j] = p[ next[j ]]，所以当出现时需要继续递归，k = next[k] = next[next[k]]
//                next[j] = next[k];
//        }
//        else
//        {
//            k = next[k];
//        }
//    }
//}
//
//
/////KMP匹配
//int kmpMatch(wchar_t par[],wchar_t sub[]){
//    //获取前缀后缀的next数组
//    NSInteger slen = wcslen(par);
//    NSInteger plen = wcslen(sub);
//    int next[20] = {0};
//    GetNextval(sub, next);
//    int i = 0 ,j = 0;
//    while (i < slen && j < plen) {
//        if (j == -1 || par[i] == sub[j]) {
//            j++;
//            i++;
//        }else{
//            j = next[j];
//        }
//    }
//    if (j == plen){
//        return i - j;
//    }
//
//    return -1;
//}
//
//void corasickTest() {
//    auto start_time = chrono::high_resolution_clock::now();
//    NSArray *tempArr = [DebenDataManager getAllDebenItems];
//    for (DebenDataModel *model in tempArr) {
//        actrie.insert(model.deID.UTF8String);
//        actrie.insert(model.title.UTF8String);
//    }
//    auto end_time = chrono::high_resolution_clock::now();
//    auto time_1 = end_time - start_time;
//    cout << "自动机建树时间间隔: " << chrono::duration_cast<chrono::milliseconds>(time_1).count();
//    cout << "ms";
//    cout << endl;
//
//    NSInteger size = sizeof(tempArr);
//    NSLog(@"数据内存大小==%zd",size);
//
//    auto start_time2 = chrono::high_resolution_clock::now();
//    auto result = actrie.parse_text("000008.IB she 00国债11 000003.IB");
//    for (auto& text : result) {
//        NSLog(@"start %zu===end %zu == key==%s ",text.get_start(),text.get_end(),text.get_keyword().c_str());
//    }
//    auto result1 = actrie.parse_text("000001.IB she 00国债10 000006.IB");
//    auto end_time2 = chrono::high_resolution_clock::now();
//    auto time_2 = end_time2 - start_time2;
//    cout << "查询时间间隔: " << chrono::duration_cast<chrono::milliseconds>(time_2).count();
//    cout << "ms";
//    cout << endl;
//}
//
//@implementation CorasickTreeManager
//
//+ (instancetype)shareInstance {
//    return [[self alloc]init];
//}
//
//
//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//    static CorasickTreeManager *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[super allocWithZone:NULL]init];
//    });
//    return manager;
//}
//
//- (void) clearTrieTree {
//    actrie.clearTrie();
//}
//
///// 创建AC自动机
//- (NSString *)createTrieTree {
//    NSTimeInterval start = [[NSDate date] timeIntervalSince1970]*1000;
//    NSArray *tempArr = [DebenDataManager getAllDebenItems];
//    for (DebenDataModel *model in tempArr) {
//        actrie.insert(model.deID.UTF8String);
//        actrie.insert(model.title.UTF8String);
//    }
//    //调用fail
//    actrie.check_construct_failure_states();
//    NSTimeInterval end = [[NSDate date] timeIntervalSince1970]*1000;
//    //构造ac自动机
//    return [NSString stringWithFormat:@"ac自动机构建===%.0fms",end-start];
//}
//
///// ac自动机查询
//- (NSString *) trieFindMyTree:(NSString *)string {
//     NSTimeInterval start = [[NSDate date] timeIntervalSince1970]*1000;
//    auto result = actrie.parse_text(string.UTF8String);
//    NSInteger chineseCount = 0, location = 0;;
//    for (auto& text : result) {
//        NSString *tempURL = [NSString stringWithCString:text.get_keyword().c_str() encoding:NSUTF8StringEncoding];
//        NSInteger wordsCount = [self chineseWordLength:tempURL];
//        if (text.get_start() > 0){
//            location = text.get_start() - 2 * chineseCount;
//        }else{
//            location = text.get_start();
//        }
//        chineseCount += wordsCount;
//        NSLog(@"当前的定位信息===%@",[NSValue valueWithRange:NSMakeRange(location, tempURL.length)]);
//        cout << "自动机查询结果: start==" << text.get_start();
//        cout << "end==" << text.get_end();
//        cout << "key==" << text.get_keyword().c_str();
//        cout << endl;
//    }
//     NSTimeInterval end = [[NSDate date] timeIntervalSince1970]*1000;
//    return [NSString stringWithFormat:@"ac自动机查询===%.0fms",end-start];
//}
//
//- (NSInteger) chineseWordLength:(NSString*)string {
//    NSRegularExpression *tChineseRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:nil];
//
//    NSUInteger tChineseMatchCount = [tChineseRegularExpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
//    return tChineseMatchCount;
//}
//
//
//
//- (NSString *)forNormalTimeCal:(NSString *)string {
//    NSMutableArray* passArray = [NSMutableArray array];
//    //设置对应的区域
//    NSTimeInterval start = [[NSDate date] timeIntervalSince1970]*1000;
//    NSArray *itemModelArr = [DebenDataManager getAllDebenItems];
//    //开始进行匹配
//    NSString *tempStr = [string copy];
//    for(DebenDataModel *model in itemModelArr) {
//        @autoreleasepool {
//            NSRange idRange = [tempStr rangeOfString:model.deID];
//            if (idRange.location != NSNotFound) {
//                NSArray *rangeArr = [DebenDataManager getAllSubStringRangeFromString:tempStr withSubString:model.deID];
//                for (NSValue *value in rangeArr) {
//                    //表示有值
//                    DebenDataModel* newRange = [DebenDataModel new];
//                    newRange.deID = model.deID;
//                    newRange.rectValue = value;
//                    [passArray addObject:newRange];
//                }
//            }
//            NSRange contentRange = [tempStr rangeOfString:model.title];
//            if(contentRange.location != NSNotFound) {
//                NSArray *rangeArr = [DebenDataManager getAllSubStringRangeFromString:tempStr withSubString:model.title];
//                for (NSValue *value in rangeArr) {
//                    //表示有值
//                    DebenDataModel* newRange = [DebenDataModel new];
//                    newRange.title = model.title;
//                    newRange.rectValue = value;
//                    [passArray addObject:newRange];
//                }
//            }
//        }
//    }
//    for (DebenDataModel *value in passArray) {
//         NSLog(@"匹配到的值==%@",value);
//    }
//
//    NSTimeInterval end = [[NSDate date] timeIntervalSince1970]*1000;
//
//    return [NSString stringWithFormat:@"for循环查找==%.0fms",end-start];
//}
//
///**
// 获取next数组
//
// @param pString 匹配字符串
// @return next数组
// */
//- (NSArray *)getNextArray:(NSString *)pString {
//    NSMutableArray *nextA = [NSMutableArray arrayWithCapacity:pString.length];
//    //定义前缀索引
//    int j = -1;
//    //定义后缀索引 大于前缀索引
//    int i = 0;
//    //给next数组的第0个元素赋值为-1
//    nextA[0] = @(-1);
//    while (i < pString.length) {
//        if (-1 == j || [pString characterAtIndex:i] == [pString characterAtIndex:j]) {
//            //当前缀和后缀相等时
//            ++i;
//            ++j;
//            //给next数组的元素赋值
////            nextA[i] = @(j);//这里说明一下 假设pString是 @"aba"  第0个元素的a 和 第2个元素的a相等 那么next[2]就应该是1 也就是要往后挪动一个位置
////            if ([pString characterAtIndex:i] != [pString characterAtIndex:j]){
//                nextA[i] = @(j);
////            }else{
////                nextA[i] = nextA[j];
////            }
//        }else {
//            //当两个字符不相等的时候 我们就需要回溯 那具体回溯的位置是哪里呢？ 一句next数组的概念 它里面存放的元素是下一次要移动的位数 所以我们的j = nextA[j]
//            j = [nextA[j] intValue];
//        }
//    }
//
//    return nextA;
//}
//
//
///**
// KMP算法
//
// @param tString 主串
// @param pString 字串
// @return 匹配成功返回匹配成功位置 失败返回-1
// */
//- (int)KMP:(NSString *)tString pString:(NSString *)pString startIndex:(int)start {
//    if (tString.length <= 0 || pString.length <= 0){
//        return -1;
//    }
////    @autoreleasepool {
//        //主串tString的索引
//        int i = start;
//        //字串pString的索引
//        int j = 0;
//        //获取主串和字串的字符串长度（特别注意因为使用length获取的长度是NSUInteger类型的,直接和它对比会出现问题 所以这里我都强制转换为int）
//        int tLength = (int)tString.length;
//        int pLength = (int)pString.length;
//        //获取next数组
//        NSArray *nextArray = [self getNextArray:pString];
//        while (i < tLength && j < pLength) {
//            if (-1 == j || [tString characterAtIndex:i] == [pString characterAtIndex:j]) {
//                i++;
//                j++;
//            }else {
//                //回溯到下一个位置
//                j = [nextArray[j] intValue];
//            }
//        }
//        if (j == pLength) {
//            return i - j;
//        }
////    }
//    return -1;
//}
//
/////kmp测试
//- (NSString *)showKMPTest:(NSString*)pStr{
//    NSMutableArray* passArray = [NSMutableArray array];
//    NSArray *itemModelArr = [DebenDataManager shareInstance].debenItemsArr;
//    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
//    @autoreleasepool {
//        for(DebenDataModel *model in itemModelArr) {
//            //判断id
//            int idIndex = [self KMP:pStr pString:model.deID startIndex:0];
//            if (idIndex != -1) {
//                NSLog(@"d匹配的值==%d===匹配字符%@",idIndex,model.deID);
//            }
//            while (idIndex != -1) {
//                //添加对应的idIndex 到数组中
//                [passArray addObject:[NSValue valueWithRange:NSMakeRange(idIndex, model.deID.length)]];
//                //继续查找
//                idIndex = [self KMP:pStr pString:model.deID startIndex:(idIndex+int(model.deID.length))];
//            }
//
//            //判断title
//            int titleIndex = [self KMP:pStr pString:model.title startIndex:0];
//            if (titleIndex != -1) {
//                NSLog(@"d匹配的值==%d===匹配字符%@",titleIndex,model.title);
//            }
//            while (titleIndex != -1) {
//                //添加对应的idIndex 到数组中
//                [passArray addObject:[NSValue valueWithRange:NSMakeRange(titleIndex, model.title.length)]];
//                //继续查找
//                titleIndex = [self KMP:pStr pString:model.title startIndex:(titleIndex+int(model.title.length))];
//            }
//        }
//
//        for (NSValue *value in passArray) {
//             NSLog(@"匹配到的值==%@",value);
//        }
//    }
//    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
//    return [NSString stringWithFormat:@"kmp循环查找==%.0fms",(end-start)*1000];
//}
//
//@end
