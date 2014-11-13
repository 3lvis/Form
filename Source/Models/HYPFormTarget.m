#import "HYPFormTarget.h"

@implementation HYPFormTarget

- (void)setTypeString:(NSString *)typeString
{
    _typeString = typeString;

    if ([typeString isEqualToString:@"field"]) {
        self.type = HYPFormTargetTypeField;
    } else if ([typeString isEqualToString:@"section"]) {
        self.type = HYPFormTargetTypeSection;
    } else {
        self.type = HYPFormTargetTypeNone;
    }
}

- (void)setActionTypeString:(NSString *)actionTypeString
{
    _actionTypeString = actionTypeString;

    if ([actionTypeString isEqualToString:@"show"]) {
        self.actionType = HYPFormTargetActionShow;
    } else if ([actionTypeString isEqualToString:@"hide"]) {
        self.actionType = HYPFormTargetActionHide;
    } else if ([actionTypeString isEqualToString:@"update"]){
        self.actionType = HYPFormTargetActionUpdate;
    } else {
        self.actionType = HYPFormTargetActionNone;
    }
}

+ (void)filteredTargets:(NSArray*)targets
               filtered:(void (^)(NSArray *shownTargets,
                                  NSArray *hiddenTargets,
                                  NSArray *updatedTargets))filtered
{
    NSMutableArray *shown = [NSMutableArray array];
    NSMutableArray *hidden = [NSMutableArray array];
    NSMutableArray *updated = [NSMutableArray array];

    // TODO: balance show + hide
    // TODO: balance update + hide

    for (HYPFormTarget *target in targets) {

        switch (target.actionType) {
            case HYPFormTargetActionShow:
                if (![shown containsObject:target]) [shown addObject:target];
                break;
            case HYPFormTargetActionHide:
                if (![hidden containsObject:target]) [hidden addObject:target];
                break;
            case HYPFormTargetActionUpdate:
                if (![updated containsObject:target]) [updated addObject:target];
                break;
            case HYPFormTargetActionNone:
                break;
        }
    }

    if (filtered) {
        filtered(shown, hidden, updated);
    }
}

- (BOOL)isEqual:(HYPFormTarget *)object
{
    BOOL equal = ([object.targetID isEqualToString:self.targetID] &&
            object.actionType == self.actionType &&
            object.type == self.type);

    if (equal && self.value && object.value) {
        equal = ([self.value identifierIsEqualTo:object.value.valueID]);
    }

    return equal;
}

@end
