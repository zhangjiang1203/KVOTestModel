//
//  ZJDownloadermanager.m
//  NSOperationTest
//
//  Created by zhangjiang on 2021/5/6.
//

#import "ZJDownloadermanager.h"
#import "ZJDownloadOperation.h"
#import "ZJDownloadDefine.h"
#import "ZJDownloadModel.h"
#import "ZJFileManager.h"

@interface ZJDownloadermanager()<NSURLSessionDataDelegate,NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@property (nonatomic, strong) dispatch_queue_t barrierQueue;
/// 下载session
@property (nonatomic, strong) NSURLSession *downloadSession;
/// 设置依赖任务使用
@property (nonatomic, strong) ZJDownloadOperation *lastOperation;

@property (nonatomic, strong) NSMutableDictionary *downloadModelDict;

//保存operation
@property (nonatomic, strong) NSMutableDictionary<NSString *,ZJDownloadOperation *> *requestOperationDict;

@end


@implementation ZJDownloadermanager

static ZJDownloadermanager *_instance = nil;

//保存下载的模型和展示数据
/// 对应url下载成功 从该字典中移除
- (NSMutableDictionary *)downloadModelDict{
    if (!_downloadModelDict) {
        _downloadModelDict = [NSMutableDictionary dictionary];
    }
    return _downloadModelDict;
}

- (NSMutableDictionary *)requestOperationDict{
    if (!_requestOperationDict) {
        _requestOperationDict = [NSMutableDictionary dictionary];
    }
    return _requestOperationDict;
}


+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZJDownloadermanager alloc]init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.downloadQueue = [[NSOperationQueue alloc]init];
        self.downloadQueue.maxConcurrentOperationCount = 1;
        self.downloadQueue.name = @"com.kuxiu.download.operation";
        
        self.barrierQueue = dispatch_queue_create("com.kuxiu.download.barrierQueue", DISPATCH_QUEUE_CONCURRENT);
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 30;
        config.HTTPMaximumConnectionsPerHost = 4;
        
        self.downloadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        
        // 监听APP状态变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

    }
    return self;
}


#pragma mark -  NSNotification
- (void)applicationWillTerminate:(NSNotification *)noti {
    [self cancelAllTask];
}

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)noti {
    [self suspendedAllTask];
}

// 退到后台
- (void)applicationWillResignActive:(NSNotification *)noti {
    if (!self.downloadQueue.isSuspended) {
        [self suspendedAllTask];        
    }
}
// 进入前台
- (void)applicationDidBecomeActive:(NSNotification *)noti {
    if (self.downloadQueue.isSuspended) {
        [self suspendedAllTask];
    }
}

#pragma mark -封装类方法
+ (ZJDownloadModel *)downloadFileWithURL:(NSString *)url
                                  priority:(KXDownloadPriority)priority
                                  progress:(KXProgressBlock)progressBlock
                                 completed:(KXCompletedBlock)completedBlock {
    return [[ZJDownloadermanager shareInstance] downloadFileWithURL:url priority:priority progress:progressBlock completed:completedBlock];;
}

+ (ZJDownloadModel *)downloadFileWithURL:(NSString *)url
                                  progress:(KXProgressBlock)progressBlock
                                 completed:(KXCompletedBlock)completedBlock {
    return [[ZJDownloadermanager shareInstance] downloadFileWithURL:url priority:KXDownloadPriority_FIFO progress:progressBlock completed:completedBlock];
}


- (ZJDownloadModel *)downloadFileWithURL:(NSString *)url
                                  priority:(KXDownloadPriority)priority
                                  progress:(KXProgressBlock)progressBlock
                                 completed:(KXCompletedBlock)completedBlock {
    if (url == nil || url.length == 0){
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
        completedBlock(nil,error);
        return nil;
    }
    
    //获取对应的下载模型
    ZJDownloadModel *model = [self downloadModelWithURL:url];
    if (model.state == KXDownloadState_Completed) {
        if (completedBlock) {
            completedBlock(model,nil);
        }
        if (model.successBlock) {
            model.successBlock(model,nil);
        }
        return model;
    }
    //添加任务设置
    dispatch_barrier_sync(self.barrierQueue, ^{
        
        ZJDownloadOperation *operation = self.requestOperationDict[url];
        if (!operation) {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            request.HTTPShouldUsePipelining = YES;
            //  不上传Range 每次都是重新下载，设置了 就直接返回成功
            if (model.currentSize > 0) {
                [request setValue:[@"bytes=" stringByAppendingFormat:@"%lld-",model.currentSize] forHTTPHeaderField:@"Range"];
            }
            
            operation = [[ZJDownloadOperation alloc]initWithSession:self.downloadSession request:request];
            [self.downloadQueue addOperation:operation];
            //设置依赖关系
            if (priority == KXDownloadPriority_LIFO) {
                [self.lastOperation addDependency:operation];
                self.lastOperation = operation;
            }
            self.requestOperationDict[url] = operation;
            //执行成功之后清除对应operation
            __weak typeof(operation) weakOperation = operation;
            operation.completionBlock = ^{
                __strong typeof(operation) strongOperation = weakOperation;
                if (!strongOperation) return;
                if (self.requestOperationDict[url] == operation) {
                    [self.requestOperationDict removeObjectForKey:url];
                }
            };
        }
        // 添加对应的回调事件
        [operation addHandlerWithProgress:progressBlock completed:completedBlock];
    });
    return model;
}


/// 获取下载模型
+ (ZJDownloadModel *)downloadModelWithURL:(NSString *)url{
    return [[ZJDownloadermanager shareInstance] downloadModelWithURL:url];
}


- (ZJDownloadModel *)downloadModelWithURL:(NSString *)url{
    if (url == nil || url.length == 0) {
        return nil;
    }
    if (self.downloadModelDict[url]) {
        return self.downloadModelDict[url];
    }else{
        //创建对应的模型
        ZJDownloadModel *model = [[ZJDownloadModel alloc]initWithURL:url progress:nil completed:nil];
        //设置各种默认值和对应的属性
        self.downloadModelDict[url] = model;
        return model;
    }
    return nil;
}

#pragma mark -取消 暂停的操作
+ (void)cancelTaskWithURL:(NSString *)url {
    [[ZJDownloadermanager shareInstance]cancelTaskWithURL:url];
}

+ (void)cancelAllTask{
    [[ZJDownloadermanager shareInstance] cancelAllTask];
}

- (void)cancelTaskWithURL:(NSString *)url {
    if (url == nil || url.length == 0) {
        return;
    }
    ZJDownloadOperation *op = self.requestOperationDict[url];
    if (op) {
        [op cancel];
    }
}

- (void)cancelAllTask{
    [self.downloadQueue cancelAllOperations];
}

+ (void)suspendedTaskWithURL:(NSString *)url {
    [[ZJDownloadermanager shareInstance]suspendedTaskWithURL:url];
}

- (void)suspendedTaskWithURL:(NSString *)url {
    if (url == nil || url.length == 0) {
        return;
    }
    ZJDownloadOperation *op = self.requestOperationDict[url];
    if (op) {
        [op.dataTask suspend];
    }
}

+ (void)suspendedAllTask{
    [[ZJDownloadermanager shareInstance]suspendedAllTask];
}

/// 暂停或者继续
- (void)suspendedAllTask{
    BOOL isSuspended = self.downloadQueue.isSuspended;
    self.downloadQueue.suspended = !isSuspended;
}


/// 获取当前的operation
- (ZJDownloadOperation *)getCurrentOperationWithTask:(NSURLSessionTask *)task {
    ZJDownloadOperation *operation = nil;
    for (ZJDownloadOperation *op in self.downloadQueue.operations) {
        if (op.dataTask.taskIdentifier == task.taskIdentifier) {
            operation = op;
            break;
        }
    }
    return operation;
}


#pragma mark -NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    ZJDownloadOperation *op = [self getCurrentOperationWithTask:dataTask];
    [op URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    ZJDownloadOperation *op = [self getCurrentOperationWithTask:dataTask];
    [op URLSession:session dataTask:dataTask didReceiveData:data];
}


#pragma mark -NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    ZJDownloadOperation *op = [self getCurrentOperationWithTask:task];
    [op URLSession:session task:task didCompleteWithError:error];
}


#pragma mark -文件操作
+ (NSError *)syncWriteFile:(NSString *_Nonnull)filePath fileData:(NSData *)data {
    return [ZJFileManager writeFile:filePath fileData:data];
}

+ (NSData *)syncQueryFileWithURL:(NSString *_Nonnull)url type:(KXAttachmentType)type{
    return [ZJFileManager queryFileWithURL:url type:type];
}


+ (void)removeFileWithType:(KXAttachmentType)type {
    [ZJFileManager removeFileWithType:type];
}

+ (void)removeFileWithURL:(NSString *_Nonnull)url type:(KXAttachmentType)type {
    [ZJFileManager removeFileWithURL:url type:type];
}

+ (void)removeAllFile {
    [ZJFileManager removeAllFile];
}

+ (NSString *)getAttatchFilePathWithURL:(NSString *_Nonnull)url type:(KXAttachmentType)type {
    return [ZJFileManager getAttatchFilePathWithURL:url type:type];
}


+ (float)getAttchmentFileSizeAtPath:(NSString *_Nonnull)path {
    return [ZJFileManager getAttchmentFileSizeAtPath:path];
}

+ (float)totalFileSize {
    return [ZJFileManager totalFileSize];
}

+ (void)moveAndDeleteFilesWithPath:(NSString *)sourcePath type:(KXAttachmentType)type
{
    return [ZJFileManager moveFilesWithPath:sourcePath type:type isDeleteSourceFile:YES];
}


+ (void)moveFilesWithPath:(NSString *)sourcePath type:(KXAttachmentType)type
{
    return [ZJFileManager moveFilesWithPath:sourcePath type:type isDeleteSourceFile:NO];
}

@end
