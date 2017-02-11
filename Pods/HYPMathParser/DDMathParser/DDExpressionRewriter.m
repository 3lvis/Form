//
//  DDExpressionRewriter.m
//  DDMathParser
//
//  Created by Dave DeLong on 1/4/14.
//
//

#import "DDExpressionRewriter.h"
#import "DDExpression.h"
#import "_DDRewriteRule.h"

@implementation DDExpressionRewriter {
    NSMutableArray *_rewriteRules;
}

+ (instancetype)defaultRewriter {
    static DDExpressionRewriter *defaultRewriter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultRewriter = [[self alloc] init];
    });
    return defaultRewriter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _rewriteRules = [NSMutableArray array];
        [self addRewriteRule:@"__exp1" forExpressionsMatchingTemplate:@"0 + __exp1" condition:nil];
        [self addRewriteRule:@"__exp1" forExpressionsMatchingTemplate:@"__exp1 + 0" condition:nil];
        [self addRewriteRule:@"2 * __exp1" forExpressionsMatchingTemplate:@"__exp1 + __exp1" condition:nil];
        
        [self addRewriteRule:@"0" forExpressionsMatchingTemplate:@"__exp1 - __exp1" condition:nil];
        
        [self addRewriteRule:@"__exp1" forExpressionsMatchingTemplate:@"1 * __exp1" condition:nil];
        [self addRewriteRule:@"__exp1" forExpressionsMatchingTemplate:@"__exp1 * 1" condition:nil];
        [self addRewriteRule:@"__exp1 ** 2" forExpressionsMatchingTemplate:@"__exp1 * __exp1" condition:nil];
        [self addRewriteRule:@"__var1 * __num1" forExpressionsMatchingTemplate:@"__num1 * __var1" condition:nil];
        [self addRewriteRule:@"0" forExpressionsMatchingTemplate:@"0 * __exp1" condition:nil];
        [self addRewriteRule:@"0" forExpressionsMatchingTemplate:@"__exp1 * 0" condition:nil];
        
        [self addRewriteRule:@"__exp1" forExpressionsMatchingTemplate:@"--__exp1" condition:nil];
        [self addRewriteRule:@"abs(__exp1)" forExpressionsMatchingTemplate:@"abs(-__exp1)" condition:nil];
        [self addRewriteRule:@"exp(__exp1 + __exp2)" forExpressionsMatchingTemplate:@"exp(__exp1) * exp(__exp2)" condition:nil];
        [self addRewriteRule:@"(__exp1 * __exp2) ** __exp3" forExpressionsMatchingTemplate:@"(__exp1 ** __exp3) * (__exp2 ** __exp3)" condition:nil];
        [self addRewriteRule:@"1" forExpressionsMatchingTemplate:@"__exp1 ** 0" condition:nil];
        [self addRewriteRule:@"__exp1" forExpressionsMatchingTemplate:@"__exp1 ** 1" condition:nil];
        [self addRewriteRule:@"abs(__exp1)" forExpressionsMatchingTemplate:@"sqrt(__exp1 ** 2)" condition:nil];
        
        [self addRewriteRule:@"__exp1" forExpressionsMatchingTemplate:@"dtor(rtod(__exp1))" condition:nil];
        [self addRewriteRule:@"__exp1" forExpressionsMatchingTemplate:@"rtod(dtor(__exp1))" condition:nil];
        
        //division
        [self addRewriteRule:@"1" forExpressionsMatchingTemplate:@"__exp1 / __exp1" condition:@"__exp1 != 0"];
        [self addRewriteRule:@"__exp1" forExpressionsMatchingTemplate:@"(__exp1 * __exp2) / __exp2" condition:@"__exp2 != 0"];
        [self addRewriteRule:@"__exp1" forExpressionsMatchingTemplate:@"(__exp2 * __exp1) / __exp2" condition:@"__exp2 != 0"];
        [self addRewriteRule:@"1/__exp1" forExpressionsMatchingTemplate:@"__exp2 / (__exp2 * __exp1)" condition:@"__exp2 != 0"];
        [self addRewriteRule:@"1/__exp1" forExpressionsMatchingTemplate:@"__exp2 / (__exp1 * __exp2)" condition:@"__exp2 != 0"];
        
        //exponents and roots
        [self addRewriteRule:@"abs(__exp1)" forExpressionsMatchingTemplate:@"nthroot(pow(__exp1, __exp2), __exp2)" condition:@"__exp2 % 2 == 0"];
        [self addRewriteRule:@"__exp1" forExpressionsMatchingTemplate:@"nthroot(pow(__exp1, __exp2), __exp2)" condition:@"__exp2 % 2 == 1"];
        [self addRewriteRule:@"__exp1" forExpressionsMatchingTemplate:@"abs(__exp1)" condition:@"__exp1 >= 0"];
    }
    return self;
}

- (DDExpression *)_rewriteExpression:(DDExpression *)expression usingRule:(_DDRewriteRule *)rule evaluator:(DDMathEvaluator *)evaluator {
    DDExpression *rewritten = [rule expressionByRewritingExpression:expression withEvaluator:evaluator];
    
    // if the rule did not match, return the expression
    if (rewritten == expression && [expression expressionType] == DDExpressionTypeFunction) {
        NSMutableArray *newArguments = [NSMutableArray array];
        BOOL argsChanged = NO;
        for (DDExpression *arg in [expression arguments]) {
            DDExpression *newArg = [self _rewriteExpression:arg usingRule:rule evaluator:evaluator];
            argsChanged |= (newArg != arg);
            [newArguments addObject:newArg];
        }
        
        if (argsChanged) {
            rewritten = [DDExpression functionExpressionWithFunction:[expression function] arguments:newArguments error:nil];
        }
    }
    
    return rewritten;
}

- (DDExpression *)expressionByRewritingExpression:(DDExpression *)expression withEvaluator:(DDMathEvaluator *)evaluator {
    DDExpression *tmp = expression;
    NSUInteger iterationCount = 0;
    
    do {
        NSError *simplificationError = nil;
        tmp = [tmp simplifiedExpressionWithEvaluator:evaluator error:&simplificationError];
        expression = tmp;
        BOOL changed = NO;
        
        for (_DDRewriteRule *rule in _rewriteRules) {
            DDExpression *rewritten = [self _rewriteExpression:tmp usingRule:rule evaluator:evaluator];
            if (rewritten != tmp) {
                tmp = rewritten;
                changed = YES;
            }
        }
        
        // we applied all the rules and nothing changed
        if (!changed) { break; }
        iterationCount++;
    } while (tmp != nil && iterationCount < 256);
    
    if (iterationCount >= 256) {
        NSLog(@"ABORT: replacement limit reached");
    }
    
    return expression;
}

- (void)addRewriteRule:(NSString *)rule forExpressionsMatchingTemplate:(NSString *)templateString condition:(NSString *)condition {
    _DDRewriteRule *rewriteRule = [_DDRewriteRule rewriteRuleWithTemplate:templateString replacementPattern:rule condition:condition];
    [_rewriteRules addObject:rewriteRule];
}

@end
