@import Foundation;

@interface NSDictionary (HYPImmutable)

- (NSDictionary *)hyp_removingNulls;

- (NSDictionary *)hyp_removingKey:(id <NSCopying>)key;

- (NSDictionary *)hyp_settingObject:(id)object forKey:(id <NSCopying>)key;

- (NSDictionary *)hyp_appendingDictionary:(NSDictionary *)dictionary;

@end
