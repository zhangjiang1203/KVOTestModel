//
//  KXMoudleProtocolTestModel.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/12.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


// 使用orz那一套必须要在协议中定义实例方法， 不允许`sharedInstance` 单例 / 全局 对象实现`module Protocol`,需要新建`Module`
//  `Question` 只支持 `ClassMethod +()`,不支持 `InstanceMethod -()`
@protocol KXTestMoudleProtocol <NSObject>


+ (NSString *)getCurrentName;

+ (NSNumber *)showDifferentName;
@end



@interface KXMoudleProtocolTestModel : NSObject

@end

NS_ASSUME_NONNULL_END
