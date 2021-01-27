//
//  CodePersonModel.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/12/4.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "CodePersonModel.h"
#import "NSObject+Coding.h"

@implementation CodePersonModel

- (instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super init]) {
        [self zj_modelInitWithCoder:coder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [self zj_modelEncodeWithCoder:coder];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"name=%@,address=%@,email=%@", self.name,self.address,self.email];
}

@end
