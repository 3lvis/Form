//
//  HYPNorwegianAccountNumber.h
//  HYPNorwegianAccountNumber
//
//  Created by Christoffer Winterkvist on 10/9/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYPNorwegianAccountNumber : NSObject

+ (NSArray *)weightNumbers;
+ (BOOL)validateWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;
- (BOOL)isValid;
- (NSString *)controlNumberString;
- (NSUInteger)controlNumber;

@end
