//
//  KXLiveRoomViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/11.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "KXLiveRoomViewController.h"
#import "KXVoiceChatRoomViewController.h"
#import <Masonry/Masonry.h>
#import "KXRippleView.h"
#import "KXShowAnimationView.h"

@interface KXLiveRoomViewController ()

@property (nonatomic,strong) KXVoiceChatRoomViewController *voiceRoom;

@property (nonatomic,strong) KXShowAnimationView *rippleView;

@property (nonatomic,strong) UIImageView *animationView;
@end

@implementation KXLiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpGuestView];
    [self setUpAction];
}

- (void)setUpGuestView{
    self.voiceRoom = [[KXVoiceChatRoomViewController alloc]init];
    [self.view addSubview:self.voiceRoom.view];
    [self.voiceRoom.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(self.view.mas_top).offset(80);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-30);
    }];
    [self addChildViewController:self.voiceRoom];
    
    [self.voiceRoom.guestTapSubject subscribeNext:^(KXVoiceSeatModel * _Nullable x) {
        NSLog(@"选中结果开始变化==");
    }];
}

- (void)setUpAction{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 120, 30)];
    rightBtn.tag = 1;
    [rightBtn setTitle:@"构建数据" forState:(UIControlStateNormal)];
    [rightBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [rightBtn addTarget:self action:@selector(actionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rightBtn];
    
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 140, 120, 30)];
    leftBtn.tag = 2;
    [leftBtn setTitle:@"修改座位index" forState:(UIControlStateNormal)];
    [leftBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [leftBtn addTarget:self action:@selector(actionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftBtn];
    
    UIButton *leftBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 180, 120, 30)];
    leftBtn1.tag = 3;
    [leftBtn1 setTitle:@"修改人" forState:(UIControlStateNormal)];
    [leftBtn1 setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [leftBtn1 addTarget:self action:@selector(actionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftBtn1];
    
    UIButton *leftBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 220, 120, 30)];
    leftBtn2.tag = 4;
    [leftBtn2 setTitle:@"修改座位" forState:(UIControlStateNormal)];
    [leftBtn2 setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [leftBtn2 addTarget:self action:@selector(actionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftBtn2];
    
    UIButton *leftBtn3 = [[UIButton alloc]initWithFrame:CGRectMake(0, 260, 120, 30)];
    leftBtn3.tag = 5;
    [leftBtn3 setTitle:@"修改说话" forState:(UIControlStateNormal)];
    [leftBtn3 setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [leftBtn3 addTarget:self action:@selector(actionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftBtn3];
    
    UIButton *leftBtn5 = [[UIButton alloc]initWithFrame:CGRectMake(0, 300, 120, 30)];
    leftBtn5.tag = 7;
    [leftBtn5 setTitle:@"修改选中" forState:(UIControlStateNormal)];
    [leftBtn5 setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [leftBtn5 addTarget:self action:@selector(actionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftBtn5];
    
    UIButton *leftBtn6 = [[UIButton alloc]initWithFrame:CGRectMake(0, 340, 120, 30)];
    leftBtn6.tag = 8;
    [leftBtn6 setTitle:@"选中通知" forState:(UIControlStateNormal)];
    [leftBtn6 setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [leftBtn6 addTarget:self action:@selector(actionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftBtn6];

    UIButton *leftBtn7 = [[UIButton alloc]initWithFrame:CGRectMake(0, 380, 120, 30)];
    leftBtn7.tag = 9;
    [leftBtn7 setTitle:@"送礼完成通知" forState:(UIControlStateNormal)];
    [leftBtn7 setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [leftBtn7 addTarget:self action:@selector(actionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftBtn7];
    
    
    
    self.animationView = [[UIImageView alloc]init];
    [self.view addSubview:self.animationView];
    
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(61, 61));
        make.top.mas_equalTo(leftBtn7.mas_bottom).offset(10);
    }];
    
    NSMutableArray *imagesArr = [NSMutableArray array];
    for (NSInteger i = 7; i < 40; i++) {
        NSString *index = i > 9 ? [NSString stringWithFormat:@"%ld",(long)i] : [NSString stringWithFormat:@"0%ld",(long)i];
        NSString *imageName = [NSString stringWithFormat:@"voice_000%@",index];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            [imagesArr addObject:image];
        }else{
            NSLog(@"当前i == %ld",(long)i);
        }
    }
    
    self.animationView.animationImages = imagesArr;
    self.animationView.animationDuration = 2.47;
    self.animationView.animationRepeatCount = 0;
    [self.animationView startAnimating];
    
//    self.rippleView = [[KXShowAnimationView alloc]initWithFrame:CGRectMake(20, 430, 100, 100)];
//    self.rippleView.color = [UIColor colorWithRed:9/255.0 green:225/255.0  blue:213/255.0  alpha:1];
//    self.rippleView.layer.cornerRadius = 50;
//    self.rippleView.layer.masksToBounds = YES;
//    [self.rippleView startWaveAnimationCircleNumber:6];
//    [self.view addSubview:self.rippleView];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(25, 435, 90, 90)];
    headerView.backgroundColor = [UIColor redColor];
    headerView.layer.cornerRadius = 47;
    headerView.layer.masksToBounds = YES;
    [self.view addSubview:headerView];
}

- (void)actionButtonClick:(UIButton *)sender {
    if (sender.tag == 1) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i< 5; i++) {
            KXVoiceSeatModel *seat = [KXVoiceSeatModel new];
            seat.seatIndex = i + 1;
            KXVoicePersonModel *person = [KXVoicePersonModel new];
            person.identifierType = KXVoiceType_None;
            person.name = [NSString stringWithFormat:@"%d=showName",i];
            seat.person = person;
            
            [tempArr addObject:seat];
        }
        //构建数据模型
        self.voiceRoom.voiceManager.seatInfoArr = tempArr;
    }else if (sender.tag == 2){
        //修改其中的一个值的数据
        KXVoiceSeatModel *seat = self.voiceRoom.voiceManager.seatInfoArr[2];
        seat.seatIndex = 6;
        
        
    }else if (sender.tag == 3){
        //修改其中的一个值的数据
        KXVoiceSeatModel *seat = self.voiceRoom.voiceManager.seatInfoArr[1];
        seat.person.name = @"哈哈哈";
        
        
    }else if (sender.tag == 4){
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i< 2; i++) {
            KXVoiceSeatModel *seat = [KXVoiceSeatModel new];
            seat.seatIndex = i + 1;
            KXVoicePersonModel *person = [KXVoicePersonModel new];
            person.identifierType = KXVoiceType_None;
            person.name = [@"index=" stringByAppendingFormat:@"%d",i];
            seat.person = person;
            
            [tempArr addObject:seat];
        }
        //构建数据模型
        self.voiceRoom.voiceManager.seatInfoArr = tempArr;

    }else if (sender.tag == 5){
        //修改人是否在说话 每次都取反进行操作
        KXVoiceSeatModel *seat = self.voiceRoom.voiceManager.seatInfoArr[1];
        seat.person.isSpeak = !seat.person.isSpeak;
    }else if (sender.tag == 7){
        //修改人是否在说话 每次都取反进行操作
        KXVoiceSeatModel *seat = self.voiceRoom.voiceManager.seatInfoArr[1];
        seat.person.isChoose = !seat.person.isChoose;
    }else if (sender.tag == 8){
        //修改人是否在说话 每次都取反进行操作
        KXVoiceSeatModel *seat = self.voiceRoom.voiceManager.seatInfoArr[2];
//        seat.person.isChoose = !seat.person.isChoose;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kSeatChooseNoti" object:seat];
    }else if (sender.tag == 9){
        //送礼完成，取消所有的选中状态
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kSendGiftCompleted" object:nil];
    }
}

@end
