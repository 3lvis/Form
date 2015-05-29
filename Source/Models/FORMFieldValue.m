#import "FORMFieldValue.h"

#import "FORMTarget.h"

#import "NSDictionary+ANDYSafeValue.h"

@implementation FORMFieldValue

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) return nil;

    _fieldValueID = [dictionary andy_valueForKey:@"id"];
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
        target.fieldValue = self.fieldValueID;
    }

    _targets = targets;

    return self;
}

- (BOOL)identifierIsEqualTo:(id)identifier {
    if (!identifier) return NO;

    if ([self.fieldValueID isKindOfClass:[NSString class]]) {
        return [self.fieldValueID isEqualToString:identifier];
    } else if ([self.fieldValueID isKindOfClass:[NSNumber class]]) {
        return [self.fieldValueID isEqualToNumber:identifier];
    } else if ([self.fieldValueID isKindOfClass:[NSDate class]]) {
        return [self.fieldValueID isEqualToDate:identifier];
    } else {
        abort();
    }

    return NO;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"\n — Field value: %@ —\n title: %@\n Info: %@\n Value: %@\n defaultValue: %@\n Targets: %@\n",
            self.fieldValueID, self.title, self.info, self.value, self.isDefaultValue ? @"YES" : @"NO", self.targets];
}

@end
