//
//  Person.m
//  KVOTestModel
//
//  Created by zj on 2019/10/11.
//  Copyright © 2019 zhangjiang. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dog = [[Dog alloc]init];
    }
    return self;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    //根据对应的key 手动或者自动触发通知给观察者
    if ([key isEqualToString:@"name"]) {
        return NO;
    }
    return YES;
}

@end

//    Person *p = [Person new];
////    NSArray *temp1 = [self findSubClass:p];
//    [p addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
//    [p addObserver:self forKeyPath:@"dog.age" options:(NSKeyValueObservingOptionNew) context:nil];
////    NSArray *temp2 = [self findSubClass:p];
//    // 手动触发observer
//    [p willChangeValueForKey:@"name"];
//    p.name = @"张三";
//    p.dog.age = 14;
//    [p didChangeValueForKey:@"name"];
//
////    __weak typeof(p) weakP = p;
//
//
//}
//
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"name"]) {
//        NSLog(@"值开始改变了");
//    }
//}
//
//- (void)dealloc
//{
//    [self removeObserver:self forKeyPath:@"name"];
//}

//- (NSArray *)findSubClass:(Class)defaultClass {
//    int count = objc_getClassList(NULL, 0);
//
//    NSMutableArray *array = [NSMutableArray arrayWithObject:defaultClass];
//    Class *tempCla = (Class*)malloc(sizeof(defaultClass)*count);
//    objc_getClassList(tempCla, count);
//
//    for (int i = 0; i < count; i++) {
//        if (defaultClass == class_getSuperclass(tempCla[i])){
//            [array addObject:tempCla[i]];
//        }
//    }
//    free(tempCla);
//    return array;
//}


@implementation Dog



@end
