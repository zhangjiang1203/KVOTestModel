//
//  TestServiceProtocol.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef TestServiceProtocol_h
#define TestServiceProtocol_h


@protocol TestServiceProtocol <NSObject>

- (NSString *)showName;


+ (NSString *)getMySysInfo;

@end


#endif /* TestServiceProtocol_h */
