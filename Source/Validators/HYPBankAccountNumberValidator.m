//
//  HYPBankAccountNumberValidator.m
//  Mine Ansatte
//
//  Created by Christoffer Winterkvist on 10/9/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPBankAccountNumberValidator.h"
#import "HYPNorwegianAccountNumber.h"

@implementation HYPBankAccountNumberValidator

- (BOOL)validateFieldValue:(id)fieldValue
{
    if (![super validateFieldValue:fieldValue]) return NO;

    HYPNorwegianAccountNumber *accountNumber = [[HYPNorwegianAccountNumber alloc] initWithString:(NSString *)fieldValue];

#if DEBUG == 1
    return YES;
#else
    return accountNumber.isValid;
#endif
}

@end
