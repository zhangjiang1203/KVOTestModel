//
//  DownloadViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/7.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "DownloadViewController.h"
#import "ZJDownloadermanager.h"
@interface DownloadViewController ()

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadFile];
}

- (void)downloadFile{
    NSArray * paramArr = @[
        @"https://img.17kuxiu.com/gift/cartoon/cartoon20210422095811.mp4",
        @"https://img.17kuxiu.com/gift/cartoon/cartoon20200904175749.svga",
        @"https://img.17kuxiu.com/gift/cartoon/cartoon20200901161214.mp4",
        @"https://img.17kuxiu.com/gift/cartoon/cartoon20210327132330.mp4",
        @"https://img.17kuxiu.com/gift/cartoon/cartoon20210416152320.mp4",

        @"https://img.17kuxiu.com/gift/cartoon/cartoon20200910155749.mp4",
        @"http://img.17kuxiu.com/gift/cartoon/cartoon20190625200856.svga",
        @"https://img.17kuxiu.com/gift/cartoon/cartoon20210225191110.svga",
        @"https://img.17kuxiu.com/gift/cartoon/cartoon20201116172804.mp4",
        @"https://img.17kuxiu.com/gift/cartoon/cartoon20201116172732.mp4",

        @"https://img.17kuxiu.com/gift/cartoon/cartoon20210201173746.mp4",
        @"https://img.17kuxiu.com/gift/cartoon/cartoon20200608154748.svga",
        @"https://img.17kuxiu.com/gift/cartoon/cartoon20201116172616.mp4",
    ];
    for (NSString *url in paramArr) {

        [ZJDownloadermanager downloadFileWithURL:url priority:(KXDownloadPriority_LIFO) progress:^(CGFloat present, NSString * _Nullable url) {
//            NSLog(@"当前下载进度===%.2f,url=%@",present,[url lastPathComponent]);
        } completed:^(ZJDownloadModel * _Nullable attachment, NSError * _Nullable error) {
            NSLog(@"下载成功===%@==%f",[attachment.url lastPathComponent],[ZJDownloadermanager getAttchmentFileSizeAtPath:attachment.filePath]);
        }];
    }
    
    ZJDownloadModel *model = [ZJDownloadermanager downloadModelWithURL:@"https://img.17kuxiu.com/gift/cartoon/cartoon20201116172616.mp4"];
    [model addObserver:self forKeyPath:@"state" options:(NSKeyValueObservingOptionNew) context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"]) {
        NSLog(@"开始变化===%@",change);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
