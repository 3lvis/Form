//
//  HYPNorwegianAccountNumber.m
//  HYPNorwegianAccountNumber
//
//  Ref: http://docs.oracle.com/cd/E18727_01/doc.121/e13483/T359831T498954.htm#T498969
//
//  Created by Christoffer Winterkvist on 10/9/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import "HYPNorwegianAccountNumber.h"

@interface HYPNorwegianAccountNumber ()

@property (nonatomic, strong) NSString *accountNumber;

@end

@implementation HYPNorwegianAccountNumber

+ (NSArray *)weightNumbers
{
    return @[@5,@4,@3,@2,@7,@6,@5,@4,@3,@2];
}

+ (BOOL)validateWithString:(NSString *)string
{
    HYPNorwegianAccountNumber *accountNumber = [[HYPNorwegianAccountNumber alloc] initWithString:string];
    return accountNumber.isValid;
}

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (!self) return nil;

    self.accountNumber = string;

    return self;
}

- (BOOL)isValid
{
    if (self.accountNumber.length != 11) return NO;

    if ([self skipValidation]) return YES;

    NSUInteger calculateControlNumber = [self calculate:self.accountNumberWithoutControlNumber withWeightNumbers:[HYPNorwegianAccountNumber weightNumbers]];
    calculateControlNumber = 11 - (calculateControlNumber % 11);

    return (calculateControlNumber == self.controlNumber);
}

- (NSString *)controlNumberString
{
    if (self.accountNumber.length != 11) return nil;

    NSString *substring = [self.accountNumber substringFromIndex:10];

    return substring;
}

- (NSUInteger)controlNumber
{
    NSString *controlNumberString = self.controlNumberString;

    if (!controlNumberString) return 0;

    return [self.controlNumberString intValue];
}

#pragma mark - Private methods

- (NSUInteger)calculate:(NSString *)string withWeightNumbers:(NSArray *)weightNumbers
{
    NSUInteger result = 0;

    for (int index=0; index < string.length; ++index) {
        NSUInteger currentDigit = (NSUInteger)[[string substringWithRange:NSMakeRange(index,1)] integerValue];
        result += [weightNumbers[index] integerValue] * currentDigit;
    }

    return result;
}

- (NSString *)accountNumberWithoutControlNumber
{
    if (self.accountNumber.length != 11) return nil;

    NSString *substring = [self.accountNumber substringToIndex:10];

    return substring;
}

- (BOOL)skipValidation
{
    NSString *subjectA = [self.accountNumber substringWithRange:NSMakeRange(5,1)];
    NSString *subjectB = [self.accountNumber substringWithRange:NSMakeRange(6,1)];

    return ([subjectA isEqualToString:subjectB] && [subjectA isEqualToString:@"0"]);
}

@end
