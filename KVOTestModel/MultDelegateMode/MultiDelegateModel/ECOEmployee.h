//
//  ECOEmployee.h
//  KVOTestModel
//
//  Created by zhangjiang on 2021/6/1.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ECOEmployeeType){
    ECOEmployee_Developer,
    ECOEmployee_Designer,
    ECOEmployee_Finance,
};

@interface ECOEmployee : NSObject
/// 根据类型创建 ECOEmplyee
+ (ECOEmployee *)employeeWithType:(ECOEmployeeType)type;
@end

@interface ECOEmployeeDeveloper : ECOEmployee
@end

@interface ECOEmployeeDesigner : ECOEmployee
@end

@interface ECOEmployeeFinance : ECOEmployee
@end

NS_ASSUME_NONNULL_END
