//
//  ZJDownloadOperation.m
//  NSOperationTest
//
//  Created by zhangjiang on 2021/4/30.
//

#import "ZJDownloadOperation.h"
#import "ZJDownloadermanager.h"
#import "ZJFileManager.h"
//保存回调设置信息
static NSString *const kProgressKey = @"progressKey";
static NSString *const kCompletedKey = @"completedKey";
typedef NSMutableDictionary<NSString *,id> ZJCallBackDict;


@interface ZJDownloadOperation ()
{
    void *synchQueueTag;
}
@property (nonatomic, assign, getter=isFinished) BOOL finished;

@property (nonatomic,assign,getter=isExecuting) BOOL executing;

@property (nonatomic,strong) NSLock *lock;

/// 外界传入的session，如果在外界被释放了，下面的请求不会再执行
@property (nonatomic,weak) NSURLSession *unownSession;
/// 保证自己实现session
@property (nonatomic,strong) NSURLSession *ownSession;
/// 创建的任务
@property (nonatomic,strong,nullable) NSURLSessionTask *dataTask;
/// 创建队列
@property (nonatomic,strong)dispatch_queue_t barrierQueue;

/// 保存对应回调
@property (nonatomic,strong) NSMutableArray<ZJCallBackDict *> *callBackArr;

@property (nonatomic,strong) ZJDownloadModel *attachmentModel;

@property (nonatomic,strong) ZJFileManager *fileManager;

@end



@implementation ZJDownloadOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (ZJDownloadModel *)attachmentModel{
    if (!_attachmentModel) {
        _attachmentModel = [ZJDownloadermanager downloadModelWithURL:self.request.URL.absoluteString];
    }
    return _attachmentModel;
}


- (instancetype)initWithSession:(NSURLSession *)session request:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        self.lock = [NSLock new];
        self.request = request;
        self.unownSession = session;
        self.finished = NO;
        self.executing = NO;
        self.callBackArr = [NSMutableArray array];
        self.fileManager = [ZJFileManager new];
        
        self.barrierQueue = dispatch_queue_create("com.kx.download.operation", DISPATCH_QUEUE_CONCURRENT);
        synchQueueTag = &synchQueueTag;
        dispatch_queue_set_specific(self.barrierQueue, synchQueueTag, synchQueueTag, NULL);
    }
    return self;
}

#pragma mark -添加对应的progress和completed回调
- (id)addHandlerWithProgress:(nullable KXProgressBlock)progressBlock completed:(nullable KXCompletedBlock)completedBlock {
    ZJCallBackDict *callBackDict = [NSMutableDictionary dictionary];
    if (progressBlock) callBackDict[kProgressKey] = progressBlock;
    
    if (completedBlock) callBackDict[kCompletedKey] = completedBlock;
    
    dispatch_barrier_sync(self.barrierQueue, ^{
        [self.callBackArr addObject:callBackDict];
    });
    
    return callBackDict;
}

#pragma mark -获取对应的progress和completed回调
- (NSArray *)callBackHandlerForKey:(NSString *)key {
    __block NSMutableArray *handlers = [NSMutableArray array];
    [self executeBlock:^{
        handlers = [[self.callBackArr valueForKey:key] mutableCopy];
        //去除null
        [handlers removeObjectIdenticalTo:[NSNull null]];
    }];
    return handlers;
}


#pragma mark -实现nsoperationQueue要从重写的方法
- (void)start {
    [self.lock lock];
    if (self.isCancelled) {
        self.finished = YES;
        return;
    }
    //模拟网络请求开始执行
    NSURLSession *session = self.unownSession;
    if (!self.unownSession) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 15;

        session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        self.ownSession = session;
    }
    self.dataTask = [session dataTaskWithRequest:self.request];
    self.executing = YES;
    [self.lock unlock];
    
    //开始请求
    [self.dataTask resume];
    
    if (self.dataTask) {
        for (KXProgressBlock pro in [self callBackHandlerForKey:kProgressKey]) {
            pro(0,self.request.URL.absoluteString);
        }
        [self.attachmentModel setState:(KXDownloadState_Downloading)];
    }else{
        [self dealWithCompletedResult:[NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"连接初始化失败"}]];
    }
}

- (void)dealWithCompletedResult:(NSError *)error {
    [self.attachmentModel setState:error == nil ? KXDownloadState_Completed : KXDownloadState_Failed];
    
    //成功回调
    NSArray *comArr = [self callBackHandlerForKey:kCompletedKey];
    //成功之后的回调
    dispatch_async(dispatch_get_main_queue(), ^{
        for (KXCompletedBlock com in comArr) {
            com(self.attachmentModel,error);
        }
        
        if (self.attachmentModel.successBlock) {
            self.attachmentModel.successBlock(self.attachmentModel, error);
        }
    });
}


- (void)cancel{
    [self.lock lock];
    if (self.isFinished) {
        return;
    }
    [super cancel];
    if (self.dataTask) {
        [self.dataTask cancel];
        [self.attachmentModel setState:(KXDownloadState_None)];
    }
    if (self.isExecuting) self.executing = NO;
    if (!self.isFinished) self.finished = YES;
    [self reset];
    [self.lock unlock];
}

- (void)setFinished:(BOOL)finished{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark -设置展示状态
- (void)done{
    self.finished = YES;
    self.executing = NO;
    //重置各种状态
    
}

- (void)reset{
    dispatch_barrier_sync(self.barrierQueue, ^{
        [self.callBackArr removeAllObjects];
    });
    self.dataTask = nil;
    if (self.ownSession) {
        [self.ownSession invalidateAndCancel];
        self.ownSession = nil;
    }
}


#pragma mark -URLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    [self.attachmentModel setTotalSize:self.attachmentModel.currentSize + dataTask.countOfBytesExpectedToReceive];
    //开始下载任务，修改任务对应的状态
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [ZJFileManager writeFile:self.attachmentModel.filePath fileData:data];
    
    self.attachmentModel.progress.totalUnitCount = self.attachmentModel.totalSize;
    self.attachmentModel.progress.completedUnitCount = self.attachmentModel.currentSize;
    //更新当前的进度
    dispatch_async(dispatch_get_main_queue(), ^{
        for (KXProgressBlock pro in [self callBackHandlerForKey:kProgressKey]) {
            pro(self.attachmentModel.progress.fractionCompleted,self.request.URL.absoluteString);
        }
        if (self.attachmentModel.progressBlock) {
            self.attachmentModel.progressBlock(self.attachmentModel.currentSize/self.attachmentModel.totalSize, self.request.URL.absoluteString);
        }
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    //任务执行完毕置为nil
    [self.lock lock];
    self.dataTask = nil;
    [self.lock unlock];
    if(error){
        [self dealWithCompletedResult:error];
    }else{
        [self.attachmentModel setState:KXDownloadState_Completed];
        if ([self callBackHandlerForKey:kCompletedKey].count > 0) {
            [self dealWithCompletedResult:error];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.attachmentModel.successBlock) {
                self.attachmentModel.successBlock(self.attachmentModel, error);
            }
        });
    }
    //任务执行完毕
    [self done];
    
}

- (void)executeBlock:(dispatch_block_t)block {
    if (dispatch_get_specific(synchQueueTag))
        block();
    else
        dispatch_sync(self.barrierQueue, block);
}

@end
