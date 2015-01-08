//
//  DDParser.m
//  DDMathParser
//
//  Created by Dave DeLong on 11/24/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "DDMathParser.h"
#import "DDParser.h"
#import "DDMathParserMacros.h"
#import "_DDParserTerm.h"
#import "DDParserTypes.h"
#import "DDMathStringTokenizer.h"
#import "DDMathStringTokenizer.h"
#import "DDMathStringToken.h"
#import "DDExpression.h"
#import "DDMathOperator_Internal.h"

static inline void DDOperatorSetAssociativity(NSString *o, DDOperatorAssociativity a) {
    DDMathOperator *info = [DDMathOperator infoForOperatorFunction:o];
    info.associativity = a;
}

static inline DDOperatorAssociativity DDOperatorGetAssociativity(NSString *o) {
    DDMathOperator *info = [DDMathOperator infoForOperatorFunction:o];
    return info.associativity;
}

@implementation DDParser {
	DDMathStringTokenizer * _tokenizer;
}

+ (id)parserWithString:(NSString *)string error:(NSError **)error {
    return [[self alloc] initWithString:string error:error];
}

- (id)initWithString:(NSString *)string error:(NSError **)error {
    DDMathStringTokenizer *t = [[DDMathStringTokenizer alloc] initWithString:string operatorSet:nil error:error];
    return [self initWithTokenizer:t error:error];
}

+ (id)parserWithTokenizer:(DDMathStringTokenizer *)tokenizer error:(NSError **)error {
	return [[self alloc] initWithTokenizer:tokenizer error:error];
}

- (id)initWithTokenizer:(DDMathStringTokenizer *)t error:(NSError **)error {
	ERR_ASSERT(error);
	self = [super init];
	if (self) {
        _operatorSet = t.operatorSet;
		_tokenizer = t;
		if (!_tokenizer) {
			return nil;
		}
	}
	return self;
}

- (DDOperatorAssociativity)associativityForOperatorFunction:(NSString *)function {
    DDMathOperator *operator = [_operatorSet operatorForFunction:function];
    return operator.associativity;
}

- (DDExpression *)parsedExpressionWithError:(NSError **)error {
	ERR_ASSERT(error);
	[_tokenizer reset]; //reset the token stream
    
    DDExpression *expression = nil;
    
    _DDParserTerm *root = [_DDParserTerm rootTermWithTokenizer:_tokenizer error:error];
    if ([root resolveWithParser:self error:error]) {
        expression = [root expressionWithError:error];
    }
    
	return expression;
}

@end
