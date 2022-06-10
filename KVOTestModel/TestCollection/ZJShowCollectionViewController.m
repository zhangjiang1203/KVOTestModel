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
#import <Masonry/Masonry.h>

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface ZJShowCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic) UICollectionView *contentCollectionView;

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, copy) NSString *testStr;

/// 互动表情
@property (nonatomic,strong) UIImageView *emotionImageView;

@end

@implementation ZJShowCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"collectionView测试";
    self.queue = dispatch_queue_create("showTest", DISPATCH_QUEUE_CONCURRENT);
    [self createImageView];
//    [self showStringTest:1000];
//    [self showStringTest:22332];
//    [self showStringTest:453453];
//    [self showStringTest:6545342];
//    [self showStringTest:89787675];
//    [self showStringTest:234886786];
//    [self showStringTest:9678567567];
//    [self showStringTest:90787678665];
//    [self showStringTest:875765755765];
//    [self setUpCollection];
//    [self showTestCollection];
}

- (void)showStringTest:(NSInteger)score{
    
//    NSMutableString *scoreStr = [NSMutableString stringWithFormat:@"%ld",score];
//    if (score < 10000) {
//        NSLog(@"score:%zd",score);
//    }else if (score < 10 * 10000){
//        [scoreStr insertString:@"." atIndex:1];
//        NSString *str1 = [scoreStr substringToIndex:4];
//        NSLog(@"score:%@W",str1);
//
//    }else if (score < 100 * 10000){
//        [scoreStr insertString:@"." atIndex:2];
//        NSString *str1 = [scoreStr substringToIndex:4];
//        NSLog(@"score:%@W",str1);
//    }else if (score < 1000 * 10000){
//        NSString *str1 = [scoreStr substringToIndex:3];
//        NSLog(@"score:%@W",str1);
//    }else if (score < 10000 * 10000){
//        NSString *str1 = [scoreStr substringToIndex:4];
//        NSLog(@"score:%@W",str1);
//    }else{
//        NSString *sr1 = [scoreStr substringFromIndex:7];
//        NSString *str1 = [scoreStr substringToIndex:sr1.length];
//        NSLog(@"score:%@KW",str1);
//    }

    
    for (int i = 0; i< 10000; i++) {
        dispatch_async(self.queue, ^{
            self.testStr = [NSString stringWithFormat:@"nihao"];
            NSLog(@"%@",self.testStr);
        });
    }
    
    for (int i = 0; i< 10000; i++) {
        dispatch_async(self.queue, ^{
            self.testStr = [NSString stringWithFormat:@"nihao 一二三我来了哈哈哈"];
            NSLog(@"%@",self.testStr);
        });
    }
    
//    for (int i = 0; i < 100000;i++) {
//        @autoreleasepool {
//
////            NSString *tempStr = [NSString stringWithFormat:@"测试==%d",i];
////            NSLog(@"%@",tempStr);
//            ZJFullBigCell * cell = [ZJFullBigCell new];
//            NSLog(@"%@",cell);
//
//        }
//    }
    
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

- (UIView *)getSuperView:(UIView *)viewA viewB:(UIView *)viewB{
    UIView *a = viewA;
    UIView *b = viewB;
    UIView *superView = nil;
    NSMutableArray *arrayA = @[].mutableCopy;
    while (a.superview) {
        [arrayA addObject:a.superview];
        a = a.superview;
    }
    NSMutableArray *arrayB = @[].mutableCopy;
    while (b.superview) {
        [arrayB addObject:a.superview];
        b = b.superview;
    }
    for (int i = 0; i < arrayA.count - 1; i++) {
        UIView *a1 = arrayA[i];
        for (int j = 0; j < arrayB.count - 1; j++) {
            UIView *b1 = arrayB[i];
            if (a1 == b1) {
                superView = a1;
                break;
            }
        }
    }
    return superView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSInteger index = arc4random_uniform(8)+101;
    [self startPlayFacialAnimationWithId:[NSString stringWithFormat:@"%zd",index]];
}

- (void)startPlayFacialAnimationWithId:(NSString *)facialId{
    NSDictionary *dict = @{@"101":@"zt_facial_colour_",
                           @"102":@"zt_facial_angry_",
                           @"103":@"zt_facial_like_",
                           @"104":@"zt_facial_handclap_",
                           @"105":@"zt_facial_cheer_",
                           @"106":@"zt_facial_dizzy_",
                           @"107":@"zt_facial_dog_",
                           @"108":@"zt_facial_clink_",
                           @"109":@"zt_facial_shit_",
    };
    if (![dict.allKeys containsObject:facialId]) {
        return;
    }
    [self.emotionImageView stopAnimating];
    [self createImageView];
    NSLog(@"开始执行动画====");
    NSString *imagePre = dict[facialId];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 1; i < 49; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",imagePre,i]];
        if (image) {
            [imageArr addObject:image];
        }
    }
    self.emotionImageView.animationDuration = imageArr.count * 0.04;
    self.emotionImageView.animationImages = imageArr;
    NSLog(@"开始执行动画====count:%zd",imageArr.count);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.emotionImageView startAnimating];
//    });
}

- (void)createImageView{
    //添加表情
    if (_emotionImageView) {
        [_emotionImageView stopAnimating];
        _emotionImageView = nil;
    }
    _emotionImageView = [UIImageView new];
    [self.view addSubview:_emotionImageView];
    self.emotionImageView.animationRepeatCount = 2;
    [_emotionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(80, 90));
    }];
}

@end

