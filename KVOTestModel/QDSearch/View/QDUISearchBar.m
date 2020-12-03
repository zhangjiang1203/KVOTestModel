//
//  QDSearchBar.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/9.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "QDUISearchBar.h"

@interface QDUISearchBar()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *searchField ;

@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)UILabel *preSearchLabel;

@property (nonatomic,copy)NSString *preSearchText;

@property (nonatomic,strong)UIButton *clearBtn;


@end

@implementation QDUISearchBar

- (instancetype)initWithFrame:(CGRect)frame preSearch:(NSString*)searchText
{
    self = [super initWithFrame:frame];
    if (self) {
        self.preSearchText = searchText;
        [self setUpMyUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.preSearchText = @"";
        [self setUpMyUI];
    }
    return self;
}

-(void)setUpMyUI{
    
    CGSize viewSize = self.frame.size;
    UIView *navBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width-52, viewSize.height)];
    navBackView.layer.cornerRadius = 18;
    navBackView.layer.masksToBounds = YES;
    navBackView.backgroundColor = QDHEXColor(0xf5f6fa, 1);
    [self addSubview:navBackView];
    
    UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbar_search"]];
    leftImageView.frame = CGRectMake(8, (viewSize.height - 16)/2.0, 16, 16);
    [navBackView addSubview:leftImageView];
    
    CGFloat padding = 0;
    
    if(self.preSearchText.length){
        CGSize size = [self.preSearchText boundingRectWithSize:CGSizeMake(96, 22) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        self.preSearchLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame)+4, 0, size.width, viewSize.height)];
        self.preSearchLabel.textColor = RGBA(74,112,255,1);
        self.preSearchLabel.font = [UIFont systemFontOfSize:16];
        self.preSearchLabel.text = self.preSearchText;
        [navBackView addSubview:self.preSearchLabel];
        padding = size.width+4;
    }
    
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewSize.width-36, 0, 36, viewSize.height)];
    [self.cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
    [self.cancelBtn setTitleColor:RGBA(74,112,255,1) forState:(UIControlStateNormal)];
    [self.cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.cancelBtn];
    
    CGFloat fieldWidth = CGRectGetWidth(navBackView.frame) - CGRectGetMaxX(leftImageView.frame) - padding - 8;
    UITextField *searchField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame)+padding+4, 0, fieldWidth, viewSize.height)];
    searchField.textColor = RGBA(38,45,61,1);
    searchField.tintColor = RGBA(74,112,255,1);
    searchField.font = [UIFont systemFontOfSize:16];
    searchField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"搜索" attributes:@{NSForegroundColorAttributeName:RGBA(197,204,219,1)}];
    searchField.delegate = self;
    [navBackView addSubview:searchField];
    self.clearBtn = [[UIButton alloc]init];
    self.clearBtn.bounds = CGRectMake(0, 0, 30, 30);
    [self.clearBtn setImage:[UIImage imageNamed:@"search_searchbar_close"] forState:(UIControlStateNormal)];
    [self.clearBtn addTarget:self action:@selector(clearTextContent) forControlEvents:(UIControlEventTouchUpInside)];
    searchField.rightView = self.clearBtn;
    searchField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.searchField = searchField;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidchanged:) name:UITextFieldTextDidChangeNotification object:self.searchField];

}

- (void)textFieldBecomeFirstResponder{
    [self.searchField becomeFirstResponder];
}

-(void)clearTextContent{
    self.searchField.text = @"";
}

- (void)cancelSearch{
    if ([self.delegate respondsToSelector:@selector(cancelSearchAction)]) {
        [self.delegate cancelSearchAction];
    }
}


-(void)textFieldDidchanged:(NSNotification*)noti{
    NSLog(@"文本开始变化==%@",self.searchField.text);
    if([self.delegate respondsToSelector:@selector(textFieldTextDidChanged:)]){
        [self.delegate textFieldTextDidChanged:self.searchField.text];
    }
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
