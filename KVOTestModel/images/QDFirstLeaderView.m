//
//  QDFirstLeaderView.m
//  QQ
//
//  Created by zhangjiang on 2020/5/29.
//


#import "QDFirstLeaderView.h"
#import <WebKit/WebKit.h>
@interface QDFirstLeaderView()

@property (nonatomic,strong)UIButton *clickBtn;

@property (nonatomic,strong)UIImageView *titleImageView;

//@property (nonatomic,strong)FLAnimatedImageView *showGifView;

@property (nonatomic,strong)WKWebView *myWebView;

@end


@implementation QDFirstLeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [self setUpMyLeaderView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [self setUpMyLeaderView];
    }
    return self;
}

-(void)setUpMyLeaderView{
    
    self.backgroundColor = [UIColor colorWithRed:30/255.0 green:35/255.0 blue:48/255.0 alpha:0.8];// RGBACOLOR(30, 35, 48, 0.8);
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    
    self.myWebView = [[WKWebView alloc]initWithFrame:CGRectZero];
    self.myWebView.bounds = CGRectMake(0, 0, (295*size.width/375.0), (450*size.width/375.0));
    self.myWebView.center = self.center;
    self.myWebView.layer.cornerRadius = 11;
    self.myWebView.layer.masksToBounds = YES;
    self.myWebView.userInteractionEnabled = NO;
    self.myWebView.scrollView.scrollEnabled = NO;
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"first_user_lead_show_image@2x.gif" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    [self addSubview:self.myWebView];
    
    self.titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"first_user_lead_title"]];
    self.titleImageView.frame = CGRectMake((size.width-192)/2, CGRectGetMinY(self.myWebView.frame) - (94), (192), (64));
    self.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:self.titleImageView];
    
    self.clickBtn = [[UIButton alloc]initWithFrame:CGRectMake((size.width-150)/2, CGRectGetMaxY(self.myWebView.frame)+30, (150), (36))];
    self.clickBtn.backgroundColor = [UIColor clearColor];

    [self.clickBtn setImage:[UIImage imageNamed:@"first_user_lead_konw"] forState:(UIControlStateNormal)];
    [self.clickBtn addTarget:self action:@selector(dismissLeaderView) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.clickBtn];
}


-(void)dismissLeaderView{
    [self removeFromSuperview];
}

@end
