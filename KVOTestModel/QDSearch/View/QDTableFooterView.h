//
//  QDTableFooterView.h
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/14.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDTableFooterView : UIView

@property (nonatomic,copy) NSString *tipsContent;

- (void)startLoad;

- (void)stopLoad;

@end

NS_ASSUME_NONNULL_END
