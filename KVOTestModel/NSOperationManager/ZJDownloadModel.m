//
//  ZJDownloadModel.m
//  NSOperationTest
//
//  Created by zhangjiang on 2021/5/6.
//

#import "ZJDownloadModel.h"
#import <CommonCrypto/CommonCrypto.h>
#import "ZJFileManager.h"

NSString * getMD5String(NSString *str) {

    if (str == nil) return nil;

    const char *cstring = str.UTF8String;
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstring, (CC_LONG)strlen(cstring), bytes);

    NSMutableString *md5String = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5String appendFormat:@"%02x", bytes[i]];
    }
    return md5String;
}

static unsigned long long fileSizeForPath(NSString *path) {
    
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

@interface ZJDownloadModel()

@property (nonatomic,strong) NSProgress *progress;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *filePath;

@property (nonatomic,copy) NSString *fileName;

@property (nonatomic,copy) NSString *dirName;

@property (nonatomic,copy) NSString *identifier;

@end


@implementation ZJDownloadModel

- (instancetype)initWithURL:(nonnull NSString *)url progress:(nullable KXProgressBlock)progressBlock completed:(nullable KXCompletedBlock)completedBlock {
    self = [super init];
    if (self) {
        self.url = url;
//        self.type = type;
        self.progressBlock = progressBlock;
        self.successBlock = completedBlock;
    }
    return self;
}

//通过下面的方法，设置readonly字段通过以下方法
- (void)setTotalSize:(long long)totalSize {
    _totalSize = totalSize;
}

- (void)setState:(KXDownloadState)state {
    _state = state;
}


- (void)setSuccessBlock:(KXCompletedBlock _Nonnull)successBlock {
    _successBlock = successBlock;
}

- (void)setProgressBlock:(KXProgressBlock _Nonnull)progressBlock {
    _progressBlock = progressBlock;
}


- (NSString *)filePath {
    //在根据url和type 生成对应的文件路径
    NSString *comp = [@"AttachmentFile" stringByAppendingPathComponent:self.fileName];
    NSString *path = [kx_getApplicationSupport() stringByAppendingPathComponent:comp];
    if (![path isEqualToString:_filePath]) {
        NSString *dir = [path stringByDeletingLastPathComponent];
        //判断dir是否存在
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL isDir = NO;
        BOOL isDirExist = [manager fileExistsAtPath:dir isDirectory:&isDir];
        if(!(isDirExist && isDir)){
            BOOL bCreateDir = [manager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
            if(!bCreateDir){
                NSLog(@"Create AttachmentFile Directory Failed.");
            }
        }
        _filePath = path;
    }
    return _filePath;
}

- (NSString *)fileName {
    if(_fileName == nil){
        //获取拓展名
        NSString *fileExtension = self.url.pathExtension;
        if (fileExtension.length) {
            _fileName = [NSString stringWithFormat:@"%@.%@", getMD5String(self.url), fileExtension];
        } else {
            _fileName = getMD5String(self.url);
        }
    }
    return _fileName;
}

- (NSProgress *)progress{
    if (!_progress) {
        _progress = [[NSProgress alloc]initWithParent:nil userInfo:nil];
    }
    @try {
        _progress.totalUnitCount = self.totalSize;
        _progress.completedUnitCount = self.currentSize;
    } @catch (NSException *exception) {
    }
    return _progress;
}

- (long long)currentSize{
    return fileSizeForPath(self.filePath);
}





@end
