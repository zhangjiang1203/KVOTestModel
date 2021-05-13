//
//  ZJServiceModel.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/13.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJServiceModel : NSObject


- (void)addServiceWithClass:(Class)serviceCls protocol:(Protocol *)protocol;

- (void)removeServiceWithProtocol:(Protocol *)protocol;

- (Class)getServiceClassWithProtocol:(Protocol *)protocol;

@end

NS_ASSUME_NONNULL_END
