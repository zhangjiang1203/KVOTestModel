//
//  KXVoiceGuestCell.m
//  KXLive
//
//  Created by zhangjiang on 2021/5/10.
//  Copyright © 2021 ibobei. All rights reserved.
//

#import "KXVoiceGuestCell.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import "KXRippleView.h"
#import "KXShowAnimationView.h"


#define kSeatChooseNoti     @"kSeatChooseNoti"

@interface KXVoiceGuestCell ()

@property (nonatomic,strong) UIView *containerView;
///视频播放view
@property (nonatomic,strong) UIView *renderView;

@property (nonatomic,strong) UIImageView *userImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UIButton *giftBtn;

//@property (nonatomic,strong) UIImageView *rippleView;


@property (nonatomic,strong) UIImageView *voiceAnimationView;
@end


@implementation KXVoiceGuestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initGuestView];
        [self setUpNotification];
    }
    return self;
}

- (void)setUpNotification {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kSeatChooseNoti object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        if (x.object == self.seatModel) {
            self.seatModel.person.isChoose = YES;
        }
    }];
}


- (void)setUpObserverChange{
    [[RACObserve(self.seatModel, seatIndex) skip:1] subscribeNext:^(NSNumber* _Nullable x) {
       //person 属性变化
        NSLog(@"person 开始变化 %ld",(long)[x integerValue]);
    }];
   
    //位置变化
    [[RACObserve(self.seatModel.person, name) skip:1] subscribeNext:^(NSString *_Nullable x) {
        NSLog(@"person name 开始变化");
        self.nameLabel.text = x;
    }];
    
    //说话变化
    [[RACObserve(self.seatModel.person, isSpeak) skip:1] subscribeNext:^(NSNumber *_Nullable x) {
        NSLog(@"person isSpeak 开始变化 %d",[x intValue]);
        if ([x boolValue]) {
//            [self.rippleView addRippleAnimation];
        }else{
//            [self.rippleView ];
        }
    }];
    
    //是否被选中
    [[RACObserve(self.seatModel.person, isChoose) skip:1] subscribeNext:^(NSNumber *_Nullable x) {
        NSLog(@"person isChoose 开始变化 %d",[x intValue]);
        if ([x boolValue]) {
            [self addHighlightedStyle];
            
        }else{
            [self removeHighlightedStyle];
        }
    }];
}

- (void)initGuestView{
    self.giftSubject = [RACSubject subject];
    
    self.containerView = [[UIView alloc]init];
    self.containerView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.containerView];
    
    self.renderView = [[UIView alloc]init];
    [self.containerView addSubview:self.renderView];
    
    self.voiceAnimationView = [[UIImageView alloc]init];
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
    self.voiceAnimationView.animationImages = imagesArr;
    self.voiceAnimationView.animationDuration = 2.47;
    self.voiceAnimationView.animationRepeatCount = 0;
//    self.rippleView.color = [UIColor colorWithRed:9/255.0 green:225/255.0  blue:213/255.0  alpha:1];
//    self.rippleView. = [UIColor colorWithRed:9/255.0 green:225/255.0  blue:213/255.0  alpha:1];
//    self.rippleView.startRadius = 20;
//    [self.rippleView addRippleAnimation];
    [self.containerView addSubview:self.voiceAnimationView];
    
    self.userImageView = [[UIImageView alloc]init];
    self.userImageView.backgroundColor = [UIColor redColor];
    self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userImageView.clipsToBounds = YES;
    self.userImageView.layer.cornerRadius = 25;
    self.userImageView.layer.masksToBounds = YES;
    [self.containerView addSubview:self.userImageView];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [UIColor grayColor];
    [self.containerView addSubview:self.nameLabel];
    
    self.giftBtn = [[UIButton alloc]init];
    @weakify(self);
    [[self.giftBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.giftSubject sendNext:@1];
    }];
    [self.containerView addSubview:self.giftBtn];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
    
    [self.renderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containerView);
    }];
    
    [self.voiceAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.top.mas_equalTo(self.containerView).offset(10);
    }];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.voiceAnimationView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(self.containerView);
        make.right.mas_equalTo(self.containerView);
        make.height.mas_equalTo(20);
    }];
    
    [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)addHighlightedStyle{
    self.containerView.layer.borderColor = [UIColor redColor].CGColor;
    self.containerView.layer.borderWidth = 2;
}

- (void)removeHighlightedStyle{
    self.containerView.layer.borderColor = [UIColor clearColor].CGColor;
    self.containerView.layer.borderWidth = 2;
}


- (void)setSeatModel:(KXVoiceSeatModel *)seatModel{
    _seatModel = seatModel;
    //对应设置
    self.nameLabel.text = [self dealWithUserName:_seatModel.person.name];
    [self setUpObserverChange];
}


- (NSString *)dealWithUserName:(NSString *)name{
    if (name.length <= 4) {
        return name;
    }
    NSString *newName = [name substringToIndex:4];
    newName = [newName stringByAppendingString:@"…"];
    return newName;
}

- (NSString *)dealWithContribution:(NSInteger)contribution{
    if (contribution <= 999) {
        return [NSString stringWithFormat:@"%ld",(long)contribution];
    }
    return @"999+";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
