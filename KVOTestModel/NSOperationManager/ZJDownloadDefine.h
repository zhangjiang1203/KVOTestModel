//
//  ZJDownloadDefine.h
//  NSOperationTest
//
//  Created by zhangjiang on 2021/5/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef KXDownloadDefine_h
#define KXDownloadDefine_h


@class ZJDownloadModel;

#pragma mark -下载优先级
typedef NS_ENUM(NSUInteger, KXDownloadPriority) {
    //先进先出
    KXDownloadPriority_FIFO = 0,
    //后进先出
    KXDownloadPriority_LIFO,
};


#pragma mark -下载类型
typedef NS_ENUM(NSUInteger, KXAttachmentType) {
    KXAttmentType_SVGA   = 1, // SVGA类型
    KXAttmentType_MP4    = 2, // MP4类型
    KXAttmentType_OTHRE  = 3, // 其他类型
};

#pragma mark - 下载状态
typedef NS_ENUM(NSUInteger, KXDownloadState) {
    KXDownloadState_None         = 0, // 初始状态
    KXDownloadState_Resume,           // 等待下载
    KXDownloadState_Downloading,      // 下载中
    KXDownloadState_Suspened,         // 暂停
    KXDownloadState_Failed,           // 失败
    KXDownloadState_Completed         // 完成
};


#pragma mark -回调定义
 
typedef void(^KXProgressBlock)(CGFloat present,NSString *_Nullable url);

typedef void(^KXCompletedBlock)(ZJDownloadModel *_Nullable attachment,NSError * _Nullable error);

#endif /* ZJDownloadDefine_h */
