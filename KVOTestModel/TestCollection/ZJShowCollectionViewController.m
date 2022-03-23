//
//  ZJShowCollectionViewController.m
//  KVOTestModel
//
//  Created by zj on 2021/9/9.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJShowCollectionViewController.h"
#import "ZJFullBigCell.h"
#import <libpag/PAGView.h>

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface ZJShowCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic) UICollectionView *contentCollectionView;

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, copy) NSString *testStr;

@end

@implementation ZJShowCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"collectionView测试";
    self.queue = dispatch_queue_create("showTest", DISPATCH_QUEUE_CONCURRENT);
    [self showStringTest];
//    [self setUpCollection];
//    [self showTestCollection];
}

- (void)showStringTest{
    
//    for (int i = 0; i< 10000; i++) {
//        dispatch_async(self.queue, ^{
//            self.testStr = [NSString stringWithFormat:@"nihao"];
//            NSLog(@"%@",self.testStr);
//        });
//    }
    
    for (int i = 0; i< 10000; i++) {
        dispatch_async(self.queue, ^{
            self.testStr = [NSString stringWithFormat:@"nihao 一二三我来了哈哈哈"];
            NSLog(@"%@",self.testStr);
        });
    }
    
}

- (void)showTestCollection{
//    for (int i = 0; i < 100000; i++) {
//        NSString *name = [[NSString alloc]initWithFormat:@"show name %zd",i];
//        NSLog(@"开始打印====%@",name);
//    }
    
//    for (int i = 0; i < 100000; i++) {
//        @autoreleasepool {
//            NSString *name = [[NSString alloc]initWithFormat:@"show name %zd",i];
//            NSLog(@"开始打印====%@",name);
//        }
//    }
//    
    for (int i = 0; i < 100000; i++) {
        @autoreleasepool {
            UIImage *name = [[UIImage alloc]init];//:@"searchbar_search"];
            NSLog(@"开始打印====%@",name);
        }
    }

}

- (void)setUpCollection{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(kWidth, 200);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 5);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, kWidth, 200) collectionViewLayout:flowLayout];
    _contentCollectionView.backgroundColor = [UIColor clearColor];
    [_contentCollectionView registerClass:[ZJFullBigCell class] forCellWithReuseIdentifier:@"ZJFullBigCell"];
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.showsVerticalScrollIndicator = NO;
    _contentCollectionView.pagingEnabled = YES;
    _contentCollectionView.dataSource = self;
    [self.view addSubview:_contentCollectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZJFullBigCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJFullBigCell" forIndexPath:indexPath];
    
    return cell;
}

@end
