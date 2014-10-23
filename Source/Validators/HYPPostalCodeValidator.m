//
//  HYPPostalCodeValidator.m
//  HYPForms
//
//  Created by Christoffer Winterkvist on 23/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPPostalCodeValidator.h"
#import "HYPPostalCodeManager.h"

@implementation HYPPostalCodeValidator

- (BOOL)validateFieldValue:(id)fieldValue
{
    return ([[HYPPostalCodeManager sharedManager] validatePostalCode:fieldValue]) ?: NO;
}

@end
