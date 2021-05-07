//
//  ZJFileManager.h
//  NSOperationTest
//
//  Created by zhangjiang on 2021/5/6.
//

#import <Foundation/Foundation.h>
#import "ZJDownloadDefine.h"
NS_ASSUME_NONNULL_BEGIN

/// 获取document路径
FOUNDATION_EXTERN NSString * kx_getDocumentPath(void);

/// 获取cache路径
FOUNDATION_EXTERN NSString * kx_getCachesPath(void);

/// 获取Application Support路径
NSString * kx_getApplicationSupport(void);

/// 获取临时路径
FOUNDATION_EXTERN NSString * kx_getTMPPath(void);

///获取文件的大小
FOUNDATION_EXTERN float kx_getFileSize(NSString *path);


@interface ZJFileManager : NSObject

/// 写文件到磁盘中
/// @param filePath 文件路径
/// @param data data
+ (NSError *)writeFile:(NSString *_Nonnull)filePath fileData:(NSData *)data;

/// 同步查询文件
/// @param url url
/// @param type type
+ (NSData *)queryFileWithURL:(NSString *_Nonnull)url type:(KXAttachmentType)type;


/// 根据url和type获取文件路径 文件存在返回路径 不存在返回nil
+ (NSString *)getAttatchFilePathWithURL:(NSString *_Nonnull)url type:(KXAttachmentType)type;

/// 移除对应的文件
/// @param url url
/// @param type type
+ (void)removeFileWithURL:(NSString *_Nonnull)url type:(KXAttachmentType)type;



/// 移动文件，根据type 生成对应的文件目录
/// @param sourcePath 原路径
/// @param type 文件类型
+ (void)moveFilesWithPath:(NSString *)sourcePath
                     type:(KXAttachmentType)type
       isDeleteSourceFile:(BOOL)isDelete;


///判断是否是文件夹
+ (BOOL)isDirectoryWithPath:(NSString *)path;

/// 根据类型移除文件
/// @param type type
+ (void)removeFileWithType:(KXAttachmentType)type;

/// 移除所有(清空缓存)
+ (void)removeAllFile;


/// 获取单个文件的大小(MB)
+ (float)getAttchmentFileSizeAtPath:(NSString *_Nonnull)path;

/// 下载文件大小(MB)
+ (float)totalFileSize;

@end

NS_ASSUME_NONNULL_END
