//
//  ZJPipeline.h
//  ZJFoundation
//
//  Created by 三井 on 2020/1/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ZJPipelineBatch;
/// 用于生产消费方式的模型类
@interface ZJPipeline : NSObject <NSFastEnumeration>

/// 当流水线中的产品足够时，将最大推出 batchSize 数量的产品，默认为1
@property (nonatomic, assign) NSUInteger batchSize;

/// 返回一个流水线，当有产品需要处理时，使用action
/// @param action 处理逻辑
+ (ZJPipeline *)pipelineWithAction:(void (^)(ZJPipelineBatch *batch))action;

/// 向流水线推入一个产品
/// @param object 产品
- (void)produce:(NSObject *)object;

/// 同步处理数据并立即返回
/// @mark 同步处理
/// @param object 被处理数据
- (NSObject * _Nullable)process:(NSObject *)object;

/// 上一批次的商品已被消费
- (void)consumed;

/// 将已进入该线，而尚在等待的数据清空，线程安全
- (void)clean;

/// 摧毁该流水线
- (void)destroy;

@end

#pragma mark -

/// 流水线推出的打包产物
@interface ZJPipelineBatch : NSObject

@property (nonatomic, copy) NSArray<NSObject *> *objects;

/// 被消费
- (void)consumed;

@end

NS_ASSUME_NONNULL_END
