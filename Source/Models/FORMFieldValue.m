#import "FORMFieldValue.h"

#import "FORMTarget.h"

#import "NSDictionary+ANDYSafeValue.h"

@implementation FORMFieldValue

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) return nil;

    _valueID = [dictionary andy_valueForKey:@"id"];
    _title = [dictionary andy_valueForKey:@"title"];
    _info = [dictionary andy_valueForKey:@"info"];
    _value = [dictionary andy_valueForKey:@"value"];
    _defaultValue = [[dictionary andy_valueForKey:@"default"] boolValue];

    NSMutableArray *targets = [NSMutableArray new];

    for (NSDictionary *targetDict in [dictionary andy_valueForKey:@"targets"]) {
        FORMTarget *target = [[FORMTarget alloc] initWithDictionary:targetDict];
        [targets addObject:target];
    }

    for (FORMTarget *target in targets) {
        target.value = self;
    }

    _targets = targets;

    return self;
}

- (BOOL)identifierIsEqualTo:(id)identifier {
    if (!identifier) return NO;

    if ([self.valueID isKindOfClass:[NSString class]]) {
        return [self.valueID isEqualToString:identifier];
    } else if ([self.valueID isKindOfClass:[NSNumber class]]) {
        return [self.valueID isEqualToNumber:identifier];
    } else if ([self.valueID isKindOfClass:[NSDate class]]) {
        return [self.valueID isEqualToDate:identifier];
    } else {
        abort();
    }

    return NO;
}

@end
