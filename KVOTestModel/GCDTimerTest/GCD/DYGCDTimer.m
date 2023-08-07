//
//  DYGCDTimer.m
//  GCD
//
//  http://home.cnblogs.com/u/YouXianMing/
//  https://github.com/YouXianMing
//
//  Created by XianMingYou on 15/3/15.
//  Copyright (c) 2015年 XianMingYou. All rights reserved.
//

#import "DYGCDTimer.h"
#import "GCDQueue.h"

@interface DYGCDTimer ()

@property (strong, readwrite, nonatomic) dispatch_source_t dispatchSource;

@property (nonatomic, strong) GCDQueue *queue;

@end

@implementation DYGCDTimer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.queue = [GCDQueue globalQueue];
        self.dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue.dispatchQueue);
    }
    return self;
}

- (instancetype)initInQueue:(GCDQueue *)queue {
    self = [super init];
    if (self) {
        self.queue = queue;
        self.dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue.dispatchQueue);
    }
    return self;
}

- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, delaySecs * NSEC_PER_SEC), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)start {
    if(!self.dispatchSource){
        self.dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue.dispatchQueue);
    }
    dispatch_resume(self.dispatchSource);
}

- (void)destroy {
    
    dispatch_source_cancel(self.dispatchSource);
    self.dispatchSource = nil;
}

@end
