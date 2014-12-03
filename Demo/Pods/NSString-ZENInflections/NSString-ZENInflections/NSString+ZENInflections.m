//
//  NSString+ZENInflections.m
//  Mine Ansatte
//
//  Created by Christoffer Winterkvist on 7/2/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "NSString+ZENInflections.h"

@implementation NSString (ZENInflections)
#pragma mark - Class methods

+ (NSString *)zen_stringWithCamelCase:(NSString *)string
{
    return [string zen_camelCase];
}

+ (NSString *)zen_stringWithClassifiedCase:(NSString *)string
{
    return [string zen_classify];
}

+ (NSString *)zen_stringWithDashedCase:(NSString *)string
{
    return [string zen_dashed];
}

+ (NSString *)zen_stringWithUnderscoreCase:(NSString *)string
{
    return [string zen_underscore];
}

+ (NSString *)zen_stringWithHumanizeUppercase:(NSString *)string
{
    return [string zen_humanizeUppercase];
}

+ (NSString *)zen_stringWithHumanizeLowercase:(NSString *)string
{
    return [string zen_humanizeLowercase];
}

#pragma mark - Alias methods

+ (NSString *)zen_stringWithSnakeCase:(NSString *)string
{
    return [string zen_underscore];
}

#pragma mark - Instance methods

- (NSString *)zen_camelCase
{
    return [[[self replaceIdentifierWithString:@""] lowerCaseFirstLetter] copy];
}

- (NSString *)zen_classify
{
    return [self zen_upperCamelCase];
}

- (NSString *)zen_dashed
{
    return [[self lowerCaseFirstLetter] replaceIdentifierWithString:@"-"];
}

- (NSString *)zen_dotNetCase
{
    return [self zen_upperCamelCase];
}

- (NSString *)zen_javascriptCase
{
    return [[[self replaceIdentifierWithString:@""] lowerCaseFirstLetter] copy];
}

- (NSString *)zen_lispCase
{
    return [self zen_dashed];
}

- (NSString *)zen_objcCase
{
    return [self zen_camelCase];
}

- (NSString *)zen_pythonCase
{
	return [self zen_snakeCase];
}

- (NSString *)zen_rubyCase
{
	return [self zen_snakeCase];
}

- (NSString *)zen_snakeCase
{
    return [self zen_underscore];
}

- (NSString *)zen_underscore
{
    return [[self lowerCaseFirstLetter] replaceIdentifierWithString:@"_"];
}

- (NSString *)zen_upperCamelCase
{
    return [[self zen_camelCase] upperCaseFirstLetter];
}

- (NSString *)zen_humanizeUppercase
{
    return [[self replaceIdentifierWithString:@" "] capitalizedString];
}

- (NSString *)zen_humanizeLowercase
{
    return [[self replaceIdentifierWithString:@" "] lowercaseString];
}

#pragma mark - Private methods

- (NSString *)upperCaseFirstLetter
{
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:self];
    NSString *firstLetter = [[mutableString substringToIndex:1] uppercaseString];
    [mutableString replaceCharactersInRange:NSMakeRange(0,1)
                                 withString:firstLetter];
    return [mutableString copy];
}

- (NSString *)lowerCaseFirstLetter
{
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:self];
    NSString *firstLetter = [[mutableString substringToIndex:1] lowercaseString];
    [mutableString replaceCharactersInRange:NSMakeRange(0,1)
                                 withString:firstLetter];
    return [mutableString copy];
}

- (NSString *)replaceIdentifierWithString:(NSString *)replacementString
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    scanner.caseSensitive = YES;

    NSCharacterSet *identifierSet = [NSCharacterSet characterSetWithCharactersInString:@"_- "];

    NSCharacterSet *alphanumericSet = [NSCharacterSet alphanumericCharacterSet];
    NSCharacterSet *uppercaseSet = [NSCharacterSet uppercaseLetterCharacterSet];
    NSCharacterSet *lowercaseSet = [NSCharacterSet lowercaseLetterCharacterSet];

    NSString *buffer = nil;
    NSMutableString *output = [NSMutableString string];

    while (!scanner.isAtEnd) {
        if ([scanner scanCharactersFromSet:identifierSet intoString:&buffer]) {
            continue;
        }

        if ([replacementString length]) {
            if ([scanner scanCharactersFromSet:uppercaseSet intoString:&buffer]) {
                [output appendString:replacementString];
                [output appendString:[buffer lowercaseString]];
            }
            if ([scanner scanCharactersFromSet:lowercaseSet intoString:&buffer]) {
                [output appendString:[buffer lowercaseString]];
            }
        } else {
            if ([scanner scanCharactersFromSet:alphanumericSet intoString:&buffer]) {
                [output appendString:[buffer capitalizedString]];
            }
        }
    }

    return [output copy];
}
@end
