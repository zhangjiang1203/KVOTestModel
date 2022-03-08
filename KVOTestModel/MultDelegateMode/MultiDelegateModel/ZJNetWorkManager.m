//
//  ZJNetWorkManager.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/6/21.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJNetWorkManager.h"

@interface ZJNetWorkManager ()
{
    //使用C语言中的位段 特性，缓存对象是否实现了协议中的某个方法的信息 定义1 取值在0-1， 2 取值0-2^2 -1  定义为8 0-2^8-1
    struct{
        unsigned int didReceiveData      : 1;
        unsigned int didFailWithError    : 1;
        unsigned int didUpdateProgress   : 1;
        unsigned int shouldReloadRequest : 1;
    } _delegateFlags;
}

@end

@implementation ZJNetWorkManager

- (void)setDelegate:(id<ZJNetWorkManagerDelegate>)delegate {
    _delegate = delegate;
    //缓存委托对象是否实现了协议中的某个方法,只需要在设置代理的这个方法中做一次判断就好
    _delegateFlags.didReceiveData = [delegate respondsToSelector:@selector(netWorkManager:didReceiveData:)];
    _delegateFlags.didFailWithError = [delegate respondsToSelector:@selector(netWorkManager:didFailWithError:)];
    _delegateFlags.didUpdateProgress = [delegate respondsToSelector:@selector(netWorkManager:didUpdateProgress:)];
}

//执行网络请求展示的数据详情
- (void)netResponse:(NSData *)data{
    if (_delegateFlags.didReceiveData) {
        [self.delegate netWorkManager:self didReceiveData:data];
    }
}


- (void)netProgressResponse:(NSProgress *)progress{
    if (_delegateFlags.didUpdateProgress) {
        [self.delegate netWorkManager:self didUpdateProgress:progress];
    }
}

- (void)responseFailedWithError:(NSError *)error{
    if (_delegateFlags.didFailWithError) {
        [self.delegate netWorkManager:self didFailWithError:error];
    }
}

//判断请求失败是否要重试
- (void)reponseFailRetry{
    BOOL isTry = NO;
    if (_delegateFlags.shouldReloadRequest) {
        isTry = [self.delegate netWorkManagerShouldReloadRequest:self];
    }
    //开始执行对应的重试逻辑
    
}



@end
