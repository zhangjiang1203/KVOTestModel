//
//  SecondModel.m
//  KVOTestModel
//
//  Created by zhangjiang on 2021/5/12.
//  Copyright © 2021 zhangjiang. All rights reserved.
//

#import "SecondModel.h"

@interface SecondModel ()

@property (nonatomic,copy) NSString *name;

@end

@implementation SecondModel

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}


- (void)eat{
    NSLog(@"secondmodel eat");
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"hahahha===%@",self.name];
}

@end
