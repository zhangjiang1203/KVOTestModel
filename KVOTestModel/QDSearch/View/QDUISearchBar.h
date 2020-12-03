//
//  QDSearchBar.h
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/9.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QDUISearchBarDelegate <NSObject>

- (void)cancelSearchAction;

- (void)textFieldTextDidChanged:(NSString *)text;

@end


@interface QDUISearchBar : UIView

@property (nonatomic,weak) id<QDUISearchBarDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame preSearch:(NSString*)searchText;

- (void)textFieldBecomeFirstResponder;

@end

NS_ASSUME_NONNULL_END
