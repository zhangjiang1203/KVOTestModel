//
//  TestConfigurationCell.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/10/29.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "TestConfigurationCell.h"


@interface TestConfigurationCell ()



@end


@implementation TestConfigurationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.customLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, 300, 20)];
        self.customLabel.textColor = [UIColor blueColor];
        self.customLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.customLabel];
//        self.contentConfiguration = nil;
    }
    return self;
}

//- (id<UIContentConfiguration>)contentConfiguration{
//
//}
//
//- (UIBackgroundConfiguration *)backgroundConfiguration{
//
//}

- (void)updateConfigurationUsingState:(UICellConfigurationState *)state{
    
   UIListContentConfiguration *content = [self.defaultContentConfiguration updatedConfigurationForState:state];
    content.text = @"哈哈哈哈";
    content.textProperties.color = [UIColor yellowColor];
    
    self.contentConfiguration = content;
    
    UIBackgroundConfiguration *config = [UIBackgroundConfiguration listPlainCellConfiguration];
    if (state.isSelected){
        config.backgroundColor = [UIColor blueColor];
    }else if(state.isHighlighted){
        config.backgroundColor = [UIColor redColor];
    }
    config.cornerRadius = 10;
    
    self.backgroundConfiguration = config;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
