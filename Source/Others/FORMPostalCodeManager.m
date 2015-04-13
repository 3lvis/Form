@import UIKit;

#import "FORMPostalCodeManager.h"

#import "NSJSONSerialization+ANDYJSONFile.h"

@interface FORMPostalCodeManager ()

@property (nonatomic, retain) NSDictionary *postalCodes;

@end

@implementation FORMPostalCodeManager

+ (instancetype)sharedManager
{
    static FORMPostalCodeManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [FORMPostalCodeManager new];
    });

    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    id appDelegate = [[UIApplication sharedApplication] delegate];
    Class bundleClass = (appDelegate) ? [appDelegate class] : [self class];

    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"postal_codes.json"
                                                             inBundle:[NSBundle bundleForClass:bundleClass]];
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
