//
//  ZJPipeline+Filter.h
//  ZJFoundation
//
//  Created by 三井 on 2020/1/15.
//

#import "ZJPipeline.h"

@protocol ZJPipelineFilterProtocol <NSObject>

@optional
/// 返回该过滤器的优先级,如果没有实现则为0
@property (nonatomic, assign, readonly) NSInteger filterPriority;

@required
/**
 如果向【流水线】添加了过滤器，当产品即将被推出时，依次经过所有的过滤器。

 @param object 流水线中的产品，或经过其它过滤器的产品
 @return 过滤后的产品，如果返回nil，该产品会被丢弃
 */
- (NSObject * _Nullable)pipelineFilter:(NSObject * _Nonnull)object;

@end

/// 流水线过滤器
@interface ZJPipeline (Filter)

/// 添加过滤器
/// @param filter 过滤器
- (void)addFilter:(_Nonnull id<ZJPipelineFilterProtocol>)filter;

/// 移除过滤器
/// @param filter 过滤器
- (void)removeFilter:(_Nonnull id<ZJPipelineFilterProtocol>)filter;

@end
