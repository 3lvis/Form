#import "HYPFormTarget.h"
#import "NSDictionary+ANDYSafeValue.h"

@implementation HYPFormTarget

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (!self) return nil;

    _targetID = [dictionary andy_valueForKey:@"id"];
    self.typeString = [dictionary andy_valueForKey:@"type"];
    self.actionTypeString = [dictionary andy_valueForKey:@"action"];

    return self;
}

+ (HYPFormTarget *)showFieldTargetWithID:(NSString *)targetID
{
    return [self fieldTargetWithID:targetID
                        actionType:HYPFormTargetActionShow];
}

+ (HYPFormTarget *)hideFieldTargetWithID:(NSString *)targetID
{
    return [self fieldTargetWithID:targetID
                        actionType:HYPFormTargetActionHide];
}

+ (NSArray *)showFieldTargetsWithIDs:(NSArray *)targetIDs
{
    NSMutableArray *targets = [NSMutableArray array];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self showFieldTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)hideFieldTargetsWithIDs:(NSArray *)targetIDs
{
    NSMutableArray *targets = [NSMutableArray array];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self hideFieldTargetWithID:targetID]];
    }

    return targets;
}

+ (HYPFormTarget *)showSectionTargetWithID:(NSString *)targetID
{
    return [self sectionTargetWithID:targetID
                          actionType:HYPFormTargetActionShow];
}

+ (HYPFormTarget *)hideSectionTargetWithID:(NSString *)targetID
{
    return [self sectionTargetWithID:targetID
                          actionType:HYPFormTargetActionHide];
}

+ (NSArray *)showSectionTargetsWithIDs:(NSArray *)targetIDs
{
    NSMutableArray *targets = [NSMutableArray array];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self showSectionTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)hideSectionTargetsWithIDs:(NSArray *)targetIDs
{
    NSMutableArray *targets = [NSMutableArray array];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self hideSectionTargetWithID:targetID]];
    }

    return targets;
}

+ (HYPFormTarget *)fieldTargetWithID:(NSString *)targetID
                          actionType:(HYPFormTargetActionType)actionType
{
    return [self targetWithID:targetID
                         type:HYPFormTargetTypeField
                   actionType:actionType];
}

+ (HYPFormTarget *)sectionTargetWithID:(NSString *)targetID
                            actionType:(HYPFormTargetActionType)actionType
{
    return [self targetWithID:targetID
                         type:HYPFormTargetTypeSection
                   actionType:actionType];
}

+ (HYPFormTarget *)targetWithID:(NSString *)targetID
                           type:(HYPFormTargetType)type
                     actionType:(HYPFormTargetActionType)actionType
{
    HYPFormTarget *target = [HYPFormTarget new];
    target.targetID = targetID;
    target.type = type;
    target.actionType = actionType;

    return target;
}

#pragma mark - Setters

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
