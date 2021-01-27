//
//  CodeStudentModel.h
//  KVOTestModel
//
//  Created by zhangjiang on 2020/12/4.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodePersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CodeStudentModel : CodePersonModel


@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *stuNum;



@end

NS_ASSUME_NONNULL_END
