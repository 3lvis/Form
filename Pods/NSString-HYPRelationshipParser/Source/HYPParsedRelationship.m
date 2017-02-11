#import "HYPParsedRelationship.h"

@implementation HYPParsedRelationship

- (BOOL)isEqual:(HYPParsedRelationship *)object
{
    return ((!self.relationship || [self.relationship isEqualToString:object.relationship]) &&
            (!self.index || [self.index isEqualToNumber:object.index]) &&
            self.toMany == object.toMany &&
            (!self.attribute || [self.attribute isEqualToString:object.attribute]));
}

- (NSString *)key
{
    NSString *composedKey;

    if (self.relationship) {
        if (self.attribute && self.index) {
            composedKey = [NSString stringWithFormat:@"%@[%@].%@", self.relationship, self.index, self.attribute];
        } else if (self.attribute) {
            composedKey = [NSString stringWithFormat:@"%@.%@", self.relationship, self.attribute];
        } else {
            composedKey = [NSString stringWithFormat:@"%@[%@]", self.relationship, self.index];
        }
    } else {
        composedKey = self.attribute;
    }

    return composedKey;
}

@end
