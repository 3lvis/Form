//
//  __DDFunctionUtilities.h
//  DDMathParser
//
//  Created by Dave DeLong on 12/21/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDTypes.h"
#import "DDMathParserMacros.h"

#define REQUIRE_N_ARGS(__n) { \
if ([arguments count] != (__n)) { \
if (error != nil) { \
*error = ERR(DDErrorCodeInvalidNumberOfArguments, @"%@ requires %d argument%@", NSStringFromSelector(_cmd), (__n), ((__n) == 1 ? @"" : @"s")); \
} \
return nil; \
} \
}

#define REQUIRE_GTOE_N_ARGS(__n) { \
if ([arguments count] < (__n)) { \
if (error != nil) { \
*error = ERR(DDErrorCodeInvalidNumberOfArguments, @"%@ requires at least %d argument%@", NSStringFromSelector(_cmd), (__n), ((__n) == 1 ? @"" : @"s")); \
} \
return nil; \
} \
}

#define RETURN_IF_NIL(_n) if ((_n) == nil) { return nil; }

extern DDExpression* _DDDTOR(DDExpression *e, DDMathEvaluator *evaluator, NSError **error);
extern DDExpression* _DDRTOD(DDExpression *e, DDMathEvaluator *evaluator, NSError **error);

@class _DDFunctionExpression;

@interface _DDFunctionEvaluator : NSObject

+ (NSOrderedSet *)standardFunctions;
+ (BOOL)isStandardFunction:(NSString *)functionName;

- (id)initWithMathEvaluator:(DDMathEvaluator *)evaluator;

@property (readonly, weak) DDMathEvaluator *evaluator;

- (DDExpression *)evaluateFunction:(_DDFunctionExpression *)expression variables:(NSDictionary *)variables error:(NSError **)error;

@end
