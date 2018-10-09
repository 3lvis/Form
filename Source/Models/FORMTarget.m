#import "FORMTarget.h"


#import "NSDictionary+ANDYSafeValue.h"

@interface FORMTarget ()
@end

@implementation FORMTarget

#pragma mark - Initializers

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) return nil;

    _targetID = [dictionary andy_valueForKey:@"id"];
    self.typeString = [dictionary andy_valueForKey:@"type"];
    self.actionTypeString = [dictionary andy_valueForKey:@"action"];
    self.targetValue = [dictionary andy_valueForKey:@"target_value"];
    self.condition = [dictionary andy_valueForKey:@"condition"];

    return self;
}

+ (FORMTarget *)fieldTargetWithID:(NSString *)targetID
                 actionTypeString:(NSString *)actionTypeString {
    return [self targetWithID:targetID
                   typeString:@"field"
             actionTypeString:actionTypeString];
}

+ (FORMTarget *)sectionTargetWithID:(NSString *)targetID
                   actionTypeString:(NSString *)actionTypeString {
    return [self targetWithID:targetID
                   typeString:@"section"
             actionTypeString:actionTypeString];
}

+ (FORMTarget *)targetWithID:(NSString *)targetID
                  typeString:(NSString *)typeString
            actionTypeString:(NSString *)actionTypeString {
    FORMTarget *target = [FORMTarget new];
    target.targetID = targetID;
    target.typeString = typeString;
    target.actionTypeString = actionTypeString;

    return target;
}

#pragma mark - Setters

- (void)setTypeString:(NSString *)typeString {
    _typeString = typeString;

    if ([typeString isEqualToString:@"field"]) {
        self.type = FORMTargetTypeField;
    } else if ([typeString isEqualToString:@"section"]) {
        self.type = FORMTargetTypeSection;
    } else {
        self.type = FORMTargetTypeNone;
    }
}

- (void)setActionTypeString:(NSString *)actionTypeString {
    _actionTypeString = actionTypeString;

    if ([actionTypeString isEqualToString:@"show"]) {
        self.actionType = FORMTargetActionShow;
    } else if ([actionTypeString isEqualToString:@"hide"]) {
        self.actionType = FORMTargetActionHide;
    } else if ([actionTypeString isEqualToString:@"update"]){
        self.actionType = FORMTargetActionUpdate;
    } else if ([actionTypeString isEqualToString:@"enable"]) {
        self.actionType = FORMTargetActionEnable;
    } else if ([actionTypeString isEqualToString:@"disable"]) {
        self.actionType = FORMTargetActionDisable;
    } else if ([actionTypeString isEqualToString:@"clear"]) {
        self.actionType = FORMTargetActionClear;
    } else {
        self.actionType = FORMTargetActionNone;
    }
}

#pragma mark - Field target

+ (FORMTarget *)showFieldTargetWithID:(NSString *)targetID {
    return [self fieldTargetWithID:targetID
                  actionTypeString:@"show"];
}

+ (FORMTarget *)hideFieldTargetWithID:(NSString *)targetID {
    return [self fieldTargetWithID:targetID
                  actionTypeString:@"hide"];
}

+ (FORMTarget *)enableFieldTargetWithID:(NSString *)targetID {
    return [self fieldTargetWithID:targetID
                  actionTypeString:@"enable"];
}

+ (FORMTarget *)disableFieldTargetWithID:(NSString *)targetID {
    return [self fieldTargetWithID:targetID
                  actionTypeString:@"disable"];
}

+ (FORMTarget *)updateFieldTargetWithID:(NSString *)targetID {
    return [self fieldTargetWithID:targetID
                  actionTypeString:@"update"];
}

+ (FORMTarget *)clearFieldTargetWithID:(NSString *)targetID {
    return [self fieldTargetWithID:targetID
                  actionTypeString:@"clear"];
}

#pragma mark - Field targets

+ (NSArray *)showFieldTargetsWithIDs:(NSArray *)targetIDs {
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self showFieldTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)hideFieldTargetsWithIDs:(NSArray *)targetIDs {
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self hideFieldTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)enableFieldTargetsWithIDs:(NSArray *)targetIDs {
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self enableFieldTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)disableFieldTargetsWithIDs:(NSArray *)targetIDs {
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self disableFieldTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)updateFieldTargetsWithIDs:(NSArray *)targetIDs {
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self updateFieldTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)clearFieldTargetsWithIDs:(NSArray *)targetIDs {
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self clearFieldTargetWithID:targetID]];
    }

    return targets;
}

#pragma mark - Section target

+ (FORMTarget *)showSectionTargetWithID:(NSString *)targetID {
    return [self sectionTargetWithID:targetID
                    actionTypeString:@"show"];
}

+ (FORMTarget *)hideSectionTargetWithID:(NSString *)targetID {
    return [self sectionTargetWithID:targetID
                    actionTypeString:@"hide"];
}

+ (FORMTarget *)enableSectionTargetWithID:(NSString *)targetID {
    return [self sectionTargetWithID:targetID
                    actionTypeString:@"enable"];
}

+ (FORMTarget *)disableSectionTargetWithID:(NSString *)targetID {
    return [self sectionTargetWithID:targetID
                    actionTypeString:@"disable"];
}

+ (FORMTarget *)updateSectionTargetWithID:(NSString *)targetID {
    return [self sectionTargetWithID:targetID
                    actionTypeString:@"update"];
}

#pragma mark - Section targets

+ (NSArray *)showSectionTargetsWithIDs:(NSArray *)targetIDs {
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self showSectionTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)hideSectionTargetsWithIDs:(NSArray *)targetIDs {
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self hideSectionTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)enableSectionTargetsWithIDs:(NSArray *)targetIDs {
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self enableSectionTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)disableSectionTargetsWithIDs:(NSArray *)targetIDs {
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self disableSectionTargetWithID:targetID]];
    }

    return targets;
}

+ (NSArray *)updateSectionTargetsWithIDs:(NSArray *)targetIDs {
    NSMutableArray *targets = [NSMutableArray new];
    for (NSString *targetID in targetIDs) {
        [targets addObject:[self updateSectionTargetWithID:targetID]];
    }

    return targets;
}

+ (void)filteredTargets:(NSArray*)targets
               filtered:(void (^)(NSArray *shownTargets,
                                  NSArray *hiddenTargets,
                                  NSArray *updatedTargets,
                                  NSArray *enabledTargets,
                                  NSArray *disabledTargets))filtered {
    NSMutableArray *shown = [NSMutableArray new];
    NSMutableArray *hidden = [NSMutableArray new];
    NSMutableArray *updated = [NSMutableArray new];
    NSMutableArray *enabled = [NSMutableArray new];
    NSMutableArray *disabled = [NSMutableArray new];

    // TODO: balance show + hide
    // TODO: balance update + hide

    for (FORMTarget *target in targets) {

        if (target.value.field.type == FORMFieldTypeMultiSelect) {
            switch (target.actionType) {
                case FORMTargetActionShow:
                case FORMTargetActionHide:
                // selected XOR hide action
                if ((target.actionType == FORMTargetActionHide) != (target.value.selected)) {
                    if (![shown containsObject:target]) [shown addObject:target];
                } else {
                    if (![hidden containsObject:target]) [hidden addObject:target];
                }
                break;
                case FORMTargetActionEnable:
                case FORMTargetActionDisable:
                // selected XOR disable action
                if ((target.actionType == FORMTargetActionDisable) != (target.value.selected)) {
                    if (![enabled containsObject:target]) [enabled addObject:target];
                } else {
                    if (![disabled containsObject:target]) [disabled addObject:target];
                }
                break;
                case FORMTargetActionClear:
                case FORMTargetActionUpdate:
                if (![updated containsObject:target]) [updated addObject:target];
                break;
                case FORMTargetActionNone:
                break;
            }
        } else {
        switch (target.actionType) {
            case FORMTargetActionShow:
                if (![shown containsObject:target]) [shown addObject:target];
                break;
            case FORMTargetActionHide:
                if (![hidden containsObject:target]) [hidden addObject:target];
                break;
            case FORMTargetActionClear:
            case FORMTargetActionUpdate:
                if (![updated containsObject:target]) [updated addObject:target];
                break;
            case FORMTargetActionEnable:
                if (![enabled containsObject:target]) [enabled addObject:target];
                break;
            case FORMTargetActionDisable:
                if (![disabled containsObject:target]) [disabled addObject:target];
                break;
            case FORMTargetActionNone:
                break;
            }
        }
    }

    if (filtered) {
        filtered(shown, hidden, updated, enabled, disabled);
    }
}

- (BOOL)isEqual:(FORMTarget *)object {
    BOOL sameTargetID = (object.targetID == nil ||
                         [object.targetID isEqualToString:self.targetID]);

    BOOL sameCondition = (object.condition == nil ||
                          [object.condition isEqualToString:self.condition]);

    BOOL sameTargetValue = (object.targetValue == nil ||
                            [object.targetValue isEqual:self.targetValue]);

    BOOL equal = (sameTargetID &&
                  object.actionType == self.actionType &&
                  object.type == self.type &&
                  sameCondition &&
                  sameTargetValue);

    if (equal && self.value && object.value) {
        equal = ([self.value identifierIsEqualTo:object.value.valueID]);
    }

    return equal;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n — Target: %@ —\n value: %@\n type: %@\n action type: %@\n condition: %@\n",
            self.targetID, self.targetValue, self.typeString, self.actionTypeString, self.condition];
}

@end
