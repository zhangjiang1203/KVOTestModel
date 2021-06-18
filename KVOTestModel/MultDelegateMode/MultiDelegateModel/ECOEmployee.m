//
//  ECOEmployee.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/6/1.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "ECOEmployee.h"

@implementation ECOEmployeeDeveloper

@end

@implementation ECOEmployeeDesigner

@end

@implementation ECOEmployeeFinance


@end


@implementation ECOEmployee

+ (ECOEmployee *)employeeWithType:(ECOEmployeeType)type{
    switch (type) {
        case ECOEmployee_Developer:
            return [ECOEmployeeDeveloper new];
            break;
        case ECOEmployee_Designer:
            return [ECOEmployeeDesigner new];
            break;
        case ECOEmployee_Finance:
            return [ECOEmployeeFinance new];
            break;
    }
}
@end
