#import "FORMFieldBase.h"

#import "NSDictionary+ANDYSafeValue.h"
#import "ISO8601DateFormatter.h"
#import "FORMFieldValidation.h"
#import "FORMFieldValue.h"

@implementation FORMFieldBase

#pragma mark - Initializers

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) return nil;

    _title = [dictionary andy_valueForKey:@"title"];
    _info = [dictionary andy_valueForKey:@"info"];

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
    _value = [dictionary andy_valueForKey:@"value"];

    return self;
}

#pragma mark - Others

- (NSString *)description {
    return [NSString stringWithFormat:@"\n — Field Element: \n title: %@\n info: %@\n minimumDate: %@\n maximumDate: %@\n validations: %@\n formula: %@\n",
            self.title, self.info, self.minimumDate, self.maximumDate, self.validation, self.formula];
}

@end
