//
//  NSString+HYPWordExtractor.m
//  NSString-HYPWordExtractor
//
//  Created by Christoffer Winterkvist on 13/10/14.
//
//

#import "NSString+HYPWordExtractor.h"

@implementation NSString (HYPWordExtractor)

- (NSArray *)hyp_words
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKOLMNOPQRSTUVWXYZÅÄÆÖØabcdefghijkolmnopqrstuvwxyzåäæöø_"];

    return [self hyp_parseWords:[NSMutableArray new] withCharacterSet:set];
}

- (NSSet *)hyp_uniqueWords
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKOLMNOPQRSTUVWXYZÅÄÆÖØabcdefghijkolmnopqrstuvwxyzåäæöø_"];

    return [self hyp_parseWords:[NSMutableSet new] withCharacterSet:set];
}

- (NSArray *)hyp_variables
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKOLMNOPQRSTUVWXYZÅÄÆÖØabcdefghijkolmnopqrstuvwxyzåäæöø_"];

    return [self hyp_parseWords:[NSMutableArray new] withCharacterSet:set];
}

- (NSSet *)hyp_uniqueVariables
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKOLMNOPQRSTUVWXYZÅÄÆÖØabcdefghijkolmnopqrstuvwxyzåäæöø_"];

    return [self hyp_parseWords:[NSMutableSet new] withCharacterSet:set];
}

#pragma mark - Private methods

- (id)hyp_parseWords:(id)container withCharacterSet:(NSCharacterSet *)set
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSString *word;

    while (!scanner.isAtEnd) {
        if ([scanner scanCharactersFromSet:set intoString:&word]) {
            [container addObject:word];
        }

        if (scanner.scanLocation < self.length)
            scanner.scanLocation++;
    }

    return [container copy];
}

@end
