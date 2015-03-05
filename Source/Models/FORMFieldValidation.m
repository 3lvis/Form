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
        self.minimumLength = [[dictionary andy_valueForKey:@"min_length"] unsignedIntegerValue];
    }
    
    if ([dictionary andy_valueForKey:@"max_length"]) {
        self.maximumLength = [[dictionary andy_valueForKey:@"max_length"] integerValue];
    }
    
    if ([dictionary andy_valueForKey:@"format"]) {
        self.format = [dictionary andy_valueForKey:@"format"];
    }
    
    if ([dictionary andy_valueForKey:@"min_value"]) {
        self.minimumValue = [[dictionary andy_valueForKey:@"min_value"] floatValue];
    }
    
    if ([dictionary andy_valueForKey:@"max_value"]) {
        self.maximumValue = [[dictionary andy_valueForKey:@"max_value"] floatValue];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{required: %@\n, minimumLength: %lu\n, maximumLength: %ld\n, format: %@\n, minimumValue: %f\n, maximumValue: %f\n",
            (self.required) ? @"YES" : @"NO", (unsigned long)self.minimumLength, (long)self.maximumLength,
            self.format, self.minimumValue, self.maximumValue];
}

@end
