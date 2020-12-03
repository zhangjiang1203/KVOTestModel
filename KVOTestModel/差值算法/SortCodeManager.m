//
//  SortCodeManager.m
//  KVOTestModel
//
//  Created by zhangjiang on 2019/12/5.
//  Copyright © 2019 zhangjiang. All rights reserved.
//

#import "SortCodeManager.h"

@implementation SortCodeManager

//冒泡
-(void)maopaoSort:(NSMutableArray*)array{
    //比较相邻的两个元素，若是前者大于后者 就交换两个元素的位置，
    for (int i = 0; i < array.count; i++) {
        for (int j = 0; j < array.count - 1 - i; j++) {
            if ([array[j] integerValue] > [array[j+1] integerValue]) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
}

//选择排序
-(void)selectDataSort:(NSMutableArray*)array {
    //一般取第一个元素作为最小值，依次和其他元素比较，若是前者大于后者交换两者的位置
    for (int i = 0; i < array.count; i++) {
        for (int j = i; j< array.count; j++) {
            if ([array[i] integerValue] > [array[j] integerValue]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
}

//快速排序
//设置两个变量i，j 排序开始的时候设置为 0 ， N-1
//以第一个数组元素最为关键数据，赋值给key，即key = A[0]
//从j向前开始搜索，即由后开始向前搜索(j--),找到第一个小于key的A[j],交换A[j]和A[i]
//从i向后开始搜索，即由前开始向后搜索(i++),找到第一个大于key的A[i],交换A[i]和A[j]
//重复递归的动作，知道结束为止
-(void)quickAscendingOrderSort:(NSMutableArray*)arr leftIndex:(NSInteger)left rightIndex:(NSInteger)right {
    if (left < right) {
        NSInteger tempIndex = [self getMiddleIndex:arr leftIndex:left rightIndex:right];
        [self getMiddleIndex:arr leftIndex:left rightIndex:tempIndex-1];
        [self getMiddleIndex:arr leftIndex:tempIndex+1 rightIndex:right];
    }
}

-(NSInteger)getMiddleIndex:(NSMutableArray*)arr leftIndex:(NSInteger)left rightIndex:(NSInteger)right {
    NSInteger temValue = [arr[left] integerValue];
    while (left < right) {
        while (left < right && temValue <= [arr[right] integerValue]) {
            right--;
        }
        if (left < right) {
            arr[left] = arr[right];
        }
        while (left < right && [arr[left] integerValue] >= temValue) {
            left++;
        }
        if (left < right){
            arr[right] = arr[left];
        }
        
    }
    arr[left] = [NSNumber numberWithInteger:temValue];
    return left;
}

/*
 从第一个元素开始，认为该元素已经是排好序的。
 取下一个元素，在已经排好序的元素序列中从后向前扫描。
 如果已经排好序的序列中元素大于新元素，则将该元素往右移动一个位置。
 重复步骤3，直到已排好序的元素小于或等于新元素。
*/
-(void)insertOrderSort:(NSMutableArray*)array {
    for (int i = 1; i < array.count; i++) {
        NSInteger tempValue = [array[i] integerValue];
        for (int j = i - 1; j >= 0 && tempValue < [array[j] integerValue]; j--) {
            array[j+1] = array[j];
            array[j] = [NSNumber numberWithInteger:tempValue];
        }
    }
}
@end
