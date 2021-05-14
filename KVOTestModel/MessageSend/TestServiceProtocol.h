//
//  TestServiceProtocol.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondModel.h"
#ifndef TestServiceProtocol_h
#define TestServiceProtocol_h


@protocol TestServiceProtocol <NSObject>

- (NSString *)showName;


+ (SecondModel *)getMySysInfo;

@end


@protocol TestSingleInstanceProtocol <NSObject>

- (NSString *)testSingleInstance:(NSString *)showName;

@end


#endif /* TestServiceProtocol_h */
