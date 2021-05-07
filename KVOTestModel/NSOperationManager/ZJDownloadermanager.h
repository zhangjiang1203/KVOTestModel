//
//  ZJDownloadermanager.h
//  NSOperationTest
//
//  Created by zhangjiang on 2021/5/6.
//

#import <Foundation/Foundation.h>
#import "ZJDownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJDownloadermanager : NSObject


/// 获取下载模型
+ (ZJDownloadModel *)downloadModelWithURL:(NSString *)url;


/// 开始下载任务，优先级默认为先进先出
/// @param url 下载url
/// @param progressBlock 进度回调
/// @param completedBlock 完成回调
+ (ZJDownloadModel *)downloadFileWithURL:(NSString *)url
                                  progress:(KXProgressBlock)progressBlock
                                 completed:(KXCompletedBlock)completedBlock;

/// 开始下载任务
/// @param url 下载url
/// @param priority 下载优先级
/// @param progressBlock 进度回调
/// @param completedBlock 完成回调
+ (ZJDownloadModel *)downloadFileWithURL:(NSString *)url
                                  priority:(KXDownloadPriority)priority
                                  progress:(KXProgressBlock)progressBlock
                                 completed:(KXCompletedBlock)completedBlock;

#pragma mark -对任务队列的操作

/// 暂停/恢复所有任务
+ (void)suspendedAllTask;


/// 暂停/恢复单个任务
/// @param url url
+ (void)suspendedTaskWithURL:(NSString *)url;


/// 取消所有任务
+ (void)cancelAllTask;

/// 取消单个任务
/// @param url url
+ (void)cancelTaskWithURL:(NSString *)url;


#pragma mark -文件操作
/// 写文件到磁盘中
/// @param filePath 文件路径
/// @param data data
+ (NSError *)syncWriteFile:(NSString *_Nonnull)filePath fileData:(NSData *)data;


/// 同步查询文件
/// @param url url
/// @param type type
+ (NSData *)syncQueryFileWithURL:(NSString *_Nonnull)url type:(KXAttachmentType)type;


/// 根据url和type获取文件路径 文件存在返回路径 不存在返回nil
+ (NSString *)getAttatchFilePathWithURL:(NSString *_Nonnull)url type:(KXAttachmentType)type;


/// 移动文件
/// @param sourcePath 原路径(必须传文件夹目录)
/// @param type 类型
+ (void)moveFilesWithPath:(NSString *)sourcePath type:(KXAttachmentType)type;


/// 移动并删除文件
/// @param sourcePath 原路径(必须传文件夹目录)
/// @param type 类型
+ (void)moveAndDeleteFilesWithPath:(NSString *)sourcePath type:(KXAttachmentType)type;


/// 根据文件类型移除文件
/// @param type type
+ (void)removeFileWithType:(KXAttachmentType)type;

/// 移除对应的文件
/// @param url url
/// @param type type
+ (void)removeFileWithURL:(NSString *_Nonnull)url type:(KXAttachmentType)type;


/// 移除所有(清空缓存)
+ (void)removeAllFile;


/// 获取单个文件的大小(MB)
+ (float)getAttchmentFileSizeAtPath:(NSString *_Nonnull)path;

/// 下载文件大小(MB)
+ (float)totalFileSize;


@end

NS_ASSUME_NONNULL_END
