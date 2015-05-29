@import Foundation;

#import "FORMField.h"

@interface FORMFieldValue : NSObject

@property (nonatomic) id fieldValueID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *info;
@property (nonatomic) NSArray *targets;
@property (nonatomic) FORMField *field;
@property (nonatomic) id value;
@property (nonatomic, getter = isDefaultValue) BOOL defaultValue;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

- (BOOL)identifierIsEqualTo:(id)identifier;

@end
