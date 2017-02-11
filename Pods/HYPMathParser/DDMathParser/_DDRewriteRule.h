//
//  _DDRewriteRule.h
//  DDMathParser
//
//  Created by Dave DeLong on 9/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDExpression;

@interface _DDRewriteRule : NSObject

+ (_DDRewriteRule *)rewriteRuleWithTemplate:(NSString *)string replacementPattern:(NSString *)replacement condition:(NSString *)condition;

- (BOOL)ruleMatchesExpression:(DDExpression *)target withEvaluator:(DDMathEvaluator *)evaluator;

// returns nil if the rule does not match the target expression
- (DDExpression *)expressionByRewritingExpression:(DDExpression *)target withEvaluator:(DDMathEvaluator *)evaluator;

@end
