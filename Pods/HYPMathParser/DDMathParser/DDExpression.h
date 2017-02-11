//
//  DDExpression.h
//  DDMathParser
//
//  Created by Dave DeLong on 11/16/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMathParserMacros.h"

typedef NS_ENUM(NSInteger, DDExpressionType) {
	DDExpressionTypeNumber = 0,
	DDExpressionTypeFunction = 1,
	DDExpressionTypeVariable = 2
};

@class DDMathEvaluator, DDParser;

@interface DDExpression : NSObject <NSCoding, NSCopying>

@property (nonatomic, readonly, weak) DDExpression *parentExpression;

+ (id)expressionFromString:(NSString *)expressionString error:(NSError **)error;

+ (id)numberExpressionWithNumber:(NSNumber *)number;
+ (id)functionExpressionWithFunction:(NSString *)function arguments:(NSArray *)arguments error:(NSError **)error;
+ (id)variableExpressionWithVariable:(NSString *)variable;

- (DDExpressionType)expressionType;

- (NSNumber *)evaluateWithSubstitutions:(NSDictionary *)substitutions evaluator:(DDMathEvaluator *)evaluator error:(NSError **)error DDMathParserDeprecated("use -[DDMathEvaluator evaluateExpression:withSubstitutions:error:] instead");

- (DDExpression *)simplifiedExpression;
- (DDExpression *)simplifiedExpressionWithEvaluator:(DDMathEvaluator *)evaluator error:(NSError **)error;

#pragma mark Number methods
@property (readonly) NSNumber *number;

#pragma mark Function methods

@property (readonly) NSString *function;
@property (readonly) NSArray *arguments; // an array of DDExpressions

#pragma mark Variable

@property (readonly) NSString *variable;

@end
