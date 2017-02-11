#import "NSString+HYPWordExtractor.h"

static NSString *const HYPWordCharacterSet = @"0123456789ABCDEFGHIJKOLMNOPQRSTUVWXYZÅÄÆÖØabcdefghijkolmnopqrstuvwxyzåäæöø_";
static NSString *const HYPVariableCharacterSet = @"ABCDEFGHIJKOLMNOPQRSTUVWXYZÅÄÆÖØabcdefghijkolmnopqrstuvwxyzåäæöø_[.]0123456789";

@implementation NSString (HYPWordExtractor)

- (NSArray *)hyp_words {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:HYPWordCharacterSet];

    return [self hyp_parseWords:[NSMutableArray new]
               withCharacterSet:set];
}

- (NSSet *)hyp_uniqueWords {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:HYPWordCharacterSet];

    return [self hyp_parseWords:[NSMutableSet new]
               withCharacterSet:set];
}

- (NSArray *)hyp_variables {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:HYPVariableCharacterSet];

    return [self cleanupNumericVariables:[self hyp_parseWords:[NSMutableArray new]
                                             withCharacterSet:characterSet]];
}

- (NSSet *)hyp_uniqueVariables {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:HYPVariableCharacterSet];

    NSMutableSet *mutableSet = [NSMutableSet new];

    [mutableSet addObjectsFromArray:[self cleanupNumericVariables:[self hyp_parseWords:[NSMutableSet new]
                                                                      withCharacterSet:characterSet]]];

    return [mutableSet copy];
}

#pragma mark - Private methods

- (id)hyp_parseWords:(id)container withCharacterSet:(NSCharacterSet *)set {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSString *word;

    while (!scanner.isAtEnd) {
        if ([scanner scanCharactersFromSet:set intoString:&word]) {
            [container addObject:word];
        }

        if (scanner.scanLocation < self.length) {
            scanner.scanLocation++;
        }
    }

    return [container copy];
}

- (NSArray *)cleanupNumericVariables:(NSArray *)array {
    NSCharacterSet *numericSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];

    for (NSString *variable in array) {
        if ([[variable stringByTrimmingCharactersInSet:numericSet] isEqualToString:@""]) {
            [mutableArray removeObject:variable];
        }
    }

    return [mutableArray copy];
}

@end
