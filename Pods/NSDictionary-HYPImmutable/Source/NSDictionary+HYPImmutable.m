#import "NSDictionary+HYPImmutable.h"

@implementation NSDictionary (HYPImmutable)

- (NSDictionary *)hyp_removingNulls
{
    NSMutableArray *keysForNulls = [NSMutableArray new];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNull class]]) {
            [keysForNulls addObject:key];
        }
    }];

    NSMutableDictionary *values = [self mutableCopy];
    [values removeObjectsForKeys:keysForNulls];

    return [values copy];
}

- (NSDictionary *)hyp_removingKey:(id <NSCopying>)key
{
    NSMutableDictionary *dictionary = [self mutableCopy];
    [dictionary removeObjectForKey:key];

    return [dictionary copy];
}

- (NSDictionary *)hyp_settingObject:(id)object forKey:(id <NSCopying>)key
{
    NSMutableDictionary *dictionary = [self mutableCopy];
    dictionary[key] = object;

    return [dictionary copy];
}

- (NSDictionary *)hyp_appendingDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *mutableDictionary = [self mutableCopy];
    [mutableDictionary addEntriesFromDictionary:dictionary];

    return [mutableDictionary copy];
}
@end
