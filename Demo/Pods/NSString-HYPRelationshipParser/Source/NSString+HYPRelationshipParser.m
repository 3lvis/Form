#import "NSString+HYPRelationshipParser.h"

#import "NSString+ZENInflections.h"

@implementation NSString (HYPRelationshipParser)

- (NSDictionary *)hyp_parseRelationship
{
    NSString *propertyID = [self zen_camelCase];
    if (propertyID) {

        return @{@"attribute" : propertyID};

    } else {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[]."];
        NSRange range = [self rangeOfCharacterFromSet:set];
        BOOL isRelationship = (range.location != NSNotFound);
        if (isRelationship) {

            NSCharacterSet *toManySet = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
            NSRange toManyRange = [self rangeOfCharacterFromSet:toManySet];
            BOOL isToManyRelationship = (toManyRange.location != NSNotFound);
            if (isToManyRelationship) {

                NSScanner *scanner = [NSScanner scannerWithString:self];

                NSString *relationship = nil;

                if ([scanner scanUpToString:@"[" intoString:&relationship]) {
                    scanner.scanLocation++;

                    NSString *objectID = nil;
                    if ([scanner scanUpToString:@"]" intoString:&objectID]) {
                        scanner.scanLocation += 2;

                        NSString *name = nil;
                        if ([scanner scanUpToString:@"\n" intoString:&name]) {

                            if (relationship && objectID && name) {

                                return @{@"relationship" : relationship,
                                         @"id": objectID,
                                         @"to_many" : @YES,
                                         @"attribute": name};
                            }
                        }
                    }
                }

            } else {
                NSArray *elements = [self componentsSeparatedByString:@"."];
                if (elements) {

                    return @{@"relationship" : [elements firstObject],
                             @"to_many" : @NO,
                             @"attribute" : [elements lastObject]};
                }
            }
        }
    }

    return nil;
}

@end
