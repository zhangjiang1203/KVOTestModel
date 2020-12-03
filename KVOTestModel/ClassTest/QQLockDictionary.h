//
//  QQLockDictionary.h
//  QQMSFContact
//
//  Created by Yang Jin on 12-9-8.
//
//

#import <Foundation/Foundation.h>

@protocol IQQLockDictionaryValidChecker <NSObject>

- (BOOL)isValid:(NSObject *)obj;

@optional
- (id)deepCopy:(id)obj;

@end

@interface QQLockDictionary : NSObject <NSCopying,NSMutableCopying>{
    NSRecursiveLock* _lock;
    NSMutableDictionary* _dict;
}

- (id)initWithMutableDictionary:(NSMutableDictionary*)dic withValidChecker:(id<IQQLockDictionaryValidChecker>)checker withCheckWild:(BOOL)checkWild;
- (id)initWithMutableDictionary:(NSMutableDictionary*)dic withValidChecker:(id<IQQLockDictionaryValidChecker>)checker;
- (id)initWithMutableDictionary:(NSMutableDictionary*)dic;
- (int)intForKey:(id)aKey;
- (id)objectForKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)setValue:(id)value forKey:(NSString *)key;
- (id)valueForKey:(NSString *)key;
- (NSArray*)allKeys;
- (NSArray*)allValues;
- (NSArray*)allKeysForObject:(id)object;
- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;
- (void)removeAllObjects;
- (void)removeObjectsForKeys:(NSArray*)keys;
- (int)count;
- (void)setDictionary:(NSMutableDictionary*)dic;
- (NSDictionary *)fetchDictionary;
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

+ (QQLockDictionary*)dictionaryWithMutableDictionary:(NSMutableDictionary*)dic;

- (void)enumerateKeysAndObjectsUsingBlock:(void (NS_NOESCAPE ^)(id key, id obj, BOOL * stop))block;

#pragma mark- QQLockDictionary 安全API

- (id)objectForKey:(id)aKey type:(Class)type;

- (NSString*)stringSafeForKey:(id)key;
- (NSNumber*)numberSafeForKey:(id)key;
- (NSInteger)integerSafeForKey:(id)key;
- (NSInteger)integerSafeForKey:(id)key defaultV:(NSInteger)defaultV;
- (BOOL)boolSafeForKey:(id)key;
- (int)intSafeForKey:(id)key;
- (float)floatSafeForKey:(id)key;
- (NSArray*)arraySafeForKey:(id)key;
- (NSDictionary*)dicSafeForKey:(id)key;
- (NSData*)dataSafeForKey:(id)key;
- (uint64_t)longSafeForKey:(id)key;
- (unsigned int)unsignedintSafeForKey:(id)key;
- (unsigned long long)unsignedlonglongSafeForKey:(id)key;
- (id)objectSafeForKey:(id)aKey;
- (double)doubleSafeForKey:(id)key;
- (NSMutableArray *)mutableArraySafeForKey:(id)key;
- (NSMutableDictionary *)mutableDicSafeForKey:(id)key;

@end
