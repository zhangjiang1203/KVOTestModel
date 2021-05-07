//
//  ZJDownloadModel.h
//  NSOperationTest
//
//  Created by zhangjiang on 2021/5/6.
//

#import <Foundation/Foundation.h>
#import "ZJDownloadDefine.h"
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString * getMD5String(NSString *str);


@interface ZJDownloadModel : NSObject

/// 下载地址
@property (nonatomic,copy,readonly) NSString *url;
/// 时间戳
@property (nonatomic,assign) NSTimeInterval timestamp;
/// 附件状态
@property (nonatomic,assign,readonly) KXDownloadState state;
/// 名称
@property (nonatomic,copy,readonly) NSString *fileName;
/// 文件对应路径
@property (nonatomic,copy,readonly) NSString *filePath;

//保存目录名称
@property (nonatomic,copy,readonly) NSString *dirName;
/// 唯一标识
@property (nonatomic,copy,readonly) NSString *identifier;
/// 已经下载
@property (assign, nonatomic,readonly) long long currentSize;
/// 总下载
@property (assign, nonatomic,readonly) long long totalSize;
/// 当前的下载进度
@property (nonnull,strong,readonly)NSProgress *progress;

///添加对应的回调通知
@property (nonatomic,copy,readonly) KXCompletedBlock  successBlock;

@property (nonatomic,copy,readonly) KXProgressBlock progressBlock;

- (instancetype)initWithURL:(nonnull NSString *)url progress:(nullable KXProgressBlock)progressBlock completed:(nullable KXCompletedBlock)completedBlock;

//通过下面的方法，设置readonly字段通过以下方法
- (void)setTotalSize:(long long)totalSize;
- (void)setState:(KXDownloadState)state;

- (void)setSuccessBlock:(KXCompletedBlock _Nonnull)successBlock;
- (void)setProgressBlock:(KXProgressBlock _Nonnull)progressBlock;

@end

NS_ASSUME_NONNULL_END
