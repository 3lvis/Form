//
//  NSString+HYPFormula.h
//  HYPFormula
//
//  Created by Christoffer Winterkvist on 13/10/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (HYPFormulaTest)
- (NSString *)sanitize;
- (BOOL)isStringFormula:(NSArray *)values;
- (BOOL)isValidExpression;
@end

@interface NSString (HYPFormula)

- (NSString *)hyp_processValues:(NSDictionary *)dictionary;
- (id)hyp_runFormulaWithDictionary:(NSDictionary *)dictionary;

@end
