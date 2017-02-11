//
//  DDMathStringToken.h
//  DDMathParser
//
//  Created by Dave DeLong on 11/16/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDParserTypes.h"

typedef NS_ENUM(NSInteger, DDTokenType) {
	DDTokenTypeNumber = 0,
	DDTokenTypeOperator = 1,
	DDTokenTypeFunction = 2,
	DDTokenTypeVariable = 3
};

@class DDMathOperator;

@interface DDMathStringToken : NSObject

+ (id)mathStringTokenWithToken:(NSString *)t type:(DDTokenType)type;

@property (nonatomic, readonly) NSString *token;
@property (nonatomic, readonly) DDTokenType tokenType;

@property (nonatomic, readonly) NSString *operatorType;
@property (nonatomic, readonly) DDOperatorArity operatorArity;
@property (nonatomic, readonly) DDOperatorAssociativity operatorAssociativity;
@property (nonatomic, readonly) NSInteger operatorPrecedence;
@property (nonatomic, readonly) NSString *operatorFunction;

@property (nonatomic, readonly) NSNumber *numberValue;

- (void)resolveToOperatorFunction:(NSString *)function;

@end
