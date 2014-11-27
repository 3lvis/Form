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
