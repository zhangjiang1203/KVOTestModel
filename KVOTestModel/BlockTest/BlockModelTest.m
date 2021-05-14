//
//  BlockModelTest.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/1/28.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "BlockModelTest.h"

typedef void(^blk_t)(void);

@interface BlockModelTest ()
{
    blk_t blk_;
}

@property (nonatomic,strong) NSMutableArray *tempArr;

@end

@implementation BlockModelTest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tempArr = [NSMutableArray array];
        blk_ = ^{
//            NSLog(@"self = %@",self);
        };
    }
    return self;
}


- (int)testBlockData:(int)data {
    
    int a = 20;
    __weak typeof(self) weakSelf = self;
    int (^TestBlock)(int) = ^(int data){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"捕获的变量==%d",a);
        [strongSelf.tempArr addObject:@"你好"];
        return data + 20;
    };
    a += 30;
    
    return TestBlock(10);
}


-(void) createDispatchQueue{
    
    //当dispatch_queue_create第二个参数为NULL和DISPATCH_QUEUE_SERIAL时 返回队列就是串行队列
    
    for (int i = 0; i< 30; i++) {
        dispatch_queue_t queue = dispatch_queue_create("concurrent queue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            NSLog(@"当前的执行====%d",i);
        });
    }
    
    for (int i = 0; i< 30; i++) {
        dispatch_queue_t queue = dispatch_queue_create("concurrent queue", NULL);
        dispatch_async(queue, ^{
            NSLog(@"当前的执行====%d",i);
        });
    }
}

/**
 dispatch_set_target_queue: 1.改变队列的优先级  2.防止多个串行队列的并发执行
 
 dispatch_queue_t queue = dispatch_queue_create("queue",NULL);
 dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0)
 
 //第一个参数：需要改变优先级的队列
 //第二个参数：目标队列
 dispatch_set_target_queue(queue,bgQueue);
 ```
 //多个串行队列，设置了target queue
 NSMutableArray *array = [NSMutableArray array];
 dispatch_queue_t serial_queue_target = dispatch_queue_create("queue_target", NULL);

 for (NSInteger index = 0; index < 5; index ++) {
     //分别给每个队列设置相同的target queue
     dispatch_queue_t serial_queue = dispatch_queue_create("serial_queue", NULL);
     dispatch_set_target_queue(serial_queue, serial_queue_target);
     [array addObject:serial_queue];
 }
     
 [array enumerateObjectsUsingBlock:^(dispatch_queue_t queue, NSUInteger idx, BOOL * _Nonnull stop) {
     dispatch_async(queue, ^{
         NSLog(@"任务%ld",idx);
     });
 }];
 ```
 
 dispatch_after：某个线程中，在指定的时间后处理某个任务
 //指定的时间，追加到队列中，并不是指定时间后处理任务，如果这个队列本身还有延迟，这个block的延迟会更多
 
 
 dispatch_group：全部处理完多个预处理任务后执行某个任务
 1.预处理任务一个接一个的执行，将所有需要先处理完的任务追加到serial Diapatch Queue中，并在最后追加最后处理的任务
 2.如果预处理任务需要并发执行：需要使用dispatch_group函数，将这些预处理的block追加到global dispatch queue中
 
 dispatch_group_notify函数监听传入的group中任务的完成，等这些任务全部执行以后，再将第三个参数追加到第二个参数的queue中
 
 dispatch_group_wait: 也是配合dispatch_group使用的，利用这个函数，我们可以设定group内部所有任务执行完成的超时时间
 经过了函数中指定的超时时间后，group内部的任务没有全部完成，判定为超时，否则，没有超时
 指定的group内的任务全部执行后，经过的时间长于超时时间，判定为超时，否则，没有超时
 */
-(void)dispatch_wait_1{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 5; i++) {
        dispatch_group_async(group, queue, ^{
            for (int j = 0; j < 100000; j++) {
                
            }
        });
        NSLog(@"任务%d完成",i);
    }
    
    //设置group超时时间
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
    long result = dispatch_group_wait(group, time);
    if (result == 0) {
        NSLog(@"group中的队列任务都完成了==");
    }else{
        NSLog(@"group中任务超时");
    }
}

/**
 dispatch_barrier_async
 数据竞争：读取数据是可以并发执行的，但是写入处理却不允许并发执行
 1.读取处理追加到concurrent dispatch queue中
 2.写入处理在任何一个读取处理没有执行状态下，追加到serial dispatch queue中(在写处理完成之前，读取处理不执行)
 
 为了帮助大家理解，我构思了一个例子：

 3名董事和总裁开会，在每个人都查看完合同之后，由总裁签字。
 总裁签字之后，所有人再审核一次合同。
 这个需求有三个关键点：

 关键点1：所有与会人员查看和审核合同，是同时进行的，无序的行为。
 关键点2：只有与会人员都查看了合同之后，总裁才能签字。
 关键点3: 只有总裁签字之后，才能进行审核。

 */
-(void)dispatch_barrier{
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"总裁查看合同");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"董事1查看合同");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"董事2查看合同");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"董事3查看合同");
    });
    //上面的步骤都完成之后才会执行下面的逻辑，使用dispatch_barrier_async以后之前的所有的并发任务都会被dispatch_barrier_async里的任务拦截掉，像一个栅栏一样
    dispatch_barrier_async(queue, ^{
        NSLog(@"总裁签字");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"总裁审核合同");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"董事1审核合同");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"董事2审核合同");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"董事3审核合同");
    });
}

/**
 dispatch_apply：按照指定次数将block追加到指定的队列中，并等待全部处理执行结束，该函数具有阻塞作用，
 //可以用来遍历数组  使用数组的count 指定次数
 */
-(void)dispatch_apply_1{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_apply(10, queue, ^(size_t index) {
        NSLog(@"函数开始执行的次数==%ld",index);
    });
    NSLog(@"执行完毕");
}

/**
 dispatch_suspend/dispatch_resume  挂起函数调用对已经执行的处理没有影响，但是追加到队列中尚未执行的处理会在此之后停止执行
 dispatch_suspend(queue);
 dispatch_resume(queue);
 */


/**
 dispatch_once 代码只会执行一次，而且是线程安全的
 */
@end
