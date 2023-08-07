//
//  DYHBAwardRecordCell.h
//  DYFunBoxComponent
//
//  Created by zhangjiang on 2023/7/6.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DYHBAwardRecordCell : UITableViewCell

+ (NSString *)reuseIdentifier;

- (void)setWinInfoModel:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
