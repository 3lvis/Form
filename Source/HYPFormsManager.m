#import "HYPFormsManager.h"

@interface HYPFormsManager ()

@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) NSArray *disabledFieldsIDs;

@end

@implementation HYPFormsManager

- (instancetype)initWithJSON:(id)JSON
               initialValues:(NSDictionary *)initialValues
            disabledFieldIDs:(NSArray *)disabledFieldIDs
{
    self = [super init];
    if (!self) return nil;

    [self.values addEntriesFromDictionary:initialValues];

    _disabledFieldsIDs = disabledFieldIDs;

    return self;
}

- (NSMutableDictionary *)values
{
    if (_values) return _values;

    _values = [NSMutableDictionary new];

    return _values;
}

- (NSMutableArray *)forms
{
    if (_forms) return _forms;

    _forms = [NSMutableArray new];

    return _forms;
}

@end
