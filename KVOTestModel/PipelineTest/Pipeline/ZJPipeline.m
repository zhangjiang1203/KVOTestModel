//
//  ZJPipeline.m
//  ZJFoundation
//
//  Created by 三井 on 2020/1/15.
//

#import "ZJPipeline.h"
#import "ZJPipeline+Input.h"
#import "ZJPipeline+Filter.h"
#import <objc/runtime.h>

@interface ZJPipelineBatch ()

/// 产品所在的流水线
@property (nonatomic, weak) ZJPipeline *locatePipeline;
- (void)consumed;

@end

@interface ZJPipeline ()

@property (nonatomic, strong) ZJPipelineBatch *bufferBatch;
@property (nonatomic, strong) NSMutableArray *mArr;

@property (nonatomic, weak) id<ZJPipelineInputProtocol> input;
@property (nonatomic, strong) NSMutableArray<id<ZJPipelineFilterProtocol>> *filters;

/// 列表操作同步
@property (nonatomic, strong) dispatch_semaphore_t arrOperationLock;
/// 排队同步
@property (nonatomic, strong) dispatch_semaphore_t mutex;
/// 产品数量同步控制
@property (nonatomic, strong) dispatch_semaphore_t product;
@end

@implementation ZJPipeline

+ (ZJPipeline *)pipelineWithAction:(void (^)(ZJPipelineBatch * _Nonnull))action {
    ZJPipeline *pipeline = [[ZJPipeline alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 加个名字，方便调试
        NSThread.currentThread.name = @"tv.douyu.pipeline";
        for (ZJPipelineBatch *obj in pipeline) {
            action(obj);
            [obj consumed];
        }
        NSLog(@"结束");
    });
    return pipeline;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _batchSize = 1;
        _mArr = [NSMutableArray arrayWithObject:[NSNull null]];
        _filters = [NSMutableArray array];
        
        _arrOperationLock = dispatch_semaphore_create(1);
        _mutex = dispatch_semaphore_create(1);
        _product = dispatch_semaphore_create(0);
    }
    return self;
}

- (void)addFilter:(id<ZJPipelineFilterProtocol>)filter {
    NSInteger priority = 0;
    if ([filter respondsToSelector:@selector(filterPriority)]) {
        priority = filter.filterPriority;
    }
    
    // 加锁
    dispatch_semaphore_wait(self.arrOperationLock, DISPATCH_TIME_FOREVER);
    NSInteger index = [self.filters indexOfObjectPassingTest:^BOOL(id<ZJPipelineFilterProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger objPriority = 0;
        if ([obj respondsToSelector:@selector(filterPriority)]) {
            objPriority = obj.filterPriority;
        }
        
        return objPriority > priority;
    }];
    if (index != NSNotFound) {
        [self.filters insertObject:filter atIndex:index];
    } else {
        [self.filters addObject:filter];
    }
    dispatch_semaphore_signal(self.arrOperationLock);
}

- (void)removeFilter:(id<ZJPipelineFilterProtocol>)filter {
    dispatch_semaphore_wait(self.arrOperationLock, DISPATCH_TIME_FOREVER);
    [self.filters removeObject:filter];
    dispatch_semaphore_signal(self.arrOperationLock);
}

- (void)produce:(NSObject *)object {
    if (object) {
        [self insertProduct:object];
    }
}

- (NSObject *)process:(NSObject *)object {
    NSObject *rs = object;
    
    dispatch_semaphore_wait(self.arrOperationLock, DISPATCH_TIME_FOREVER);
    NSArray *filters = [self.filters copy];
    dispatch_semaphore_signal(self.arrOperationLock);
    
    for (id<ZJPipelineFilterProtocol> filter in filters) {
        rs = [filter pipelineFilter:rs];
        if (!rs) {
            break;
        }
    }
    return rs;
}

- (void)consumed {
    self.bufferBatch = nil; // 使用完后，立即释放
    dispatch_semaphore_signal(self.mutex);
}

- (void)clean {
    // 该方法会清除数据，使用countByEnumeratingWithState中相同的锁结构，只等待20ms。
    intptr_t getLock = dispatch_semaphore_wait(self.mutex, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_MSEC * 20));
    
    if (getLock != 0) {
        // 如果没有请求到锁，说明流水线的正常‘消费’也在等待生产锁，缓冲区中没有数据，直接返回
    } else {
        // 数组操作锁
        dispatch_semaphore_wait(self.arrOperationLock, DISPATCH_TIME_FOREVER);
        
        // 仅留下最后一个哨兵
        if (self.mArr.count > 1) {
            NSRange range = NSMakeRange(0, self.mArr.count - 1);
            [self.mArr removeObjectsInRange:range];
        }
        
        dispatch_semaphore_signal(self.arrOperationLock);
        
        dispatch_semaphore_signal(self.mutex);
    }
}

- (void)destroy {
    self.bufferBatch = nil;
    dispatch_semaphore_wait(self.arrOperationLock, DISPATCH_TIME_FOREVER);
    [self.filters removeAllObjects];
    dispatch_semaphore_signal(self.arrOperationLock);
    dispatch_semaphore_signal(self.product);
    dispatch_semaphore_signal(self.mutex);  // 还原为1
}

- (void)dealloc {
    self.arrOperationLock = nil;
    self.mutex = nil;
    self.product = nil;
}

- (NSUInteger)countByEnumeratingWithState:(nonnull NSFastEnumerationState *)state objects:(__unsafe_unretained id  _Nullable * _Nonnull)buffer count:(NSUInteger)len {
    if (state->state == 0) {
        state->extra[0] = 0;
        state->mutationsPtr = &state->extra[0];
        state->state = 1;
    }
    
    ZJPipelineBatch *object = nil;
    do {@autoreleasepool {
        // 如果没有更多产品了，并且有被动生产者，则主动取值
        if (self.mArr.count <= 1 && self.input) {
            NSObject *object = [self.input produceFor:self];
            if (object) {
                [self produce:object];
            }
        }
        
        dispatch_semaphore_wait(self.mutex, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.product, DISPATCH_TIME_FOREVER);
        
        dispatch_semaphore_wait(self.arrOperationLock, DISPATCH_TIME_FOREVER);
        NSRange range = NSMakeRange(0, MIN(self.batchSize, self.mArr.count - 1));
        dispatch_semaphore_signal(self.arrOperationLock);
        
        if (range.length == 0) {
            return 0;
        }
        
        // 取出产品
        for (NSInteger i = 0; i < range.length - 1; i++) {
            dispatch_semaphore_wait(self.product, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_semaphore_wait(self.arrOperationLock, DISPATCH_TIME_FOREVER);
        NSArray<NSObject *> *batchObjects = [self.mArr subarrayWithRange:range];
        [self.mArr removeObjectsInRange:range];
        dispatch_semaphore_signal(self.arrOperationLock);
        
        NSMutableArray<NSObject *> *mFilteredArr = [NSMutableArray array];
        
        dispatch_semaphore_wait(self.arrOperationLock, DISPATCH_TIME_FOREVER);
        NSArray *filters = [self.filters copy];
        dispatch_semaphore_signal(self.arrOperationLock);
        
        for (NSInteger i = 0; i < batchObjects.count; i++) {
            NSObject *filterObj = batchObjects[i];
            for (id<ZJPipelineFilterProtocol> filter in filters) {
                filterObj = [filter pipelineFilter:filterObj];
                
                if (!filterObj) {
                    break;
                }
            }
            if (filterObj) {
                [mFilteredArr addObject:filterObj];
            }
        }
        
        if (mFilteredArr.count == 0) {
            ZJPipelineBatch *batch = [ZJPipelineBatch new];
            self.bufferBatch = batch;
            object = batch;
        } else {
            ZJPipelineBatch *batch = [[ZJPipelineBatch alloc] init];
            batch.objects = mFilteredArr;
            self.bufferBatch = batch;
            object = batch;
        }
        
        object.locatePipeline = self;
    }} while (!object);
    
    state->itemsPtr = buffer;
    *buffer = object;
    return 1;
}

#pragma mark - Private
- (void)insertProduct:(NSObject *)object {
    dispatch_semaphore_wait(self.arrOperationLock, DISPATCH_TIME_FOREVER);
    NSUInteger index = self.mArr.count - 1;
    [self.mArr insertObject:object atIndex:index];
    dispatch_semaphore_signal(self.arrOperationLock);
    
    dispatch_semaphore_signal(self.product);
}
@end

#pragma mark -
@implementation ZJPipelineBatch

- (void)dealloc {
    _objects = nil;
}

- (void)consumed {
    [self.locatePipeline consumed];
}

@end
