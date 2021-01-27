//
//  CodePersonModel.h
//  KVOTestModel
//
//  Created by zhangjiang on 2020/12/4.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CodePersonModel : NSObject<NSCoding>

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *email;

@end

NS_ASSUME_NONNULL_END
