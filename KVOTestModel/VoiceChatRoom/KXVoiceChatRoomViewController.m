//
//  KXVoiceChatRoomViewController.m
//  KXLive
//
//  Created by zhangjiang on 2021/5/10.
//  Copyright © 2021 ibobei. All rights reserved.
//

#import "KXVoiceChatRoomViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
//#import <KXAppConst/KXAppConfig.h>

#define kSendGiftCompleted  @"kSendGiftCompleted"
#define kTableViewCellHeight 90

#import "KXVoiceGuestCell.h"
@interface KXVoiceChatRoomViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *guestTableView;



@end

@implementation KXVoiceChatRoomViewController
/*
 1.构建VC 搭建基础UI展示
 2.模型构建成功 监听模型变更 重新更新UI
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.guestTapSubject = [RACSubject subject];
    self.voiceManager = [[KXVoiceManager alloc]init];
//    [self.voiceManager addIMVoiceHandler];
    [self setUpCollection];
    @weakify(self);
    [RACObserve(self.voiceManager, seatInfoArr) subscribeNext:^(NSMutableArray *_Nullable x) {
        NSLog(@"数组开始变化");
        @strongify(self);
        //修改table的frame
        [UIView animateWithDuration:0.3 animations:^{
            [self.guestTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(x.count * kTableViewCellHeight);
            }];
            [self.view layoutIfNeeded];
        }];
        //刷新tableview的数据
        [self.guestTableView reloadData];
    }];
    
    ///送礼完成 刷新所有的选中状态
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kSendGiftCompleted object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        for (KXVoiceSeatModel *seat in self.voiceManager.seatInfoArr) {
            seat.person.isChoose = NO;
        }
    }];

}

- (void)setUpCollection {
    
    self.guestTableView = [[UITableView alloc]init];
    self.guestTableView.backgroundColor = [UIColor clearColor];
    self.guestTableView.dataSource = self;
    self.guestTableView.delegate = self;
    self.guestTableView.showsVerticalScrollIndicator = NO;
    self.guestTableView.showsHorizontalScrollIndicator = NO;
    self.guestTableView.scrollEnabled = NO;
    self.guestTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.guestTableView registerClass:[KXVoiceGuestCell class] forCellReuseIdentifier:@"KXVoiceGuestCell"];
    [self.view addSubview:self.guestTableView];
    
    [self.guestTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
}


#pragma mark -collection delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.voiceManager.seatInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KXVoiceGuestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KXVoiceGuestCell"];
    cell.seatModel = self.voiceManager.seatInfoArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //选中高亮状态，首先重置所有的状态
    for (KXVoiceSeatModel *seat in self.voiceManager.seatInfoArr) {
        seat.person.isChoose = NO;
    }
    KXVoiceSeatModel *model = self.voiceManager.seatInfoArr[indexPath.row];
    model.person.isChoose = YES;
    [self.guestTapSubject sendNext:model];
}



- (void)dealloc
{
//    [self.voiceManager removeIMVoiceHandler];
}
@end
