@import Foundation;

#import "FORMField.h"

@interface FORMFieldValue : NSObject

@property (nonatomic) id valueID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *info;
@property (nonatomic) NSArray *targets;
@property (nonatomic) FORMField *field;
@property (nonatomic) NSNumber *value;
@property (nonatomic) BOOL defaultValue;
@property (nonatomic, copy) NSString *accessibilityLabel;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)identifierIsEqualTo:(id)identifier;

@end
