//
//  DDMathParser.h
//  DDMathParser
//
//  Created by Dave DeLong on 11/20/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "DDMathEvaluator.h"
#import "DDExpression.h"
#import "DDParser.h"
#import "DDTypes.h"
#import "DDMathOperator.h"
#import "DDExpressionRewriter.h"
#import "NSString+DDMathParsing.h"

#define DDRuleTemplateAnyNumber @"__num"
#define DDRuleTemplateAnyFunction @"__func"
#define DDRuleTemplateAnyVariable @"__var"
#define DDRuleTemplateAnyExpression @"__exp"
