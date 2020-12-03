
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "QQLockDictionary"
#pragma clang diagnostic pop

//
//  QQLockDictionary.m
//  QQMSFContact
//
//  Created by Yang Jin on 12-9-8.
//
//

#import "QQLockDictionary.h"

@interface QQLockDictionary ()
{
    BOOL _bCheckWild;
}

@end

@implementation QQLockDictionary

- (id)init
{
    self = [super init];
    if (self) {
        _lock = [NSRecursiveLock new];
//        _dict = CZ_NewMutableDictionaryWithCapacity(1);
        _dict = [[NSMutableDictionary alloc] initWithCapacity:1];
        _bCheckWild = NO;
    }
    return self;
}

- (id)initWithMutableDictionary:(NSMutableDictionary*)dic withValidChecker:(id<IQQLockDictionaryValidChecker>)checker withCheckWild:(BOOL)checkWild
{
    self = [self initWithMutableDictionary:dic withValidChecker:checker];
    if (self) {
        _bCheckWild = checkWild;
    }
    return self;
}



- (id)initWithMutableDictionary:(NSMutableDictionary*)dic
{
    self = [self init];
    if (self) {
        if (dic) {
            [_dict setDictionary:dic];
        }
    }
    return self;
}

- (void)dealloc
{
//    [_lock release];
    _lock = nil;
//    [_dict release];
    _dict = nil;
//    [super dealloc];
}

- (void)setDictionary:(NSMutableDictionary *)dic
{
    [_lock lock];
    if (_dict){
        _dict = nil;
    }
    _dict = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [_lock unlock];
}

- (NSDictionary *)fetchDictionary
{
    [_lock lock];
    
    NSDictionary *dict = nil;
    
    if (_bCheckWild) {
        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
        
        NSArray *keyArr = [_dict allKeys];
        for (id key in keyArr) {
            [tmpDict setObject:[self objectForKey:key] forKey:key];
        }
        dict = tmpDict;
    } else {
        dict = [NSDictionary dictionaryWithDictionary:_dict];
    }
    
    [_lock unlock];
    
    return dict;
}

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile
{
    [_lock lock];
    NSDictionary *dic = [self fetchDictionary];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [_lock unlock];
    
    BOOL b = [dic writeToFile:path atomically:useAuxiliaryFile];
    
    if (!b) {
//        QLog_Event("","QQLockDictionary writeToFile path is %s , success:%d", path.UTF8String, b);
    }
    
    return b;
}

- (int)intForKey:(id)aKey
{
    return [[self objectForKey:aKey] intValue];
}

- (id)objectForKey:(id)aKey
{
    if (aKey == nil) {
        return nil;
    }

    [_lock lock];
    
    id obj = nil;
    obj = [_dict objectForKey:aKey];
    [_lock unlock];
    return obj;
}

- (void)removeObjectForKey:(id)aKey
{
    if (aKey == nil) {
        return;
    }
    
    [_lock lock];
    [_dict removeObjectForKey:aKey];
    [_lock unlock];
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject == nil || aKey == nil) {
        return;
    }
    [_lock lock];
    [_dict setObject:anObject forKey:aKey];
    [_lock unlock];
}


- (void)setValue:(id)value forKey:(NSString *)key
{
    if (key == nil) {
        return;
    }
    [_lock lock];
    [_dict setValue:value forKey:key];
    [_lock unlock];
}

- (id)valueForKey:(NSString *)key
{
    if (key == nil) {
        return nil;
    }
    
    [_lock lock];
    id obj = nil;
    obj = [_dict objectForKey:key];
    
    [_lock unlock];
    return obj;
}

- (NSArray*)allKeys
{
    [_lock lock];
    NSArray* keys = [_dict allKeys];
    [_lock unlock];
    return keys;
}

- (NSArray*)allValues
{
    [_lock lock];
    NSArray* values = nil;
    
    if (_bCheckWild) {
        NSMutableArray *tmpArr = [NSMutableArray array];
        
        NSArray* keys = [_dict allKeys];
        for (id key in keys) {
            [tmpArr addObject:[self valueForKey:key]];
        }
        
        values = tmpArr;
    } else {
        values = [_dict allValues];
    }
    
    [_lock unlock];
    return values;
}

- (NSArray*)allKeysForObject:(id) object
{
    [_lock lock];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    if (_bCheckWild) {
        NSArray *keyArr = [_dict allKeys];
        
        for (id key in keyArr) {
            id cacheObj = [self objectForKey:key];
            if ([cacheObj isEqual:object]) {
                [arr addObject:key];
            }
        }
    } else {
        NSArray *keys = [_dict allKeysForObject:object];
        
        [arr addObjectsFromArray:keys];
    }
    
    [_lock unlock];
    return  arr;
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary
{
    if (!otherDictionary) {
        return;
    }
    [_lock lock];
    
    NSArray *keyArr = [otherDictionary allKeys];
    
    for (id key in keyArr) {
        [self setObject:[otherDictionary objectForKey:key] forKey:key];
    }
    
    [_lock unlock];
}

- (void)removeAllObjects
{
    [_lock lock];
    [_dict removeAllObjects];
    [_lock unlock];
}

- (void)removeObjectsForKeys:(NSArray*)keys
{
    if (keys == nil) {
        return;
    }
    
    [_lock lock];
    [_dict removeObjectsForKeys:keys];
    [_lock unlock];
}

- (int)count
{
    [_lock lock];
    int count = (int)_dict.count;
    [_lock unlock];
    
    return count;
}

#pragma mark -实现copy协议
- (id)copyWithZone:(NSZone *)zone{
    QQLockDictionary *lockDict = [[QQLockDictionary allocWithZone:zone]initWithMutableDictionary:_dict];
    lockDict->_dict = _dict;
    return lockDict;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    QQLockDictionary *lockDict = [[QQLockDictionary allocWithZone:zone]initWithMutableDictionary:_dict];
    lockDict->_dict = _dict;
    return lockDict;
}


+ (QQLockDictionary*)dictionaryWithMutableDictionary:(NSMutableDictionary*)dic
{
    QQLockDictionary* lockDic = [[QQLockDictionary alloc] initWithMutableDictionary:dic];
    return lockDic;
}

#pragma mark- QQLockDictionary 安全API

- (id)objectForKey:(id)aKey type:(Class)type
{
    if(!aKey)
    {
        return nil;
    }
    id val = [self objectForKey:aKey];
    return [val isKindOfClass:type] ? val : nil;

}

- (BOOL)boolSafeForKey:(id)key
{
    if(!key)
    {
        return NO;
    }
    return [[self digitalTypeCheckForKey:key] boolValue];
}

- (int)intSafeForKey:(id)key
{
    if(!key)
    {
        return 0;
    }
    return [[self digitalTypeCheckForKey:key] intValue];
}

- (float)floatSafeForKey:(id)key
{
    if(!key)
    {
        return 0;
    }
    return [[self digitalTypeCheckForKey:key] floatValue];
}

- (uint64_t)longSafeForKey:(id)key
{
    if(!key)
    {
        return 0;
    }
    return [[self digitalTypeCheckForKey:key] longLongValue];
}

- (unsigned int)unsignedintSafeForKey:(id)key
{
    if(!key)
    {
        return 0;
    }
    return [[self digitalTypeCheckForKey:key] unsignedIntValue];
}

- (unsigned long long)unsignedlonglongSafeForKey:(id)key
{
    if(!key)
    {
        return 0;
    }
    return [[self digitalTypeCheckForKey:key] unsignedLongLongValue];
}

- (NSInteger)integerSafeForKey:(id)key
{
    if(!key)
    {
        return 0;
    }
    return [[self digitalTypeCheckForKey:key] integerValue];
}

- (NSInteger)integerSafeForKey:(id)key defaultV:(NSInteger)defaultV
{
    if(!key)
    {
        return defaultV;
    }
    
    id val = [self digitalTypeCheckForKey:key];
    return val ? [val integerValue]:defaultV;
}

- (NSString*)stringSafeForKey:(id)key
{
    if(!key)
    {
        return nil;
    }
    id val = [self objectForKey:key];
    return [val isKindOfClass:[NSString class]] ? val : nil;
}


- (NSData*)dataSafeForKey:(id)key
{
    if(!key)
    {
        return nil;
    }
    id val = [self objectForKey:key];
    return [val isKindOfClass:[NSData class]] ? val : nil;
}

- (NSNumber *)numberSafeForKey:(id)key
{
    if(!key)
    {
        return nil;
    }
    id val = [self objectForKey:key];
    return [val isKindOfClass:[NSNumber class]] ? val : nil;
}

- (id)digitalTypeCheckForKey:(id)key{
    if(!key)
    {
        return nil;
    }
    id val = [self objectForKey:key];
    return [val isKindOfClass:[NSNumber class]] || [val isKindOfClass:[NSString class]] ? val : nil;
}

- (id)objectSafeForKey:(id)aKey
{
    if (aKey == nil) {
        return nil;
    }
    id value = [self objectForKey:aKey];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

- (NSDictionary *)dicSafeForKey:(id)key
{
    if(!key)
    {
        return nil;
    }
    id val = [self objectForKey:key];
    return [val isKindOfClass:[NSDictionary class]] ? val : nil;
}

- (NSArray *)arraySafeForKey:(id)key
{
    if(!key)
    {
        return nil;
    }
    id val = [self objectForKey:key];
    return [val isKindOfClass:[NSArray class]] ? val : nil;
}

- (double)doubleSafeForKey:(id)key
{
    return [[self digitalTypeCheckForKey:key] doubleValue];
}

- (NSMutableArray *)mutableArraySafeForKey:(id)key
{
    if (!key)
    {
        return nil;
    }
    id val = [self objectForKey:key];
    return [val isKindOfClass:[NSMutableArray class]] ? val : nil;
}

- (NSMutableDictionary *)mutableDicSafeForKey:(id)key
{
    if (!key)
    {
        return nil;
    }
    id val = [self objectForKey:key];
    return [val isKindOfClass:[NSMutableDictionary class]] ? val : nil;
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (NS_NOESCAPE ^)(id _Nonnull key, id _Nonnull obj, BOOL *stop))block 
{
    [_lock lock];
    [_dict enumerateKeysAndObjectsUsingBlock:block];
    [_lock unlock];
}
@end
