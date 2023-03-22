//
//  ZJShowTestParserFilter.m
//  KVOTestModel
//
//  Created by douyu on 2023/3/21.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import "ZJShowTestParserFilter.h"

@implementation ZJShowTestParserFilter

- (NSInteger)filterPriority{
    return  4;
}


- (NSObject *)pipelineFilter:(NSObject *)object{
    return object;
}


@end
