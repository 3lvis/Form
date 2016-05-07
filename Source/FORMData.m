#import "FORMData.h"

#import "FORMGroup.h"
#import "FORMSection.h"
#import "FORMField.h"
#import "FORMFieldValue.h"
#import "FORMTarget.h"
#import "DDMathParser.h"
#import "FORMFieldValidation.h"
#import "HYPParsedRelationship.h"

#import "NSString+HYPFormula.h"
#import "NSDictionary+ANDYSafeValue.h"
#import "NSString+HYPWordExtractor.h"
#import "NSString+HYPContainsString.h"
#import "DDMathEvaluator+FORM.h"
#import "NSString+HYPRelationshipParser.h"
#import "NSDictionary+HYPNestedAttributes.h"
@import HYPMathParser.DDExpression;

@interface FORMData ()

@property (nonatomic) DDMathEvaluator *evaluator;
@property (nonatomic) BOOL disabledForm;

@end

@implementation FORMData

- (instancetype)initWithJSON:(id)JSON
               initialValues:(NSDictionary *)initialValues
            disabledFieldIDs:(NSArray *)disabledFieldIDs
                    disabled:(BOOL)disabled {
    self = [super init];
    if (!self) return nil;

    _disabledFieldsIDs = disabledFieldIDs;
    _disabledForm = disabled;

    [self.values addEntriesFromDictionary:initialValues];

    [self generateFormsWithJSON:JSON
                  initialValues:initialValues
              disabledFieldsIDs:disabledFieldIDs
                       disabled:disabled];

    return self;
}

#pragma mark - Getters

- (NSMutableArray *)groups {
    if (_groups) return _groups;

    _groups = [NSMutableArray new];

    return _groups;
}

- (NSMutableDictionary *)hiddenFieldsAndFieldIDsDictionary {
    if (_hiddenFieldsAndFieldIDsDictionary) return _hiddenFieldsAndFieldIDsDictionary;

    _hiddenFieldsAndFieldIDsDictionary = [NSMutableDictionary new];

    return _hiddenFieldsAndFieldIDsDictionary;
}

- (NSMutableDictionary *)hiddenSections {
    if (_hiddenSections) return _hiddenSections;

    _hiddenSections = [NSMutableDictionary new];

    return _hiddenSections;
}

- (NSArray *)disabledFieldsIDs {
    if (_disabledFieldsIDs) return _disabledFieldsIDs;

    _disabledFieldsIDs = [NSArray new];

    return _disabledFieldsIDs;
}

- (NSMutableDictionary *)values {
    if (_values) return _values;

    _values = [NSMutableDictionary new];

    return _values;
}

- (NSMutableDictionary *)removedValues {
    if (_removedValues) return _removedValues;

    _removedValues = [NSMutableDictionary new];

    return _removedValues;
}

- (NSMutableDictionary *)sectionTemplatesDictionary {
    if (_sectionTemplatesDictionary) return _sectionTemplatesDictionary;

    _sectionTemplatesDictionary = [NSMutableDictionary new];

    return _sectionTemplatesDictionary;
}

- (NSMutableDictionary *)fieldTemplatesDictionary {
    if (_fieldTemplatesDictionary) return _fieldTemplatesDictionary;

    _fieldTemplatesDictionary = [NSMutableDictionary new];

    return _fieldTemplatesDictionary;
}

- (DDMathEvaluator *)evaluator {
    if (_evaluator) return _evaluator;

    _evaluator = [DDMathEvaluator defaultMathEvaluator];

    NSDictionary *functionDictonary = [DDMathEvaluator hyp_directoryFunctions];
    __weak typeof(self)weakSelf = self;

    [functionDictonary enumerateKeysAndObjectsUsingBlock:^(id key, id function, BOOL *stop) {
        [weakSelf.evaluator registerFunction:function forName:key];
    }];

    return _evaluator;
}

- (void)generateFormsWithJSON:(id)JSON
                initialValues:(NSDictionary *)initialValues
            disabledFieldsIDs:(NSArray *)disabledFieldsIDs
                     disabled:(BOOL)disabled {
    NSMutableArray *hideTargets = [NSMutableArray new];
    NSMutableArray *updateTargets = [NSMutableArray new];
    NSMutableArray *disabledFields = [NSMutableArray new];

    [disabledFields addObjectsFromArray:disabledFieldsIDs];

    NSArray *groups;

    if ([JSON isKindOfClass:[NSArray class]]) {
        groups = JSON;
    } else if ([JSON isKindOfClass:[NSDictionary class]]) {
        groups = [JSON valueForKey:@"groups"];

        NSDictionary *templates = [JSON andy_valueForKey:@"templates"];
        NSArray *fieldTemplates = [templates andy_valueForKey:@"fields"];
        [fieldTemplates enumerateObjectsUsingBlock:^(NSDictionary *fieldDictionary, NSUInteger idx, BOOL *stop) {
            NSString *fieldID = [fieldDictionary andy_valueForKey:@"id"];
            if (fieldID) {
                self.fieldTemplatesDictionary[fieldID] = fieldDictionary;
            }
        }];

        NSArray *sectionsTemplates = [templates andy_valueForKey:@"sections"];
        [sectionsTemplates enumerateObjectsUsingBlock:^(NSDictionary *sectionDictionary, NSUInteger idx, BOOL *stop) {
            NSString *sectionID = [sectionDictionary andy_valueForKey:@"id"];
            if (sectionID) {
                self.sectionTemplatesDictionary[sectionID] = sectionDictionary;
            }
        }];
    } else {
        NSLog(@"Not a valid JSON format");
        abort();
    }

    [groups enumerateObjectsUsingBlock:^(NSDictionary *groupDictionary, NSUInteger groupIndex, BOOL *stop) {

        FORMGroup *group = [[FORMGroup alloc] initWithDictionary:groupDictionary
                                                        position:groupIndex
                                                        disabled:disabled
                                               disabledFieldsIDs:disabledFieldsIDs];

        for (NSString *sectionTemplateID in self.sectionTemplatesDictionary) {
            NSArray *valueIDs = [[self.values allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            for (NSString *valueID in valueIDs) {
                if ([valueID hyp_containsString:sectionTemplateID]) {
                    NSArray *components = [valueID componentsSeparatedByString:@"."];
                    if (components.count > 1) {
                        NSString *sectionID = [components firstObject];

                        FORMSection *existingSection;
                        for (FORMSection *section in group.sections) {
                            if ([section.sectionID isEqualToString:sectionID]) {
                                existingSection = section;
                            }
                        }

                        if (existingSection) {
                            FORMField *field = [self fieldWithID:valueID
                                           includingHiddenFields:YES];
                            field.value = (self.values)[valueID];
                        } else {
                            [self insertTemplateSectionWithID:sectionTemplateID
                                           intoCollectionView:nil
                                                   usingGroup:group];
                        }
                    }
                }
            }
        }


        for (FORMField *field in group.fields) {

            if (field.hidden){
                [hideTargets addObject:[FORMTarget hideFieldTargetWithID:field.fieldID]];
            }

            if ([initialValues andy_valueForKey:field.fieldID]) {
                if (field.type == FORMFieldTypeSelect) {
                    for (FORMFieldValue *value in field.values) {

                        BOOL isInitialValue = ([value identifierIsEqualTo:[initialValues andy_valueForKey:field.fieldID]]);
                        if (isInitialValue) {
                            field.value = value;
                        }
                    }
                } else {
                    field.value = [initialValues andy_valueForKey:field.fieldID];
                }
            } else if (field.value) {
                self.values[field.fieldID] = field.value;
            }

            for (FORMFieldValue *fieldValue in field.values) {

                id initialValue = [initialValues andy_valueForKey:field.fieldID];

                BOOL fieldHasInitialValue = (initialValue != nil);
                if (fieldHasInitialValue) {

                    BOOL fieldValueMatchesInitialValue = ([fieldValue identifierIsEqualTo:initialValue]);
                    if (fieldValueMatchesInitialValue) {

                        for (FORMTarget *target in fieldValue.targets) {
                            if ([self evaluateCondition:target.condition]) {
                                if (target.actionType == FORMTargetActionHide) {
                                    [hideTargets addObject:target];
                                }
                                if (target.actionType == FORMTargetActionUpdate) {
                                    [updateTargets addObject:target];
                                }
                                if (target.actionType == FORMTargetActionDisable) {
                                    [disabledFields addObject:target.targetID];
                                }
                            }
                        }
                    }
                } else {
                    BOOL shouldUseDefaultValue = (fieldValue.defaultValue && !field.value);
                    if (shouldUseDefaultValue) {
                        field.value = fieldValue;
                        self.values[field.fieldID] = fieldValue.valueID;

                        for (FORMTarget *target in fieldValue.targets) {
                            if ([self evaluateCondition:target.condition]) {
                                if (target.actionType == FORMTargetActionHide) {
                                    [hideTargets addObject:target];
                                }
                                if (target.actionType == FORMTargetActionUpdate) {
                                    [updateTargets addObject:target];
                                }
                                if (target.actionType == FORMTargetActionDisable) {
                                    [disabledFields addObject:target.targetID];
                                }
                            }
                        }
                    }
                }
            }
        }

        [self.groups addObject:group];
    }];

    self.disabledFieldsIDs = disabledFields;
    [self updateTargets:updateTargets];

    for (FORMTarget *target in hideTargets) {
        if ([self evaluateCondition:target.condition]) {

            if (target.type == FORMTargetTypeField) {

                FORMField *field = [self fieldWithID:target.targetID
                               includingHiddenFields:YES];
                [self.hiddenFieldsAndFieldIDsDictionary addEntriesFromDictionary:@{target.targetID : field}];

            } else if (target.type == FORMTargetTypeSection) {

                FORMSection *section = [self sectionWithID:target.targetID];
                [self.hiddenSections addEntriesFromDictionary:@{target.targetID : section}];
            }
        }
    }

    for (FORMTarget *target in hideTargets) {
        if ([self evaluateCondition:target.condition]) {
            if (target.type == FORMTargetTypeField) {

                FORMField *field = [self fieldWithID:target.targetID
                               includingHiddenFields:NO];
                if (field) {
                    FORMSection *section = [self sectionWithID:field.section.sectionID];
                    [section removeField:field
                                inGroups:self.groups];
                    [section resetFieldPositions];
                }

            } else if (target.type == FORMTargetTypeSection) {

                FORMSection *section = [self sectionWithID:target.targetID];
                if (section) {
                    FORMGroup *group = section.group;
                    [group removeSection:section];
                }
            }
        }
    }
}

- (NSDictionary *)invalidFormFields {
    NSMutableDictionary *invalidFormFields = [NSMutableDictionary new];

    for (FORMGroup *group in self.groups) {
        for (FORMSection *section in group.sections) {
            for (FORMField *field in section.fields) {
                BOOL fieldIsValid = (field.validation && [field validate] != YES);
                if (fieldIsValid) {
                    invalidFormFields[field.fieldID] = field;
                }
            }
        }
    }

    return [invalidFormFields copy];
}

- (NSDictionary *)requiredFields {
    NSMutableDictionary *requiredFields = [NSMutableDictionary new];

    for (FORMGroup *group in self.groups) {
        for (FORMSection *section in group.sections) {
            for (FORMField *field in section.fields) {
                if (field.validation && field.validation.isRequired) {
                    requiredFields[field.fieldID] = field;
                }
            }
        }
    }

    return [requiredFields copy];
}

- (NSDictionary *)requiredFormFields {
    return self.requiredFields;
}

- (NSMutableDictionary *)valuesForFormula:(FORMField *)field {
    NSMutableDictionary *values = [NSMutableDictionary new];

    NSString *formula = field.formula;
    NSArray *fieldIDs = [formula hyp_variables];

    for (NSString *fieldID in fieldIDs) {
        FORMField *targetField = [self fieldWithID:fieldID
                             includingHiddenFields:YES];
        id value = targetField.value;
        if (value) {
            if (targetField.type == FORMFieldTypeSelect) {
                FORMFieldValue *fieldValue = targetField.value;
                if (fieldValue.value) {
                    [values addEntriesFromDictionary:@{fieldID : fieldValue.value}];
                }
            } else {
                if ([value isKindOfClass:[NSString class]] && [value length] > 0) {
                    [values addEntriesFromDictionary:@{fieldID : value}];
                } else {
                    if ([value respondsToSelector:NSSelectorFromString(@"stringValue")]) {
                        [values addEntriesFromDictionary:@{fieldID : [value stringValue]}];
                    } else {
                        [values addEntriesFromDictionary:@{fieldID : @""}];
                    }
                }
            }
        } else {
            if (field.type == FORMFieldTypeNumber || field.type == FORMFieldTypeFloat || field.type == FORMFieldTypeCount) {
                [values addEntriesFromDictionary:@{fieldID : @"0"}];
            } else {
                [values addEntriesFromDictionary:@{fieldID : @""}];
            }
        }
    }

    return values;
}

#pragma mark - Group

- (FORMGroup *)groupWithID:(NSString *)groupID {
    FORMGroup *foundGroup;
    for (FORMGroup *group in self.groups) {
        if ([group.groupID isEqualToString:groupID]) {
            foundGroup = group;
            break;
        }
    }

    return foundGroup;
}

#pragma mark - Sections

- (FORMSection *)sectionWithID:(NSString *)sectionID {
    FORMSection *foundSection = nil;

    for (FORMGroup *group in self.groups) {
        for (FORMSection *aSection in group.sections) {
            if ([aSection.sectionID isEqualToString:sectionID]) {
                foundSection = aSection;
                break;
            }
        }
    }

    return foundSection;
}

- (void)sectionWithID:(NSString *)sectionID
           completion:(void (^)(FORMSection *section, NSArray *indexPaths))completion {
    FORMSection *foundSection = nil;
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSUInteger groupIndex = 0;

    for (FORMGroup *group in self.groups) {

        NSInteger fieldsIndex = 0;

        for (FORMSection *aSection in group.sections) {

            for (__unused FORMField *aField in aSection.fields) {
                if ([aSection.sectionID isEqualToString:sectionID]) {
                    foundSection = aSection;
                    [indexPaths addObject:[NSIndexPath indexPathForRow:fieldsIndex inSection:groupIndex]];
                }

                fieldsIndex++;
            }
        }

        groupIndex++;
    }

    if (completion) {
        completion(foundSection, indexPaths);
    }
}

- (void)updateHiddenSectionsPositionsInGroup:(FORMGroup *)group usingOffset:(NSInteger)offset withDelta:(NSInteger)delta {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group = %@ && position > %ld", group, offset];

    NSArray *hiddenSections = [[self.hiddenSections allValues] filteredArrayUsingPredicate:predicate];

    [hiddenSections enumerateObjectsUsingBlock:^(FORMSection *section, NSUInteger idx, BOOL *stop) {
        section.position = @([section.position integerValue] + delta);
    }];
}

#pragma mark - Field

- (FORMField *)fieldWithID:(NSString *)fieldID
     includingHiddenFields:(BOOL)includingHiddenFields {
    NSParameterAssert(fieldID);

    FORMField *foundField = nil;

    NSInteger groupIndex = 0;
    for (FORMGroup *group in self.groups) {

        NSUInteger fieldIndex = 0;
        for (FORMField *field in group.fields) {

            if ([field.fieldID isEqualToString:fieldID]) {
                foundField = field;
                break;
            }

            ++fieldIndex;
        }

        ++groupIndex;
    }

    if (!foundField && includingHiddenFields) {
        foundField = [self hiddenFieldWithFieldID:fieldID];
    }

    return foundField;
}

- (void)fieldWithID:(NSString *)fieldID
includingHiddenFields:(BOOL)includingHiddenFields
         completion:(void (^)(FORMField *field, NSIndexPath *indexPath))completion {
    NSParameterAssert(fieldID);

    __block FORMField *foundField = nil;
    __block NSIndexPath *indexPath = nil;

    NSInteger groupIndex = 0;
    for (FORMGroup *group in self.groups) {

        NSUInteger fieldIndex = 0;
        for (FORMField *field in group.fields) {

            if ([field.fieldID isEqualToString:fieldID]) {
                indexPath = [NSIndexPath indexPathForItem:fieldIndex
                                                inSection:groupIndex];
                foundField = field;
                break;
            }

            ++fieldIndex;
        }

        ++groupIndex;
    }

    if (!foundField && includingHiddenFields) {
        foundField = [self hiddenFieldWithFieldID:fieldID];
    }

    if (completion) completion(foundField, indexPath);
}

- (void)removeSection:(FORMSection *)removedSection
     inCollectionView:(UICollectionView *)collectionView {
    NSDictionary *removedAttributesJSON = [self.removedValues hyp_JSONNestedAttributes];
    HYPParsedRelationship *parsed = [removedSection.sectionID hyp_parseRelationship];
    NSArray *removedElements = removedAttributesJSON[parsed.relationship];
    NSInteger removedElementsCount = removedElements.count;

    NSMutableArray *removedKeys = [NSMutableArray new];
    [self.values enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([key hasPrefix:removedSection.sectionID]) {
            [removedKeys addObject:key];
        }
    }];

    for (NSString *removedKey in removedKeys) {
        NSString *newRemovedKey = [removedKey hyp_updateRelationshipIndex:removedElementsCount];
        [self.removedValues setValue:self.values[removedKey]
                              forKey:newRemovedKey];
        [self.values removeObjectForKey:removedKey];
    }

    NSDictionary *attributesJSON = [self.values hyp_JSONNestedAttributes];

    NSMutableArray *removedRelationshipKeys = [NSMutableArray new];
    [[self.values copy] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        HYPParsedRelationship *currentParsed = [key hyp_parseRelationship];
        if ([parsed.relationship isEqualToString:currentParsed.relationship]) {
            [removedRelationshipKeys addObject:key];
        }
    }];

    [self.values removeObjectsForKeys:removedRelationshipKeys];

    NSArray *elements = attributesJSON[parsed.relationship];
    NSInteger relationshipIndex = 0;

    for (NSDictionary *element in elements) {
        for (NSString *key in element) {
            NSString *relationshipKey = [NSString stringWithFormat:@"%@[%ld].%@", parsed.relationship, (long)relationshipIndex, key];
            self.values[relationshipKey] = element[key];
        }
        relationshipIndex++;
    }

    NSString *sectionID = removedSection.sectionID;
    FORMGroup *group = removedSection.group;
    [self sectionWithID:sectionID
             completion:^(FORMSection *foundSection, NSArray *indexPaths) {
                 FORMGroup *foundForm = foundSection.group;
                 [foundForm.sections removeObject:foundSection];
                 [collectionView deleteItemsAtIndexPaths:indexPaths];
             }];

    relationshipIndex = 0;
    NSInteger position = 0;
    for (FORMSection *currentSection in group.sections) {
        currentSection.position = @(position);
        position++;

        HYPParsedRelationship *parsedSection = [sectionID hyp_parseRelationship];
        HYPParsedRelationship *parsedCurrentSection = [currentSection.sectionID hyp_parseRelationship];
        if (parsedSection.toMany &&
            [parsedSection.relationship isEqualToString:parsedCurrentSection.relationship]) {
            NSInteger newRelationshipIndex = relationshipIndex;
            currentSection.sectionID = [currentSection.sectionID hyp_updateRelationshipIndex:newRelationshipIndex];

            for (FORMField *field in currentSection.fields) {
                field.fieldID = [field.fieldID hyp_updateRelationshipIndex:newRelationshipIndex];
            }
            relationshipIndex++;
        }
    }
}

- (FORMField *)hiddenFieldWithFieldID:(NSString *)fieldID {
    NSArray *hiddenFields = [self.hiddenFieldsAndFieldIDsDictionary allValues];
    FORMField *foundField;

    for (FORMField *formField in hiddenFields) {
        if ([formField.fieldID isEqualToString:fieldID]) {
            foundField = formField;
        }
    }

    if (!foundField) {

        NSArray *deletedSections = [self.hiddenSections allValues];

        for (FORMSection *section in deletedSections) {
            for (FORMField *field in section.fields) {
                if ([field.fieldID isEqualToString:fieldID]) {
                    foundField = field;
                }
            }
        }
    }

    return foundField;
}

- (void)indexForFieldWithID:(NSString *)fieldID
            inSectionWithID:(NSString *)sectionID
                 completion:(void (^)(FORMSection *section, NSInteger index))completion {
    FORMSection *section = [self sectionWithID:sectionID];

    __block NSInteger index = 0;

    NSUInteger idx = 0;
    for (FORMField *aField in section.fields) {
        if ([aField.fieldID isEqualToString:fieldID]) {
            index = idx;
            break;
        }

        idx++;
    }

    if (completion) {
        completion(section, index);
    }
}

- (NSArray *)showTargets:(NSArray *)targets {
    NSMutableArray *insertedIndexPaths = [NSMutableArray new];

    for (FORMTarget *target in targets) {
        if (![self evaluateCondition:target.condition]) continue;

        __block BOOL shouldLookForField = YES;
        if (target.type == FORMTargetTypeField) {
            [self fieldWithID:target.targetID includingHiddenFields:NO
                   completion:^(FORMField *field, NSIndexPath *indexPath) {
                       shouldLookForField = (field == nil);
                   }];
        }

        if (shouldLookForField) {
            BOOL foundSection = NO;

            if (target.type == FORMTargetTypeField) {
                FORMField *field = (self.hiddenFieldsAndFieldIDsDictionary)[target.targetID];
                if (field) {
                    [self updateValuesFromFields:@[field]];

                    FORMGroup *group = self.groups[[field.section.group.position integerValue]];

                    for (FORMSection *section in group.sections) {
                        if ([section.sectionID isEqualToString:field.section.sectionID]) {
                            foundSection = YES;
                            NSInteger fieldIndex = [field indexInSectionUsingGroups:self.groups];
                            [section.fields insertObject:field atIndex:fieldIndex];
                            [section resetFieldPositions];
                        }
                    }
                }
            } else if (target.type == FORMTargetTypeSection) {
                FORMSection *section = (self.hiddenSections)[target.targetID];
                if (section) {
                    [self updateValuesFromFields:section.fields];

                    NSInteger sectionIndex = [section indexInGroups:self.groups];
                    FORMGroup *group = self.groups[[section.group.position integerValue]];
                    [group.sections insertObject:section atIndex:sectionIndex];
                    [group resetSectionPositions];

                    [self updateHiddenSectionsPositionsInGroup:group
                                                   usingOffset:sectionIndex
                                                     withDelta:1];
                }
            }

            if (target.type == FORMTargetTypeField && foundSection) {
                FORMField *field = (self.hiddenFieldsAndFieldIDsDictionary)[target.targetID];
                if (field) {
                    [self fieldWithID:target.targetID includingHiddenFields:YES completion:^(FORMField *field, NSIndexPath *indexPath) {
                        if (field) {
                            [self updateValuesFromFields:@[field]];
                            [insertedIndexPaths addObject:indexPath];
                        }

                        [self.hiddenFieldsAndFieldIDsDictionary removeObjectForKey:target.targetID];
                    }];
                }
            } else if (target.type == FORMTargetTypeSection) {
                FORMSection *section = (self.hiddenSections)[target.targetID];
                if (section) {
                    [self sectionWithID:target.targetID completion:^(FORMSection *section, NSArray *indexPaths) {
                        if (section) {
                            [self updateValuesFromFields:section.fields];
                            [insertedIndexPaths addObjectsFromArray:indexPaths];
                            [self.hiddenSections removeObjectForKey:section.sectionID];
                        }
                    }];
                }
            }
        }
    }

    return insertedIndexPaths;
}

- (NSArray *)hideTargets:(NSArray *)targets {
    NSMutableArray *deletedFields = [NSMutableArray new];
    NSMutableArray *deletedSections = [NSMutableArray new];

    for (FORMTarget *target in targets) {
        if (![self evaluateCondition:target.condition]) continue;

        if (target.type == FORMTargetTypeField) {
            FORMField *field = [self fieldWithID:target.targetID includingHiddenFields:NO];
            if (field && !(self.hiddenFieldsAndFieldIDsDictionary)[field.fieldID]) {
                [deletedFields addObject:field];
                [self.hiddenFieldsAndFieldIDsDictionary addEntriesFromDictionary:@{field.fieldID : field}];
                [self.values removeObjectForKey:field.fieldID];
            }
        } else if (target.type == FORMTargetTypeSection) {
            FORMSection *section = [self sectionWithID:target.targetID];
            if (section && !(self.hiddenSections)[section.sectionID]) {
                [deletedSections addObject:section];
                [self.hiddenSections addEntriesFromDictionary:@{section.sectionID : section}];
                for (FORMField *field in section.fields) {
                    [self.values removeObjectForKey:field.fieldID];
                }

                [self updateHiddenSectionsPositionsInGroup:section.group
                                               usingOffset:[section.position integerValue]
                                                 withDelta:-1];
            }
        }
    }

    NSMutableSet *deletedIndexPaths = [NSMutableSet set];

    for (FORMField *field in deletedFields) {
        [self fieldWithID:field.fieldID includingHiddenFields:YES
               completion:^(FORMField *field, NSIndexPath *indexPath) {
                   if (field) {
                       [deletedIndexPaths addObject:indexPath];
                   }
               }];
    }

    for (FORMSection *section in deletedSections) {
        [self sectionWithID:section.sectionID
                 completion:^(FORMSection *foundSection, NSArray *indexPaths) {
                     if (foundSection) {
                         [deletedIndexPaths addObjectsFromArray:indexPaths];
                     }
                 }];
    }

    NSMutableSet *resetSections = [NSMutableSet new];

    for (FORMField *field in deletedFields) {
        [self indexForFieldWithID:field.fieldID
                  inSectionWithID:field.section.sectionID
                       completion:^(FORMSection *section, NSInteger index) {
                           if (section) {
                               [section.fields removeObjectAtIndex:index];
                               [resetSections addObject:section];
                           }
                       }];
    }

    for (FORMSection *section in deletedSections) {
        FORMGroup *group = self.groups[[section.group.position integerValue]];

        __block NSInteger index = 0;
        __block BOOL found = NO;
        [group.sections enumerateObjectsUsingBlock:^(FORMSection *aSection, NSUInteger idx, BOOL *stop) {
            if (found) {
                aSection.position = @([aSection.position integerValue] - 1);
            }

            if ([aSection.sectionID isEqualToString:section.sectionID]) {
                index = idx;
                found = YES;
            }
        }];

        if (found) {
            [group.sections removeObjectAtIndex:index];
        }
    }

    return [deletedIndexPaths allObjects];
}

- (NSArray *)updateTargets:(NSArray *)targets {
    NSMutableArray *updatedIndexPaths = [NSMutableArray new];

    for (FORMTarget *target in targets) {

        BOOL shouldContinue = (![self evaluateCondition:target.condition] ||
                               target.type == FORMTargetTypeSection ||
                               (self.hiddenFieldsAndFieldIDsDictionary)[target.targetID]);

        if (shouldContinue) {
            continue;
        }


        __block FORMField *field = nil;

        [self fieldWithID:target.targetID includingHiddenFields:YES completion:^(FORMField *foundField, NSIndexPath *indexPath) {
            if (foundField) {
                field = foundField;
                if (indexPath) {
                    [updatedIndexPaths addObject:indexPath];
                }
            }
        }];

        if (field) {
            if (target.targetValue) {

                if (field.type == FORMFieldTypeSelect) {
                    FORMFieldValue *selectedFieldValue = [field selectFieldValueWithValueID:target.targetValue];

                    if (selectedFieldValue) {
                        (self.values)[field.fieldID] = selectedFieldValue.valueID;
                        field.value = selectedFieldValue;
                    }

                } else {
                    field.value = target.targetValue;
                    (self.values)[field.fieldID] = field.value;
                }

            } else if (target.actionType == FORMTargetActionClear) {
                field.value = nil;
                (self.values)[field.fieldID] = [NSNull null];
            } else if (field.formula) {
                NSArray *fieldIDs = [field.formula hyp_variables];
                NSMutableDictionary *values = [NSMutableDictionary new];

                for (NSString *fieldID in fieldIDs) {

                    id value = (self.values)[fieldID];
                    BOOL isNumericField = (field.type == FORMFieldTypeFloat || field.type == FORMFieldTypeNumber || field.type == FORMFieldTypeCount);
                    NSString *defaultEmptyValue = (isNumericField) ? @"0" : @"";

                    FORMField *targetField = [self fieldWithID:fieldID includingHiddenFields:YES];

                    if (targetField.type == FORMFieldTypeSelect) {

                        if ([targetField.value isKindOfClass:[FORMFieldValue class]]) {

                            FORMFieldValue *fieldValue = targetField.value;

                            if (fieldValue.value) {
                                [values addEntriesFromDictionary:@{fieldID : fieldValue.value}];
                            }
                        } else {
                            FORMFieldValue *foundFieldValue = nil;
                            for (FORMFieldValue *fieldValue in field.values) {
                                if ([fieldValue identifierIsEqualTo:field.value]) {
                                    foundFieldValue = fieldValue;
                                }
                            }
                            if (foundFieldValue && foundFieldValue.value) {
                                [values addEntriesFromDictionary:@{fieldID : foundFieldValue.value}];
                            }
                        }

                    } else if (value) {
                        if ([value isKindOfClass:[NSString class]]) {
                            if ([value length] == 0) {
                                value = defaultEmptyValue;
                            }
                            [values addEntriesFromDictionary:@{fieldID : value}];
                        } else {
                            if ([value respondsToSelector:NSSelectorFromString(@"stringValue")]) {
                                (self.values)[field.fieldID] = [value stringValue];
                                [values addEntriesFromDictionary:@{fieldID : [value stringValue]}];
                            } else {
                                (self.values)[field.fieldID] = @"";
                                [values addEntriesFromDictionary:@{fieldID : defaultEmptyValue}];
                            }
                        }
                    } else {
                        [values addEntriesFromDictionary:@{fieldID : defaultEmptyValue}];
                    }
                }

                field.formula = [field.formula stringByReplacingOccurrencesOfString:@"$"
                                                                         withString:@""];
                id result = [field.formula hyp_runFormulaWithValuesDictionary:values];
                field.value = result;

                if (result) {
                    (self.values)[field.fieldID] = result;
                } else {
                    [self.values removeObjectForKey:field.fieldID];
                }
            }
        }
    }

    return updatedIndexPaths;
}

- (NSArray *)enableTargets:(NSArray *)targets {
    return [self updateTargets:targets
                   withEnabled:YES];
}

- (NSArray *)disableTargets:(NSArray *)targets {
    return [self updateTargets:targets
                   withEnabled:NO];
}

- (NSArray *)updateTargets:(NSArray *)targets
               withEnabled:(BOOL)enabled {
    NSMutableArray *indexPaths = [NSMutableArray new];

    for (FORMTarget *target in targets) {
        if (![self evaluateCondition:target.condition]) continue;
        if (target.type == FORMTargetTypeSection) continue;
        if ((self.hiddenFieldsAndFieldIDsDictionary)[target.targetID]) continue;

        [self fieldWithID:target.targetID includingHiddenFields:YES completion:^(FORMField *field, NSIndexPath *indexPath) {
            if (field) {
                field.disabled = !enabled;
                if (indexPath) {
                    [indexPaths addObject:indexPath];
                }
            }
        }];
    }

    return indexPaths;
}

- (void)indexForSection:(FORMSection *)section
                  group:(FORMGroup *)group
             completion:(void (^)(BOOL found, NSInteger index))completion {
    __block NSInteger index = 0;
    __block BOOL found = NO;
    [group.sections enumerateObjectsUsingBlock:^(FORMSection *aSection, NSUInteger idx, BOOL *stop) {
        if ([aSection.sectionID isEqualToString:section.sectionID]) {
            index = idx;
            found = YES;
            *stop = YES;
        }
    }];

    if (completion) {
        completion(found, index);
    }
}

- (BOOL)evaluateCondition:(NSString *)condition {
    BOOL evaluatedResult = NO;

    if (condition) {
        NSError *error;

        DDExpression *expression = [DDExpression expressionFromString:condition error:&error];
        if (error == nil && self.values) {
            NSNumber *result = [self.evaluator evaluateExpression:expression
                                                withSubstitutions:self.values
                                                            error:&error];
            return [result boolValue];
        }
    } else {
        evaluatedResult = YES;
    }

    return evaluatedResult;
}

#pragma mark - Enable/Disable

- (void)disable {
    self.disabledForm = YES;
}

- (void)enable {
    self.disabledForm = NO;
}

- (BOOL)isDisabled {
    return self.disabledForm;
}

- (BOOL)isEnabled {
    return !self.disabledForm;
}

- (NSInteger)numberOfFields {
    NSInteger numberOfFields = 0;

    for (FORMGroup *group in self.groups) {
        numberOfFields += [group numberOfFields];
    }

    return numberOfFields;
}

#pragma mark - Dynamic

- (void)insertTemplateSectionWithID:(NSString *)sectionTemplateID
                 intoCollectionView:(UICollectionView *)collectionView
                         usingGroup:(FORMGroup *)group {
    FORMSection *foundSection;
    for (FORMSection *aSection in group.sections) {
        if ([aSection.sectionID isEqualToString:sectionTemplateID]) {
            foundSection = aSection;
            break;
        }
    }

    if (foundSection) {
        NSInteger index = [self indexForTemplateSectionWithID:sectionTemplateID inForm:group];

        NSDictionary *sectionTemplate = [self.sectionTemplatesDictionary valueForKey:sectionTemplateID];
        NSData *archivedTemplate = [NSKeyedArchiver archivedDataWithRootObject:sectionTemplate];
        NSMutableDictionary* templateSectionDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:archivedTemplate];
        [templateSectionDictionary setValue:[NSString stringWithFormat:@"%@[%ld]", sectionTemplateID, (long)index] forKey:@"id"];

        NSArray *templateFields = [templateSectionDictionary andy_valueForKey:@"fields"];
        NSMutableArray *fields = [NSMutableArray new];
        for (NSDictionary *fieldTemplateDictionary in templateFields) {
            NSMutableDictionary *fieldDictionary = [NSMutableDictionary dictionaryWithDictionary:fieldTemplateDictionary];
            NSString *fieldID = [fieldDictionary andy_valueForKey:@"id"];
            NSString *tranformedFieldID = [self transformDynamicIndexString:fieldID
                                                                  withIndex:(long)index];
            [fieldDictionary setValue:tranformedFieldID forKey:@"id"];

            NSString *fieldFormula = [fieldDictionary andy_valueForKey:@"formula"];
            if (fieldFormula) {
                NSString *tranformedFieldFormula = [self transformDynamicIndexString:fieldFormula
                                                                           withIndex:(long)index];
                [fieldDictionary setValue:tranformedFieldFormula
                                   forKey:@"formula"];
            }

            NSMutableArray *targets = [fieldDictionary andy_valueForKey:@"targets"];
            for (NSMutableDictionary *targetDictionary in targets) {
                NSString *targetID = [targetDictionary andy_valueForKey:@"id"];
                NSString *tranformedTargetIDFormula = [self transformDynamicIndexString:targetID
                                                                              withIndex:(long)index];
                targetDictionary[@"id"] = tranformedTargetIDFormula;
            }

            if (targets) {
                fieldDictionary[@"targets"] = targets;
            }

            NSArray *values = [fieldDictionary andy_valueForKey:@"values"];
            for (NSDictionary *dictionary in values) {
                if ([dictionary andy_valueForKey:@"default"]) {
                    self.values[tranformedFieldID] = [dictionary andy_valueForKey:@"id"];
                    break;
                }
            }

            [fields addObject:[fieldDictionary copy]];
        }

        [templateSectionDictionary setValue:[fields copy] forKey:@"fields"];

        FORMSection *actionSection = [self sectionWithID:sectionTemplateID];
        NSInteger sectionPosition = [actionSection.position integerValue];
        for (FORMSection *currentSection in group.sections) {
            if ([currentSection.sectionID hyp_containsString:sectionTemplateID]) {
                if (!sectionPosition) {
                    sectionPosition = [currentSection.position integerValue];
                }
                sectionPosition++;
            }
        }

        FORMSection *section = [[FORMSection alloc] initWithDictionary:templateSectionDictionary
                                                              position:sectionPosition
                                                              disabled:self.disabledForm
                                                     disabledFieldsIDs:nil
                                                         isLastSection:YES];
        section.group = group;

        for (FORMField *field in section.fields) {
            field.value = [self.values andy_valueForKey:field.fieldID];
            BOOL isValidField = (![field.fieldID hyp_containsString:@".remove"]);
            if (isValidField) {
                id value = (field.value) ?: [NSNull null];
                self.values[field.fieldID] = value;
            }
        }

        NSInteger sectionIndex = [section.position integerValue];
        [group.sections insertObject:section atIndex:sectionIndex];

        [group.sections enumerateObjectsUsingBlock:^(FORMSection *currentSection, NSUInteger idx, BOOL *stop) {
            if (idx > sectionIndex) {
                currentSection.position = @([currentSection.position integerValue] + 1);
            }
        }];

        if (collectionView) {
            [self sectionWithID:section.sectionID completion:^(FORMSection *section, NSArray *indexPaths) {
                if (indexPaths) {
                    [collectionView insertItemsAtIndexPaths:indexPaths];

                    [collectionView scrollToItemAtIndexPath:indexPaths.lastObject
                                           atScrollPosition:UICollectionViewScrollPositionTop
                                                   animated:YES];
                }
            }];
        }
    }
}

- (NSInteger)indexForTemplateSectionWithID:(NSString *)sectionID
                                    inForm:(FORMGroup *)group {
    NSInteger index = -1;
    for (FORMSection *existingSection in group.sections) {
        if ([existingSection.sectionID hyp_containsString:sectionID]) {
            index++;
        }
    }

    for (NSString *hiddenSectionID in self.hiddenSections) {
        if ([hiddenSectionID hyp_containsString:sectionID]) {
            index++;
        }
    }

    return index;
}

- (void)resetRemovedValues {
    self.removedValues = [NSMutableDictionary new];
}

- (NSArray *)removedSectionsUsingInitialValues:(NSDictionary *)dictionary {
    NSMutableSet *currentSectionIDs = [NSMutableSet new];
    for (FORMGroup *group in self.groups) {
        for (FORMSection *section in group.sections) {
            HYPParsedRelationship *parsed = [section.sectionID hyp_parseRelationship];
            if (parsed.toMany) {
                [currentSectionIDs addObject:[parsed key]];
            }
        }
    }

    NSMutableSet *existingSectionIDs = [NSMutableSet new];
    for (NSString *key in dictionary) {
        HYPParsedRelationship *parsed = [key hyp_parseRelationship];
        if (parsed.toMany) {
            parsed.attribute = nil;
            [existingSectionIDs addObject:[parsed key]];
        }
    }

    [currentSectionIDs minusSet:existingSectionIDs];
    NSArray *removedSectionIDs = [currentSectionIDs allObjects];
    NSMutableArray *removedSections = [NSMutableArray new];
    for (NSString *key in removedSectionIDs) {
        FORMSection *section = [self sectionWithID:key];
        if (section) {
            [removedSections addObject:section];
        }
    }

    return [removedSections copy];
}

- (NSString *)transformDynamicIndexString:(NSString *)string
                                withIndex:(long)index {
    return [string stringByReplacingOccurrencesOfString:@":index"
                                             withString:[NSString stringWithFormat:@"%ld", (long)index]];
}

- (void)updateValuesFromFields:(NSArray *)fields {
    for (FORMField *field in fields) {
        id value;

        if ([field.value isKindOfClass:[FORMFieldValue class]]) {
            value = [field.value valueID];
        } else {
            value = field.value;
        }

        [self.values andy_setValue:value forKey:field.fieldID];
    }
}

@end
