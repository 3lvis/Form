#import "HYPPostalCodeManager.h"

@interface HYPPostalCodeManager ()

@property (nonatomic, retain) NSDictionary *postalCodes;

@end

@implementation HYPPostalCodeManager

+ (instancetype)sharedManager
{
    static HYPPostalCodeManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [HYPPostalCodeManager new];
    });

    return _sharedManager;
}

+ (id)JSONObjectWithContentsOfFile:(NSString*)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension]
                                                         ofType:[fileName pathExtension]];

    NSData *data = [NSData dataWithContentsOfFile:filePath];

    NSError *error = nil;

    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    if (error != nil) return nil;

    return result;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    NSArray *JSON = [HYPPostalCodeManager JSONObjectWithContentsOfFile:@"postal_codes.json"];
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];

    for (NSDictionary *entry in JSON) {
        [mutableDictionary setValue:entry[@"City"] forKey:entry[@"Code"]];
    }

    _postalCodes = [mutableDictionary copy];

    return self;
}

- (BOOL)validatePostalCode:(NSString *)postalCode
{
    return (self.postalCodes[postalCode]) ? YES : NO;
}

- (NSString *)cityForPostalCode:(NSString *)postalCode
{
    return (self.postalCodes[postalCode]) ?: nil;
}

@end
