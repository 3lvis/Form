@import Foundation;

#import "HYPFormField.h"

@interface HYPFieldValue : NSObject

@property (nonatomic, strong) id valueID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSArray *targets;
@property (nonatomic, strong) HYPFormField *field;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic) BOOL defaultValue;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

- (BOOL)identifierIsEqualTo:(id)identifier;

@end
