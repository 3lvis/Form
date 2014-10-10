//
//  NSString+ZENInflections.h
//  Mine Ansatte
//
//  Created by Christoffer Winterkvist on 7/2/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZENInflections)

+ (NSString *)zen_stringWithCamelCase:(NSString *)string;
+ (NSString *)zen_stringWithClassifiedCase:(NSString *)string;
+ (NSString *)zen_stringWithDashedCase:(NSString *)string;
+ (NSString *)zen_stringWithUnderscoreCase:(NSString *)string;
+ (NSString *)zen_stringWithHumanizeUppercase:(NSString *)string;
+ (NSString *)zen_stringWithHumanizeLowercase:(NSString *)string;

+ (NSString *)zen_stringWithSnakeCase:(NSString *)string;

- (NSString *)zen_camelCase;
- (NSString *)zen_classify;
- (NSString *)zen_dashed;
- (NSString *)zen_dotNetCase;
- (NSString *)zen_javascriptCase;
- (NSString *)zen_lispCase;
- (NSString *)zen_objcCase;
- (NSString *)zen_pythonCase;
- (NSString *)zen_rubyCase;
- (NSString *)zen_snakeCase;
- (NSString *)zen_underscore;
- (NSString *)zen_upperCamelCase;
- (NSString *)zen_humanizeUppercase;
- (NSString *)zen_humanizeLowercase;


@end
