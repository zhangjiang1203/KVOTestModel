//
//  ZJPipelineCenter.m
//  KVOTestModel
//
//  Created by douyu on 2023/3/20.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import "ZJPipelineCenter.h"
#import "ZJPipeline.h"
#import "ZJShowTestParserFilter.h"


@interface ZJPipelineCenter ()<ZJPipelineFilterProtocol>

@property (nonatomic, strong) ZJPipeline *pipeline;

@end

@implementation ZJPipelineCenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pipeline = [ZJPipeline pipelineWithAction:^(ZJPipelineBatch * _Nonnull batch) {
            NSLog(@"收到展示的测试数据===%@",batch.objects);
        }];
        self.pipeline.batchSize = NSUIntegerMax;
        [self.pipeline addFilter:self];
        [self.pipeline addFilter:[ZJShowTestParserFilter new]];
    }
    return self;
}

- (void)insertMsg:(NSString *)message{
    if(message) {
        [self.pipeline process:message];
    }
}

- (void)clean {
    [self.pipeline clean];
}

#pragma mark - 代理方法
- (NSInteger)filterPriority{
    return 3;
}

- (NSObject *)pipelineFilter:(NSObject *)object{
    if(![object isKindOfClass:NSString.class]){
        return @"数据解析失败";
    }
    NSString *obj = (NSString *)object;
    
    return [NSString stringWithFormat:@"我是测试数据====="];
}
@end
