//
//  NSString+HYPFormula.h
//  HYPFormula
//
//  Created by Christoffer Winterkvist on 13/10/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (HYPFormula)

- (NSString *)hyp_processValues:(NSDictionary *)dictionary;
- (id)hyp_runFormula;
- (id)hyp_runFormulaWithDictionary:(NSDictionary *)dictionary;

@end
