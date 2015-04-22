#import "FORMFieldElement.h"

#import "NSDictionary+ANDYSafeValue.h"
#import "ISO8601DateFormatter.h"
#import "FORMFieldValidation.h"

@implementation FORMFieldElement

#pragma mark - Initializers

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) return nil;

    _title = [dictionary andy_valueForKey:@"title"];
    _info = [dictionary andy_valueForKey:@"info"];
    _hidden = [[dictionary andy_valueForKey:@"hidden"] boolValue];

    NSNumber *width = [dictionary andy_valueForKey:@"size.width"];
    NSNumber *height = [dictionary andy_valueForKey:@"size.height"];
    if (height && width) {
        _size = CGSizeMake([width floatValue], [height floatValue]);
    }

    ISO8601DateFormatter *dateFormatter = [ISO8601DateFormatter new];

    NSString *minimumDateString = [dictionary andy_valueForKey:@"minimum_date"];
    if (minimumDateString) {
        _minimumDate = [dateFormatter dateFromString:minimumDateString];
    }

    NSString *maximumDateString = [dictionary andy_valueForKey:@"maximum_date"];
    if (maximumDateString) {
        _maximumDate = [dateFormatter dateFromString:maximumDateString];
    }

    NSDictionary *validations = [dictionary andy_valueForKey:@"validations"];
    if (validations && [validations count] > 0) {
        _validation = [[FORMFieldValidation alloc]
                       initWithDictionary:[dictionary andy_valueForKey:@"validations"]];
    }

    _formula = [dictionary andy_valueForKey:@"formula"];

    return self;
}

@end
