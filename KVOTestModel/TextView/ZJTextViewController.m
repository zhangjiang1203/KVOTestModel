//
//  ZJTextViewController.m
//  KVOTestModel
//
//  Created by zj on 2021/7/20.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ZJTextViewController.h"
#import <Masonry/Masonry.h>
#import <YYText/YYText.h>
#import "ZTHorizontalLayout.h"
@interface ZJTextViewController ()<YYTextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) YYTextView *textView;

@property (nonatomic,strong) UICollectionView *myCollectionView;

@property (nonatomic, strong) NSPredicate *predicate;

@property (nonatomic, strong) NSRegularExpression *regex;


@end

@implementation ZJTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"textView";
    [self showTextView];
//    [self seUpCollectionView];
}

-(void)seUpCollectionView{
//    CGFloat screenW = [[UIScreen mainScreen]bounds].size.width;
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//    layout.itemSize = CGSizeMake(screenW/5, 90);
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.minimumLineSpacing = 0;
//    layout.minimumInteritemSpacing = 0;
    
    ZTHorizontalLayout *myLayout = [[ZTHorizontalLayout alloc]initWithRowCount:2 itemCountPerRow:5];
    [myLayout setColumnSpacing:0 rowSpacing:0 edgeInsets:UIEdgeInsetsZero];
    myLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    myLayout.minimumLineSpacing = 0;
    myLayout.minimumInteritemSpacing = 0;
    
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:myLayout];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.pagingEnabled = YES;
    [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"sysetmCell"];
    [self.view addSubview:_myCollectionView];
    
    [_myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(300);
    }];
    
//    UIButton *titleBtn = [[UIButton alloc]init];
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"你好\n中国" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]}];
//    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:[@"你好\n中国" rangeOfString:@"中国"]];
//    [titleBtn setAttributedTitle:attStr forState:(UIControlStateNormal)];
//    titleBtn.titleLabel.numberOfLines = 0;
//    [titleBtn setImage:[UIImage imageNamed:@"searchbar_search"] forState:(UIControlStateNormal)];
//
//    [self.view addSubview:titleBtn];
//
//    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.myCollectionView.mas_bottom).offset(20);
//        make.size.mas_equalTo(CGSizeMake(150, 50));
//        make.centerX.mas_equalTo(0);
//    }];
    
    CGFloat viewW = ([UIScreen mainScreen].bounds.size.width - 20)/3.0;
    CGFloat padding = 10;
    for (int i = 0; i < 9 ; i++) {
        int row = i % 3;
        int column = floorf(i/3.0);
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(row * (viewW+padding), 440+column * (50 + padding), viewW, 50)];
        view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        [self.view addSubview:view];
    }
    
}

////item 列间距(纵)
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 0;
//}
////item 行间距(横)
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 0;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 50;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sysetmCell" forIndexPath:indexPath];
    UIView *view = [[UIView alloc]init];
    view.layer.borderColor = [UIColor redColor].CGColor;
    view.layer.borderWidth = 1;
    cell.selectedBackgroundView = view;
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    return cell;
}


- (void)showTextView{
    
    UIView *backView = [[UIView alloc]init];
    backView.layer.borderColor = [UIColor grayColor].CGColor;
    backView.layer.borderWidth = 1;
    [self.view addSubview:backView];
    
    self.textView = [[YYTextView alloc]init];
    self.textView.placeholderText = @"开始输入";
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.delegate = self;
    
    [backView addSubview:self.textView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(130);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(7, 12, 7, 12));
    }];
    
}

- (void)textViewDidChange:(YYTextView *)textView{
//    NSLog(@"文字开始变化===%f",textView.contentSize.height);
//    BOOL vale = [self.predicate evaluateWithObject:textView.text];
    NSRange range = NSMakeRange(0, textView.text.length);
    NSUInteger emojiCount = [self.regex numberOfMatchesInString:textView.text options:0 range:range];
    NSString *modifiedStr = [self.regex stringByReplacingMatchesInString:textView.text options:0 range:range withTemplate:@""];
    NSLog(@"当前含有的表情个数===%zd,text:%zd",emojiCount,modifiedStr.length);
}

- (NSRegularExpression *)regex{
    if(!_regex) {
        _regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    return _regex;
}

- (NSPredicate *)predicate {
    if(!_predicate) {
        NSString  *regexString = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\\u2026\\u2022\\u20ac\r\n]";
        _predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexString];
    }
    return _predicate;
}

@end



//#import "HorizontalPageFlowlayout.h"

