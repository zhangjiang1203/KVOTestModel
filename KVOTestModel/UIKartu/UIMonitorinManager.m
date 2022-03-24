//
//  UIMonitorinManager.m
//  searchPathProject
//
//  Created by zhangjiang on 2020/9/2.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "UIMonitorinManager.h"
#import "YZCallStack.h"
#import <execinfo.h>

@interface UIMonitorinManager (){
    int timeoutCount;
    CFRunLoopObserverRef observerRef;
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}

@end

@implementation UIMonitorinManager

static void  runLoopObserverCallback(CFRunLoopObserverRef observer,CFRunLoopActivity activity,void *info){
    UIMonitorinManager *monitor = (__bridge UIMonitorinManager*)info;
    //记录状态值
    monitor->activity = activity;
    
    //发送信号量
    dispatch_semaphore_t semaphore = monitor->semaphore;
    long st = dispatch_semaphore_signal(semaphore);
//    NSLog(@"dispatch_semaphore_signal:st=%ld,time:%@",st,[UIMonitorinManager getCurTime]);
//    switch (activity) {
//        case kCFRunLoopEntry:
//            NSLog(@"runLoopObserverCallback---kCFRunLoopEntry");
//            break;
//        case kCFRunLoopBeforeTimers:
//            NSLog(@"runLoopObserverCallback---kCFRunLoopBeforeTimers");
//            break;
//        case kCFRunLoopBeforeSources:
//            NSLog(@"runLoopObserverCallback---kCFRunLoopBeforeSources");
//            break;
//        case kCFRunLoopBeforeWaiting:
//            NSLog(@"runLoopObserverCallback---kCFRunLoopBeforeWaiting");
//            break;
//        case kCFRunLoopExit:
//            NSLog(@"runLoopObserverCallback---kCFRunLoopExit");
//            break;
//        case kCFRunLoopAllActivities:
//            NSLog(@"runLoopObserverCallback---kCFRunLoopAllActivities");
//            break;
//        default:
//            break;
//    }
    
}


+ (instancetype)shareInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

-(void)startMonitorWithKey:(NSString*)key{
    
    //判断环境开始监控
#ifndef DEBUG
    
#else
    if (observerRef) {
        return;
    }
    /**
     dispatch_semaphore_create(long value); // 创建信号量
     dispatch_semaphore_signal(dispatch_semaphore_t deem); // 发送信号量
     dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout); // 等待信号量
     dispatch_semaphore_create(long value);和GCD的group等用法一致，
     这个函数是创建一个dispatch_semaphore_类型的信号量，并且创建的时候需要指定信号量的大小。
     dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout); 等待信号量。该函数会对信号量进行减1操作。如果减1后信号量小于0（即减1前信号量值为0），那么该函数就会一直等待，也就是不返回（相当于阻塞当前线程），直到该函数等待的信号量的值大于等于1，该函数会对信号量的值进行减1操作，然后返回。
     dispatch_semaphore_signal(dispatch_semaphore_t deem); 发送信号量。该函数会对信号量的值进行加1操作。
     */
    //创建信号量
    semaphore = dispatch_semaphore_create(0);
//    NSLog(@"dispatch_semaphore_create at：%@",[UIMonitorinManager getCurTime]);
    
    //注册runloop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    //第一个参数用于分配observer对象的内存
    //第二个参数用以设置observer所要关注的事件，详见回调函数myRunLoopObserver中注释
    //第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
    //第四个参数用于设置该observer的优先级
    //第五个参数用于设置该observer的回调函数
    //第六个参数用于设置该observer的运行环境
    observerRef = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                          kCFRunLoopAllActivities,
                                          YES,
                                          0,
                                          &runLoopObserverCallback,
                                          &context);
    if (observerRef) {
        CFRunLoopAddObserver(CFRunLoopGetMain(), observerRef, kCFRunLoopCommonModes);
    }
    
    //在子线程监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            //假定连续五次超过50ms就认为卡顿(单次为250ms)
            //runloop状态变更回调方法中会将信号量递增加1 每次runloop状态改变之后下面的代码都会执行一次
            long st = dispatch_semaphore_wait(self->semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
//            NSLog(@"dispatch_semaphore_wait st=%ld time:%@",st,[UIMonitorinManager getCurTime]);
            if (st != 0) {
                //信号量超时了，runloop的状态长时间没有改变
                if(!self->observerRef){
                    self->timeoutCount = 0;
                    self->activity = 0;
                    self->semaphore = 0;
                    return;
                }
//                NSLog(@"st=%ld,activity=%lu,timeoutCount=%d,time=%@",st,self->activity,self->timeoutCount,[UIMonitorinManager getCurTime]);
                // kCFRunLoopBeforeSources - 即将处理source kCFRunLoopAfterWaiting - 刚从休眠中唤醒
                // 获取kCFRunLoopBeforeSources到kCFRunLoopBeforeWaiting再到kCFRunLoopAfterWaiting的状态就可以知
                // 道是否有卡顿的情况。
                // kCFRunLoopBeforeSources:停留在这个状态,表示在做很多事情
                if(self->activity == kCFRunLoopBeforeSources || self->activity == kCFRunLoopAfterWaiting){
                    if (++self->timeoutCount < 5) {
                        //不足5次 直接continue当次循环，timecount不置为0
                        continue;
                    }
//                    [self logStack];
                    NSString *backStack = [YZCallStack yz_backtraceOfMainThread];
                    //收集Crash信息，实时获取各线程的调用堆栈
                    NSLog(@"开始卡顿======%@",backStack);
                    
                }
            }
//            NSLog(@"dispatch_semaphore_wait timeoutCount = 0 time:%@",[UIMonitorinManager getCurTime]);
            self->timeoutCount = 0;
        }
        
    });
#endif
    
}

- (void)logStack
{
    NSLog(@"-%s--",__func__);
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for ( i = 0 ; i < frames ; i++ ){
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    NSLog(@"==========检测到卡顿之后调用堆栈==========\n %@ \n",backtrace);
    free(strs);
}


-(void)stopMonitorWithKey:(NSString*)key{
    
#ifndef DEBUG
#else
    if (!observerRef) {
        return;
    }
    //移除观察者
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observerRef, kCFRunLoopCommonModes);
    CFRelease(observerRef);
    observerRef = NULL;
#endif
    
}


+ (NSString *) getCurTime {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY/MM/dd hh:mm:ss:SSS"];
    NSString *curTime = [format stringFromDate:[NSDate date]];
    
    return curTime;
}

@end

//方法一 使用信号量变化监控UI卡顿
//方法二 使用NSTimer和一个常驻线程监控UI卡顿
