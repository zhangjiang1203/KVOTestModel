//
//  ZJDownloadOperation.h
//  NSOperationTest
//
//  Created by zhangjiang on 2021/4/30.
//

#import <Foundation/Foundation.h>
#import "ZJDownloadDefine.h"

NS_ASSUME_NONNULL_BEGIN


//FOUNDATION_EXTERN NSString * _Nonnull const ZJDownloadStartNoti;
//FOUNDATION_EXTERN NSString * _Nonnull const ZJDownloadReceiveResponseNoti;
//FOUNDATION_EXTERN NSString * _Nonnull const ZJDownloadStopNoti;
//FOUNDATION_EXTERN NSString * _Nonnull const ZJDownloadFinishNoti;


@interface ZJDownloadOperation : NSOperation<NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (nonatomic,copy) NSString *zj_name;

@property (nonatomic,strong) NSURLRequest *request;

@property (nonatomic,strong,readonly,nullable) NSURLSessionTask *dataTask;


/// 初始化下载operation
/// @param session session
/// @param request request
- (instancetype)initWithSession:(NSURLSession *)session request:(NSURLRequest *)request;


/// 对operation添加回调
/// @param progressBlock 进度回调
/// @param completedBlock 结果回调
- (id)addHandlerWithProgress:(nullable KXProgressBlock)progressBlock completed:(nullable KXCompletedBlock)completedBlock;



@end

NS_ASSUME_NONNULL_END
