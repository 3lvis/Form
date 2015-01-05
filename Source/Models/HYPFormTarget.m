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

+ (HYPFormTarget *)enableFieldTargetWithID:(NSString *)targetID
{
    return [self fieldTargetWithID:targetID
                        actionType:HYPFormTargetActionEnable];
}

+ (HYPFormTarget *)disableFieldTargetWithID:(NSString *)targetID
{
    return [self fieldTargetWithID:targetID
                        actionType:HYPFormTargetActionDisable];
}

+ (NSArray *)showFieldTargetsWithIDs:(NSArray *)targetIDs
{
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self showFieldTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)hideFieldTargetsWithIDs:(NSArray *)targetIDs
{
    NSMutableArray *targets = [NSMutableArray new];
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
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self showSectionTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)hideSectionTargetsWithIDs:(NSArray *)targetIDs
{
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self hideSectionTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)enableFieldTargetsWithIDs:(NSArray *)targetIDs
{
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self enableFieldTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)disableFieldTargetsWithIDs:(NSArray *)targetIDs
{
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self disableFieldTargetWithID:targetID]];
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
    } else if ([actionTypeString isEqualToString:@"enable"]) {
        self.actionType = HYPFormTargetActionEnable;
    } else if ([actionTypeString isEqualToString:@"disable"]) {
        self.actionType = HYPFormTargetActionDisable;
    } else {
        self.actionType = HYPFormTargetActionNone;
    }
}

+ (void)filteredTargets:(NSArray*)targets
               filtered:(void (^)(NSArray *shownTargets,
                                  NSArray *hiddenTargets,
                                  NSArray *updatedTargets,
                                  NSArray *enabledTargets,
                                  NSArray *disabledTargets))filtered
{
    NSMutableArray *shown = [NSMutableArray new];
    NSMutableArray *hidden = [NSMutableArray new];
    NSMutableArray *updated = [NSMutableArray new];
    NSMutableArray *enabled = [NSMutableArray new];
    NSMutableArray *disabled = [NSMutableArray new];

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
            case HYPFormTargetActionEnable:
                if (![updated containsObject:target]) [enabled addObject:target];
                break;
            case HYPFormTargetActionDisable:
                if (![updated containsObject:target]) [disabled addObject:target];
                break;
            case HYPFormTargetActionNone:
                break;
        }
    }

    if (filtered) {
        filtered(shown, hidden, updated, enabled, disabled);
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
