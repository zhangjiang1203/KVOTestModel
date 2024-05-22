//
//  DYHBChooseItemModel.m
//  KVOTestModel
//
//  Created by zhangjiang on 2023/10/12.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

#import "DYHBChooseItemModel.h"

@implementation DYHBItemInfoModel

@end

@implementation DYHBChooseItemModel

- (BOOL)isEqual:(id)object{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[DYHBChooseItemModel class]]) {
        return NO;
    }
    
    return [self isEqualToItem:object];
}

- (BOOL)isEqualToItem:(DYHBChooseItemModel *)item {
    if (!item) {
        return NO;
    }
    
    return self.itemId == item.itemId;
}

- (NSUInteger)hash
{
    return [self.title hash] ^ [@(self.itemId) hash];
}

@end
