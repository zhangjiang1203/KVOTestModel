//
//  ZJFileManager.m
//  NSOperationTest
//
//  Created by zhangjiang on 2021/5/6.
//

#import "ZJFileManager.h"
#import <sys/stat.h>
#import "ZJDownloadModel.h"

NSString * kx_getDocumentPath() {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return path;
}

NSString * kx_getCachesPath() {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return path;
}

NSString * kx_getTMPPath() {
    return NSTemporaryDirectory();
}

NSString * kx_getApplicationSupport() {
    
    return NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject;
}


@implementation ZJFileManager

+ (NSData *)queryFileWithURL:(NSString *)url type:(KXAttachmentType)type {
    ZJDownloadModel *model = [[ZJDownloadModel alloc]initWithURL:url progress:nil completed:nil];
    NSFileManager *manager = [NSFileManager defaultManager];
    __block NSData *data = nil;
    if ([manager fileExistsAtPath:model.filePath]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        data = [fileManager contentsAtPath:model.filePath];
    }
    return data;
}

+ (NSString *)getAttatchFilePathWithURL:(NSString *)url type:(KXAttachmentType)type {
    ZJDownloadModel *model = [[ZJDownloadModel alloc]initWithURL:url progress:nil completed:nil];
    if ([[NSFileManager defaultManager] fileExistsAtPath:model.filePath]) {
        return model.filePath;
    }
    return nil;
}


+ (void)removeFileWithURL:(NSString *)url type:(KXAttachmentType)type {
    //文件移除
    ZJDownloadModel *model = [[ZJDownloadModel alloc]initWithURL:url progress:nil completed:nil];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:model.filePath]) {
        [manager removeItemAtPath:model.filePath error:NULL];
    }
}


+ (void)removeFileWithType:(KXAttachmentType)type {
    //文件移除
    ZJDownloadModel *model = [[ZJDownloadModel alloc]initWithURL:@"http://www.kuxiu.com" progress:nil completed:nil];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:model.filePath isDirectory:NULL]) {
        [fileManager removeItemAtPath:model.filePath  error:nil];
    }
}



+ (void)removeAllFile {
    NSFileManager *manager = [NSFileManager defaultManager];
    ZJDownloadModel *model = [[ZJDownloadModel alloc]initWithURL:@"http://www.kuxiu.com" progress:nil completed:nil];
    NSString *filePath = [model.filePath stringByDeletingLastPathComponent];
    if ([manager fileExistsAtPath:filePath isDirectory:NULL]) {
        [manager removeItemAtPath:filePath error:NULL];
    }
    
}

/// 获取单个文件的大小 MB
+ (float)getAttchmentFileSizeAtPath:(NSString *)path {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return (fileSize / (1024.0 * 1024.0));
}

/// 获取整个文件夹的大小 MB
+ (float)getAttachmentFolderSizeWithPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) return 0;
    
    NSEnumerator *childFilesEnumertor = [[manager subpathsAtPath:path] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumertor nextObject]) != nil) {
        NSString *subPath = [path stringByAppendingPathComponent:fileName];
        folderSize += [self getAttchmentFileSizeAtPath:subPath];
    }
    return (folderSize / (1024.0 * 1024.0));
}

+ (float)totalFileSize {
    ZJDownloadModel *model = [[ZJDownloadModel alloc]initWithURL:@"http://www.kuxiu.com" progress:nil completed:nil];
    float totalSize = 0;
    //获取当前目录
    NSString *filePath = [model.filePath stringByDeletingLastPathComponent];
    totalSize += [self getAttachmentFolderSizeWithPath:filePath];
    return totalSize;
}



/// 写文件到磁盘中
+ (NSError *)writeFile:(NSString *)filePath fileData:(NSData *)data {
    NSError *error = nil;
    //读取数据，写数据到指定文件中
    NSInputStream *inputStream =  [[NSInputStream alloc] initWithData:data];
    NSOutputStream *outputStream = [[NSOutputStream alloc] initWithURL:[NSURL fileURLWithPath:filePath] append:YES];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
    while ([inputStream hasBytesAvailable] && [outputStream hasSpaceAvailable]) {
        uint8_t buffer[1024];
        
        NSInteger bytesRead = [inputStream read:buffer maxLength:1024];
        if (inputStream.streamError || bytesRead < 0) {
            error = inputStream.streamError;
            break;
        }
        
        NSInteger bytesWritten = [outputStream write:buffer maxLength:(NSUInteger)bytesRead];
        if (outputStream.streamError || bytesWritten < 0) {
            error = outputStream.streamError;
            break;
        }
        
        if (bytesRead == 0 && bytesWritten == 0) {
            break;
        }
    }
    [outputStream close];
    [inputStream close];
    return error;
}
//遍历文件夹，移动文件夹中的所有文件到对应的文件中
//值为对应的文件夹名称，
+ (void)moveFilesWithPath:(NSString *)sourcePath type:(KXAttachmentType)type isDeleteSourceFile:(BOOL)isDelete {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        
        NSString *fromPath = sourcePath;
        if (![self isDirectoryWithPath:sourcePath]) {
            //文件夹目录不存在
            fromPath = [fromPath stringByDeletingLastPathComponent];
            return;
        }
        
        // 根据模型生成文件路径信息，获取对应文件夹下的文件列表
        NSArray *fileList = [manager contentsOfDirectoryAtPath:fromPath error:nil];
        ZJDownloadModel *model = [[ZJDownloadModel alloc]initWithURL:@"http://www.kuxiu.com" progress:nil completed:nil];
        
        //获取文件保存的文件目录
        NSString *toPath = [model.filePath stringByDeletingLastPathComponent];
        //判断toPath 是否存在  不存在就创建
        [self creatDirectoryWithPath:toPath];
        
        //转移文件
        [fileList enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"文件信息===%@",obj);
            [self moveFileWithPath:[fromPath stringByAppendingPathComponent:obj] toPath:[toPath stringByAppendingPathComponent:obj]];
        }];
        //删除之前的文件
        if (isDelete) {
            [manager removeItemAtPath:fromPath error:nil];
            NSLog(@"文件=%@，删除完成",fromPath);
        }
    });
}


///判断是否是文件夹
+ (BOOL)isDirectoryWithPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    //是否是文件目录
    BOOL isDir = NO;
    //是否存在
    BOOL isExist = [manager fileExistsAtPath:path isDirectory:&isDir];
    return (isExist && isDir);
}

/*
 项目迁移
 将一个文件夹中的文件都转移到新的文件夹中
 */
+ (BOOL)moveFileWithPath:(NSString *)sourcePath toPath:(NSString *)toPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    // 源文件不存在
    if (![manager fileExistsAtPath:sourcePath]) {
        return NO;
    }
    //如果目标文件存在 不迁移
    if ([manager fileExistsAtPath:toPath]) {
        return NO;
    }
    //判断对应的目录是否存在
    NSString *toComponet = [toPath stringByDeletingLastPathComponent];
    [self creatDirectoryWithPath:toComponet];
    
    BOOL result = [manager moveItemAtPath:sourcePath toPath:toPath error: nil];
    return result;
}


//判断文件夹是否存在，不存在就创建
+ (void)creatDirectoryWithPath:(NSString *)dirPath
{
    BOOL isDir = NO;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirExist = [manager fileExistsAtPath:dirPath isDirectory:&isDir];
    if(!(isDirExist && isDir)){
        BOOL bCreateDir = [manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create AttachmentFile Directory Failed.");
        }
    }
}
@end

