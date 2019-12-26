//
//  DebenDataManager.h
//  KVOTestModel
//
//  Created by zhangjiang on 2019/12/4.
//  Copyright © 2019 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DebenDataModel : NSObject

@property (nonatomic,strong) NSString *deID;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,copy)NSValue *rectValue;
@end


@interface DebenDataManager : NSObject

@property (nonatomic,strong)NSArray *debenItemsArr;

+ (instancetype) shareInstance;

+ (NSArray<DebenDataModel *> *) getAllDebenItems;

+ (NSMutableArray<NSValue *> *) getAllSubStringRangeFromString:(NSString*)string withSubString:(NSString*)subString ;




@end

NS_ASSUME_NONNULL_END
