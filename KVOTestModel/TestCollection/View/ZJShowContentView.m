//
//  ZJShowContentView.m
//  KVOTestModel
//
//  Created by zj on 2021/9/10.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJShowContentView.h"
#import "ZJSmallOneCell.h"
@interface ZJShowContentView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic) UICollectionView *contentCollectionView;

@end

@implementation ZJShowContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpCollection];
    }
    return self;
}

- (void)setUpCollection{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 5);
    flowLayout.itemSize = CGSizeMake(70, 200);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _contentCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _contentCollectionView.backgroundColor = [UIColor clearColor];
    [_contentCollectionView registerClass:[ZJSmallOneCell class] forCellWithReuseIdentifier:@"ZJSmallOneCell"];
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.showsVerticalScrollIndicator = NO;
    _contentCollectionView.pagingEnabled = YES;
    _contentCollectionView.dataSource = self;
    [self addSubview:_contentCollectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arc4random_uniform(8) + 3;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZJSmallOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJSmallOneCell" forIndexPath:indexPath];
    
    return cell;
}


@end
