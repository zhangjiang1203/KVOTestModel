//
//  Person+Custom.h
//  KVOTestModel
//
//  Created by zhangjiang on 2020/4/8.
//  Copyright © 2020 zhangjiang. All rights reserved.
//


#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (Custom)

+ (void) personName:(NSString *)name;



@end


@interface Person(At)

- (void)setMyAddress:(NSString*)address;

@end

NS_ASSUME_NONNULL_END
