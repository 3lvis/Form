#import "FORMFieldValue.h"

#import "FORMTarget.h"

#import "NSDictionary+ANDYSafeValue.h"

@implementation FORMFieldValue

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) return nil;

    _valueID = [dictionary andy_valueForKey:@"id"];
    _title = NSLocalizedString([dictionary andy_valueForKey:@"title"], nil);
    _info = NSLocalizedString([dictionary andy_valueForKey:@"info"], nil);
    _value = [dictionary andy_valueForKey:@"value"];
    _defaultValue = [[dictionary andy_valueForKey:@"default"] boolValue];
    _accessibilityLabel = NSLocalizedString([dictionary andy_valueForKey:@"accessibility_label"], nil);
    
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
    if (!identifier || !self.valueID) return NO;

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
