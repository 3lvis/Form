//
//  _DDGroupTerm.h
//  DDMathParser
//
//  Created by Dave DeLong on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "_DDParserTerm.h"

@interface _DDGroupTerm : _DDParserTerm

@property (nonatomic,readonly,strong) NSMutableArray *subterms;

- (id)_initWithSubterms:(NSArray *)terms error:(NSError **)error;
- (void)_setSubterms:(NSArray *)newTerms;

@end
