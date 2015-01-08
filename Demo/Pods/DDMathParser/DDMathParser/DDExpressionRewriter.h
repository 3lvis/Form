//
//  DDExpressionRewriter.h
//  DDMathParser
//
//  Created by Dave DeLong on 1/4/14.
//
//

#import <Foundation/Foundation.h>

@class DDExpression, DDMathEvaluator;

@interface DDExpressionRewriter : NSObject

+ (instancetype)defaultRewriter;

- (void)addRewriteRule:(NSString *)rule forExpressionsMatchingTemplate:(NSString *)templateString condition:(NSString *)condition;
- (DDExpression *)expressionByRewritingExpression:(DDExpression *)expression withEvaluator:(DDMathEvaluator *)evaluator;

@end
