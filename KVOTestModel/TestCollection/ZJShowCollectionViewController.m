//
//  ZJShowCollectionViewController.m
//  KVOTestModel
//
//  Created by zj on 2021/9/9.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJShowCollectionViewController.h"
#import "ZJFullBigCell.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface ZJShowCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic) UICollectionView *contentCollectionView;

@end

@implementation ZJShowCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"collectionView测试";
    [self setUpCollection];
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
