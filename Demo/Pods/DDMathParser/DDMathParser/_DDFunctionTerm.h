//
//  _DDFunctionTerm.h
//  DDMathParser
//
//  Created by Dave DeLong on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_DDGroupTerm.h"

@interface _DDFunctionTerm : _DDGroupTerm

@property (nonatomic,readonly,strong) NSString *functionName;

- (id)_initWithFunction:(NSString *)function subterms:(NSArray *)terms error:(NSError **)error;

@end
