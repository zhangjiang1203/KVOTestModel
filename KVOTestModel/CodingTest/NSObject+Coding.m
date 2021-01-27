//
//  NSObject+Coding.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/12/4.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "NSObject+Coding.h"
#import <objc/runtime.h>

@implementation NSObject (Coding)

// 解档
- (instancetype)zj_modelInitWithCoder:(NSCoder *)aDecoder {
    if (!aDecoder) return self;
    if (!self) {
        return self;
    }
    
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        
        id value = [aDecoder decodeObjectForKey:name];
        [self setValue:value forKey:name];
    }
    free(propertyList);
    
    return self;
}

// 归档
- (void)zj_modelEncodeWithCoder:(NSCoder *)aCoder {
    if (!aCoder) return;
    if (!self) {
        return;
    }
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        
        id value = [self valueForKey:name];
        [aCoder encodeObject:value forKey:name];
    }
    free(propertyList);
}


- (NSMutableDictionary *)convertModelToDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        dict[key] = [self valueForKey:key];
    }
    free(properties);
    return [dict copy];
}


- (instancetype)zj_initWithDict:(NSDictionary*)dict {
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [self setValue:dict[key] forKey:key];
    }
    free(properties);
    return self;
}


@end
