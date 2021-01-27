//
//  CodeStudentModel.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/12/4.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "CodeStudentModel.h"
#import "NSObject+Coding.h"
@implementation CodeStudentModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    self = [super init];
    if (self) {
        [self zj_modelInitWithCoder:coder];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
    [self zj_modelEncodeWithCoder:coder];
    
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"name=%@,address=%@,email=%@,nickName=%@,stuNum=%@", self.name,self.address,self.email,self.nickName,self.stuNum];
}

@end
