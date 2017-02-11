//
//  DDMathParserMacros.h
//  DDMathParser
//
//  Created by Dave DeLong on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DDTypes.h"

#ifndef ERR_ASSERT
#define ERR_ASSERT(_e) NSAssert((_e) != nil, @"NULL out error")
#endif

#ifndef ERR
#define ERR(_c,_f,...) [NSError errorWithDomain:DDMathParserErrorDomain code:(_c) userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:(_f), ##__VA_ARGS__]}]
#endif

#define DDMathParserDeprecated(_r) __attribute__((deprecated(_r)))
