//
//  DYHBChooseItemView.m
//  KVOTestModel
//
//  Created by zhangjiang on 2023/10/12.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import "DYHBChooseItemView.h"
#import "DYHBChooseItemCell.h"
#import <Masonry/Masonry.h>

@interface DYHBChooseItemView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *itemTableView;

@property (nonatomic, strong) NSMutableArray<DYHBItemInfoModel *> *itemDataArr;

@property (nonatomic, strong) NSMutableArray<DYHBChooseItemModel *> *chooseItemArr;

@end

@implementation DYHBChooseItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpChooseItemView];
    }
    return self;
}

- (void)setUpChooseItemView {
    //取消section 间距变大
    if (@available(iOS 15.0, *)) { [[UITableView appearance] setSectionHeaderTopPadding:0.0f]; }
    self.itemDataArr = [NSMutableArray array];
    self.chooseItemArr = [NSMutableArray array];
    
    self.itemTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    self.itemTableView.dataSource = self;
    self.itemTableView.delegate = self;
    self.itemTableView.showsHorizontalScrollIndicator = NO;
    self.itemTableView.rowHeight = UITableViewAutomaticDimension;
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.itemTableView registerClass:[DYHBChooseItemCell class] forCellReuseIdentifier:@"DYHBChooseItemCell"];
    [self addSubview:self.itemTableView];
    
    [self.itemTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    //构造数据
    for (int i = 0; i < 4; i++) {
        DYHBItemInfoModel *infoModel = [[DYHBItemInfoModel alloc] init];
        infoModel.sectionTitle = [NSString stringWithFormat:@"分区展示=%d",i];
        
        NSInteger dataCount = arc4random_uniform(9) + 5;
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int j = 0; j < dataCount; j++) {
            DYHBChooseItemModel *infoModel = [[DYHBChooseItemModel alloc] init];
            infoModel.title = [NSString stringWithFormat:@"内容=%d",j];
            infoModel.itemId = j;
//            if(j == 0){
//                infoModel.status = DYHBChooseItem_Choosed;
//            }else if (j > 3){
                infoModel.status = DYHBChooseItem_UnChoosed;
//            }else{
//                infoModel.status = DYHBChooseItem_Disable;
//            }
            [tempArr addObject:infoModel];
        }
        infoModel.items = [tempArr copy];
        [self.itemDataArr addObject:infoModel];
    }
    
//    [self.itemDataArr enumerateObjectsUsingBlock:^(DYHBItemInfoModel *obj, NSUInteger idx, BOOL *stop) {
//        [obj.items enumerateObjectsUsingBlock:^(DYHBChooseItemModel *item, NSUInteger index, BOOL *stop) {
//            item.status = index % 2 == 0 ? DYHBChooseItem_UnChoosed : DYHBChooseItem_Choosed;
//        }];
//    }];
    
    
    DYHBChooseItemModel *infoModel = [[DYHBChooseItemModel alloc] init];
    infoModel.title = @"内容=5";
    infoModel.itemId = 5;
    
    [self.itemDataArr enumerateObjectsUsingBlock:^(DYHBItemInfoModel *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.items containsObject:infoModel]) {
            NSInteger index = [obj.items indexOfObject:infoModel];
            DYHBChooseItemModel *chooseItem = obj.items[index];
            chooseItem.status = DYHBChooseItem_Choosed;
            NSLog(@"当前内容对比==%@,所在位置=%zd",obj.sectionTitle,index);
        }
    }];
    
    //刷新数据
    [self.itemTableView reloadData];
}

- (void)resetData{
    //选中状态记录在另一个数组中,只需要移除所有选中 重新刷新数据即可
    [self.chooseItemArr removeAllObjects];
    [self.itemTableView reloadData];
}

#pragma mark -tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//设置header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    DYHBItemInfoModel *infoModel = self.itemDataArr[section];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = infoModel.sectionTitle;
    titleLabel.textColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DYHBChooseItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"DYHBChooseItemCell"];
    DYHBItemInfoModel *infoModel = self.itemDataArr[indexPath.section];
    itemCell.itemsArr = infoModel.items;
    //设置选中或消失
    itemCell.itemChooseBlock = ^(DYHBChooseItemModel *item, BOOL isChoose) {
        [self dealChooseItemData:item status:isChoose];
    };
    return itemCell;
}

- (void)dealChooseItemData:(DYHBChooseItemModel *)item status:(BOOL)isAdd {
    if (isAdd) {
        [self.chooseItemArr addObject:item];
    }else {
        [self.chooseItemArr removeObject:item];
    }
}

- (NSArray *)getChooseItemData {
    return [self.chooseItemArr copy];
}
@end
