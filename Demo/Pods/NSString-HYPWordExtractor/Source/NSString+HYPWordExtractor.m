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
    return [self hyp_parseWords:[NSMutableArray new]];
}

- (NSSet *)hyp_uniqueWords
{
    return [self hyp_parseWords:[NSMutableSet new]];
}

#pragma mark - Private methods

- (id)hyp_parseWords:(id)container
{
    NSCharacterSet *validSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKOLMNOPQRSTUVWXYZÅÄÆÖØabcdefghijkolmnopqrstuvwxyzåäæöø_"];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSString *word;
    
    while (!scanner.isAtEnd) {
        if ([scanner scanCharactersFromSet:validSet intoString:&word]) {
            [container addObject:word];
        }

        if (scanner.scanLocation < self.length)
            scanner.scanLocation++;
    }

    return [container copy];
}

@end
