//
//  ZJPipeline+Input.h
//  ZJFoundation
//
//  Created by 三井 on 2020/1/15.
//

#import "ZJPipeline.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZJPipelineInputProtocol <NSObject>

@required
/**
 生产产品的方法，会由【流水线】主动调用

 @return 返回产品,如果为nil，不会被加入到流水线中
 */
- (NSObject * _Nullable)produceFor:(ZJPipeline *)pipeline;

@end

/// 流水线被动输入
@interface ZJPipeline (Input)

@property (nonatomic, weak) id<ZJPipelineInputProtocol> input;

@end

NS_ASSUME_NONNULL_END
