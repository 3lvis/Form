@import Foundation;

@interface HYPParsedRelationship : NSObject

@property (nonatomic) NSString *relationship;
@property (nonatomic) NSNumber *index;
@property (nonatomic) BOOL toMany;
@property (nonatomic) NSString *attribute;

- (NSString *)key;

@end
