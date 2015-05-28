@import Foundation;

@interface NSString (FORMCondition)

- (BOOL)evaluateWithValues:(NSDictionary *)values error:(NSError **)error;

@end
