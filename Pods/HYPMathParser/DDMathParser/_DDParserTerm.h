//
//  _DDParserTerm.h
//  DDMathParser
//
//  Created by Dave DeLong on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DDMathParser.h"

@class DDMathStringToken;
@class DDMathStringTokenizer;
@class DDParser;
@class DDExpression;

typedef NS_ENUM(NSInteger, DDParserTermType) {
    DDParserTermTypeNumber = 1,
    DDParserTermTypeVariable,
    DDParserTermTypeOperator,
    DDParserTermTypeFunction,
    DDParserTermTypeGroup
};

@interface _DDParserTerm : NSObject

@property (nonatomic,getter=isResolved) BOOL resolved;
@property (nonatomic,readonly) DDParserTermType type;
@property (nonatomic,readonly,strong) DDMathStringToken *token;

+ (id)rootTermWithTokenizer:(DDMathStringTokenizer *)tokenizer error:(NSError **)error;
+ (id)termWithTokenizer:(DDMathStringTokenizer *)tokenizer error:(NSError **)error;
- (id)_initWithTokenizer:(DDMathStringTokenizer *)tokenizer error:(NSError **)error;

- (BOOL)resolveWithParser:(DDParser *)parser error:(NSError **)error;
- (DDExpression *)expressionWithError:(NSError **)error;

@end
