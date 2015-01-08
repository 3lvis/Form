//
//  DDParser.h
//  DDMathParser
//
//  Created by Dave DeLong on 11/24/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDParserTypes.h"

@class DDMathStringTokenizer;
@class DDMathOperatorSet;
@class DDExpression;

@interface DDParser : NSObject

@property (readonly) DDMathOperatorSet *operatorSet;

+ (id)parserWithTokenizer:(DDMathStringTokenizer *)tokenizer error:(NSError **)error;
- (id)initWithTokenizer:(DDMathStringTokenizer *)tokenizer error:(NSError **)error;

+ (id)parserWithString:(NSString *)string error:(NSError **)error;
- (id)initWithString:(NSString *)string error:(NSError **)error;

- (DDExpression *)parsedExpressionWithError:(NSError **)error;
- (DDOperatorAssociativity)associativityForOperatorFunction:(NSString *)function;

@end
