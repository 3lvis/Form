#import "FORMFieldValidation.h"
#import "NSDictionary+ANDYSafeValue.h"

@implementation FORMFieldValidation

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (!self) return nil;

    self.required = [[dictionary andy_valueForKey:@"required"] boolValue];

    self.minimumLength = 0;
    if ([dictionary andy_valueForKey:@"min_length"]) {
        self.minimumLength = [dictionary andy_valueForKey:@"min_length"];
    }

    self.maximumLength = [dictionary andy_valueForKey:@"max_length"];

    self.format = [dictionary andy_valueForKey:@"format"];

    self.minimumValue = [dictionary andy_valueForKey:@"min_value"];

    self.maximumValue = [dictionary andy_valueForKey:@"max_value"];
    self.compareRule = [dictionary andy_valueForKey:@"compare_rule"];
    self.compareToFieldID = [dictionary andy_valueForKey:@"compare_to"];

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{required: %@\n, minimumLength: %@\n, maximumLength: %@\n, format: %@\n, minimumValue: %@\n, maximumValue: %@\n",
            (self.required) ? @"YES" : @"NO", self.minimumLength, self.maximumLength,
            self.format, self.minimumValue, self.maximumValue];
}

@end
