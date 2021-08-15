//
//  Person.h
//  KVOTestModel
//
//  Created by zj on 2019/10/11.
//  Copyright © 2019 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@interface Dog : NSObject

@property (assign,nonatomic) NSInteger age;

@end

NS_ASSUME_NONNULL_END



NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger age;

@property (nonatomic,strong) Dog *dog;

//- (void)testCategoryMethord;

@end

@interface Gril : Person



@end

NS_ASSUME_NONNULL_END



