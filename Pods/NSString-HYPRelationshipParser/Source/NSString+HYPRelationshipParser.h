@import Foundation;

@class HYPParsedRelationship;

@interface NSString (HYPRelationshipParser)

- (HYPParsedRelationship *)hyp_parseRelationship;

- (NSString *)hyp_updateRelationshipIndex:(NSInteger)index;

@end
