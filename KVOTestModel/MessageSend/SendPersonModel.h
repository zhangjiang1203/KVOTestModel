//
//  SendPersonModel.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/12.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SendPersonModel : NSObject

@property (nonatomic,copy) NSString *firstName;

@property (nonatomic,copy) NSString *lastName;

@property (nonatomic,strong,readonly) NSMutableSet *friendSets;


//构造两个方法 添加 删除 friendset中的数据
- (void)addFriend:(SendPersonModel *)model;
- (void)removeFirend:(SendPersonModel *)model;

@end

NS_ASSUME_NONNULL_END
