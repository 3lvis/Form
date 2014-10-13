//
//  HYPSocialSecurityNumberValidation.m
//  Mine Ansatte
//
//  Created by Christoffer Winterkvist on 10/8/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPSocialSecurityNumberValidator.h"
#import "HYPNorwegianSSN.h"

@implementation HYPSocialSecurityNumberValidator

- (BOOL)validateFieldValue:(id)fieldValue
{
    if (![super validateFieldValue:fieldValue]) return NO;

    HYPNorwegianSSN *ssn = [[HYPNorwegianSSN alloc] initWithString:(NSString *)fieldValue];

    return ssn.isValid;
}

@end
