#import "FORMData.h"

#import "FORMGroup.h"
#import "FORMSection.h"
#import "FORMField.h"
#import "FORMFieldValue.h"
#import "FORMTarget.h"

#import "NSString+HYPFormula.h"
#import "NSDictionary+ANDYSafeValue.h"
#import "FORMFieldValidation.h"
#import "NSString+HYPWordExtractor.h"

#import "DDMathParser.h"
#import "DDMathEvaluator+HYPForms.h"

@interface FORMData ()

@property (nonatomic, strong) NSMutableDictionary *requiredFields;
@property (nonatomic, strong) DDMathEvaluator *evaluator;
@property (nonatomic) BOOL disabledForm;

@end

@implementation FORMData

- (instancetype)initWithJSON:(id)JSON
               initialValues:(NSDictionary *)initialValues
            disabledFieldIDs:(NSArray *)disabledFieldIDs
                    disabled:(BOOL)disabled
{
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

- (NSMutableArray *)forms
{
    if (_forms) return _forms;

    _forms = [NSMutableArray new];

    return _forms;
}

- (NSMutableDictionary *)hiddenFieldsAndFieldIDsDictionary
{
    if (_hiddenFieldsAndFieldIDsDictionary) return _hiddenFieldsAndFieldIDsDictionary;

    _hiddenFieldsAndFieldIDsDictionary = [NSMutableDictionary new];

    return _hiddenFieldsAndFieldIDsDictionary;
}

- (NSMutableDictionary *)hiddenSections
{
    if (_hiddenSections) return _hiddenSections;

    _hiddenSections = [NSMutableDictionary new];

    return _hiddenSections;
}

- (NSArray *)disabledFieldsIDs
{
    if (_disabledFieldsIDs) return _disabledFieldsIDs;

    _disabledFieldsIDs = [NSArray new];

    return _disabledFieldsIDs;
}

- (NSMutableDictionary *)values
{
    if (_values) return _values;

    _values = [NSMutableDictionary new];

    return _values;
}

- (DDMathEvaluator *)evaluator
{
    if (_evaluator) return _evaluator;

    _evaluator = [DDMathEvaluator defaultMathEvaluator];

    NSDictionary *functionDictonary = [DDMathEvaluator hyp_directoryFunctions];
    __weak typeof(self)weakSelf = self;

    [functionDictonary enumerateKeysAndObjectsUsingBlock:^(id key, id function, BOOL *stop) {
        [weakSelf.evaluator registerFunction:function forName:key];
    }];

    return _evaluator;
}

- (void)generateFormsWithJSON:(NSArray *)JSON
                initialValues:(NSDictionary *)initialValues
            disabledFieldsIDs:(NSArray *)disabledFieldsIDs
                     disabled:(BOOL)disabled
{
    NSMutableArray *hideTargets = [NSMutableArray new];
    NSMutableArray *updateTargets = [NSMutableArray new];
    NSMutableArray *disabledFields = [NSMutableArray new];

    [disabledFields addObjectsFromArray:disabledFieldsIDs];

    [JSON enumerateObjectsUsingBlock:^(NSDictionary *formDict, NSUInteger formIndex, BOOL *stop) {

        FORMGroup *form = [[FORMGroup alloc] initWithDictionary:formDict
                                                       position:formIndex
                                                       disabled:disabled
                                              disabledFieldsIDs:disabledFieldsIDs];

        for (FORMField *field in form.fields) {

            if ([initialValues andy_valueForKey:field.fieldID]) {
                if (field.type == FORMFieldTypeSelect) {
                    for (FORMFieldValue *value in field.values) {

                        BOOL isInitialValue = ([value identifierIsEqualTo:[initialValues andy_valueForKey:field.fieldID]]);
                        if (isInitialValue) field.fieldValue = value;
                    }
                } else {
                    field.fieldValue = [initialValues andy_valueForKey:field.fieldID];
                }
            }

            for (FORMFieldValue *fieldValue in field.values) {

                id initialValue = [initialValues andy_valueForKey:field.fieldID];

                BOOL fieldHasInitialValue = (initialValue != nil);
                if (fieldHasInitialValue) {

                    BOOL fieldValueMatchesInitialValue = ([fieldValue identifierIsEqualTo:initialValue]);
                    if (fieldValueMatchesInitialValue) {

                        for (FORMTarget *target in fieldValue.targets) {
                            if (![self evaluateCondition:target.condition]) continue;
                            if (target.actionType == FORMTargetActionHide) [hideTargets addObject:target];
                            if (target.actionType == FORMTargetActionUpdate) [updateTargets addObject:target];
                            if (target.actionType == FORMTargetActionDisable) [disabledFields addObject:target.targetID];
                        }
                    }
                } else {
                    BOOL shouldUseDefaultValue = (fieldValue.defaultValue && !field.fieldValue);
                    if (shouldUseDefaultValue) {
                        field.fieldValue = fieldValue;
                        self.values[field.fieldID] = fieldValue.valueID;

                        for (FORMTarget *target in fieldValue.targets) {
                            if (![self evaluateCondition:target.condition]) continue;
                            if (target.actionType == FORMTargetActionHide) [hideTargets addObject:target];
                            if (target.actionType == FORMTargetActionUpdate) [updateTargets addObject:target];
                            if (target.actionType == FORMTargetActionDisable) [disabledFields addObject:target.targetID];
                        }
                    }
                }
            }
        }

        [self.forms addObject:form];
    }];

    self.disabledFieldsIDs = disabledFields;
    [self updateTargets:updateTargets];

    for (FORMTarget *target in hideTargets) {
        if (![self evaluateCondition:target.condition]) continue;

        if (target.type == FORMTargetTypeField) {

            FORMField *field = [self fieldWithID:target.targetID includingHiddenFields:YES];
            [self.hiddenFieldsAndFieldIDsDictionary addEntriesFromDictionary:@{target.targetID : field}];

        } else if (target.type == FORMTargetTypeSection) {

            FORMSection *section = [self sectionWithID:target.targetID];
            [self.hiddenSections addEntriesFromDictionary:@{target.targetID : section}];
        }
    }

    for (FORMTarget *target in hideTargets) {
        if (![self evaluateCondition:target.condition]) continue;

        if (target.type == FORMTargetTypeField) {

            FORMField *field = [self fieldWithID:target.targetID includingHiddenFields:NO];
            if (field) {
                FORMSection *section = [self sectionWithID:field.section.sectionID];
                [section removeField:field inForms:self.forms];
            }

        } else if (target.type == FORMTargetTypeSection) {

            FORMSection *section = [self sectionWithID:target.targetID];
            if (section) {
                FORMGroup *form = section.form;
                NSInteger index = [section indexInForms:self.forms];
                [form.sections removeObjectAtIndex:index];
            }
        }
    }
}

- (NSArray *)invalidFormFields
{
    NSMutableArray *invalidFormFields = [NSMutableArray new];

    for (FORMGroup *form in self.forms) {
        for (FORMSection *section in form.sections) {
            for (FORMField *field in section.fields) {
                BOOL fieldIsValid = (field.validations && [field validate] != FORMValidationResultTypePassed);
                if (fieldIsValid) [invalidFormFields addObject:field];
            }
        }
    }

    return invalidFormFields;
}

- (NSMutableDictionary *)requiredFields
{
    if (_requiredFields) return _requiredFields;

    _requiredFields = [NSMutableDictionary new];

    for (FORMGroup *form in self.forms) {
        for (FORMSection *section in form.sections) {
            for (FORMField *field in section.fields) {
                if (field.validations) {
                    BOOL required = [[field.validations andy_valueForKey:@"required"] boolValue];
                    if (required) {
                        [_requiredFields setObject:field forKey:field.fieldID];
                    }
                }
            }
        }
    }

    return _requiredFields;
}

- (NSDictionary *)requiredFormFields
{
    return self.requiredFields;
}

- (NSMutableDictionary *)valuesForFormula:(FORMField *)field
{
    NSMutableDictionary *values = [NSMutableDictionary new];

    NSString *formula = field.formula;
    NSArray *fieldIDs = [formula hyp_variables];

    for (NSString *fieldID in fieldIDs) {
        FORMField *targetField = [self fieldWithID:fieldID includingHiddenFields:YES];
        id value = targetField.fieldValue;
        if (value) {
            if (targetField.type == FORMFieldTypeSelect) {
                FORMFieldValue *fieldValue = targetField.fieldValue;
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
            if (field.type == FORMFieldTypeNumber || field.type == FORMFieldTypeFloat) {
                [values addEntriesFromDictionary:@{fieldID : @"0"}];
            } else {
                [values addEntriesFromDictionary:@{fieldID : @""}];
            }
        }
    }

    return values;
}

#pragma mark - Sections

- (FORMSection *)sectionWithID:(NSString *)sectionID
{
    FORMSection *foundSection = nil;

    for (FORMGroup *form in self.forms) {
        for (FORMSection *aSection in form.sections) {
            if ([aSection.sectionID isEqualToString:sectionID]) {
                foundSection = aSection;
                break;
            }
        }
    }

    return foundSection;
}

- (void)sectionWithID:(NSString *)sectionID
           completion:(void (^)(FORMSection *section, NSArray *indexPaths))completion
{
    FORMSection *foundSection = nil;
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSUInteger formIndex = 0;

    for (FORMGroup *form in self.forms) {

        NSInteger fieldsIndex = 0;

        for (FORMSection *aSection in form.sections) {

            for (__unused FORMField *aField in aSection.fields) {
                if ([aSection.sectionID isEqualToString:sectionID]) {
                    foundSection = aSection;
                    [indexPaths addObject:[NSIndexPath indexPathForRow:fieldsIndex inSection:formIndex]];
                }

                fieldsIndex++;
            }
        }

        formIndex++;
    }

    if (completion) completion(foundSection, indexPaths);
}

#pragma mark - Field

- (FORMField *)fieldWithID:(NSString *)fieldID includingHiddenFields:(BOOL)includingHiddenFields
{
    NSParameterAssert(fieldID);

    FORMField *foundField = nil;

    NSInteger formIndex = 0;
    for (FORMGroup *form in self.forms) {

        NSUInteger fieldIndex = 0;
        for (FORMField *field in form.fields) {

            if ([field.fieldID isEqualToString:fieldID]) {
                foundField = field;
                break;
            }

            ++fieldIndex;
        }

        ++formIndex;
    }

    if (!foundField && includingHiddenFields) {
        foundField = [self hiddenFieldWithFieldID:fieldID];
    }

    return foundField;
}

- (void)fieldWithID:(NSString *)fieldID includingHiddenFields:(BOOL)includingHiddenFields
         completion:(void (^)(FORMField *field, NSIndexPath *indexPath))completion
{
    NSParameterAssert(fieldID);

    __block FORMField *foundField = nil;
    __block NSIndexPath *indexPath = nil;

    NSInteger formIndex = 0;
    for (FORMGroup *form in self.forms) {

        NSUInteger fieldIndex = 0;
        for (FORMField *field in form.fields) {

            if ([field.fieldID isEqualToString:fieldID]) {
                indexPath = [NSIndexPath indexPathForItem:fieldIndex inSection:formIndex];
                foundField = field;
                break;
            }

            ++fieldIndex;
        }

        ++formIndex;
    }

    if (!foundField && includingHiddenFields) {
        foundField = [self hiddenFieldWithFieldID:fieldID];
    }

    if (completion) completion(foundField, indexPath);
}

- (FORMField *)hiddenFieldWithFieldID:(NSString *)fieldID
{
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
                 completion:(void (^)(FORMSection *section, NSInteger index))completion
{
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

    if (completion) completion(section, index);
}

- (NSArray *)showTargets:(NSArray *)targets
{
    NSMutableArray *insertedIndexPaths = [NSMutableArray new];

    for (FORMTarget *target in targets) {
        if (![self evaluateCondition:target.condition]) continue;

        __block BOOL shouldLookForField = YES;
        if (target.type == FORMTargetTypeField) {
            [self fieldWithID:target.targetID includingHiddenFields:NO
                   completion:^(FORMField *field, NSIndexPath *indexPath) {
                       if (field) shouldLookForField = NO;
                   }];
        }

        if (shouldLookForField) {
            BOOL foundSection = NO;

            if (target.type == FORMTargetTypeField) {
                FORMField *field = [self.hiddenFieldsAndFieldIDsDictionary objectForKey:target.targetID];
                if (field) {
                    FORMGroup *form = self.forms[[field.section.form.position integerValue]];

                    for (FORMSection *section in form.sections) {
                        if ([section.sectionID isEqualToString:field.section.sectionID]) {
                            foundSection = YES;
                            NSInteger fieldIndex = [field indexInSectionUsingForms:self.forms];
                            [section.fields insertObject:field atIndex:fieldIndex];
                        }
                    }
                }
            } else if (target.type == FORMTargetTypeSection) {
                FORMSection *section = [self.hiddenSections objectForKey:target.targetID];
                if (section) {
                    NSInteger sectionIndex = [section indexInForms:self.forms];
                    FORMGroup *form = self.forms[[section.form.position integerValue]];
                    [form.sections insertObject:section atIndex:sectionIndex];
                }
            }

            if (target.type == FORMTargetTypeField && foundSection) {
                FORMField *field = [self.hiddenFieldsAndFieldIDsDictionary objectForKey:target.targetID];
                if (field) {
                    [self fieldWithID:target.targetID includingHiddenFields:YES completion:^(FORMField *field, NSIndexPath *indexPath) {
                        if (field) {
                            [insertedIndexPaths addObject:indexPath];
                        }

                        [self.hiddenFieldsAndFieldIDsDictionary removeObjectForKey:target.targetID];
                    }];
                }
            } else if (target.type == FORMTargetTypeSection) {
                FORMSection *section = [self.hiddenSections objectForKey:target.targetID];
                if (section) {
                    [self sectionWithID:target.targetID completion:^(FORMSection *section, NSArray *indexPaths) {
                        if (section) {
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

- (NSArray *)hideTargets:(NSArray *)targets
{
    NSMutableArray *deletedFields = [NSMutableArray new];
    NSMutableArray *deletedSections = [NSMutableArray new];

    for (FORMTarget *target in targets) {
        if (![self evaluateCondition:target.condition]) continue;

        if (target.type == FORMTargetTypeField) {
            FORMField *field = [self fieldWithID:target.targetID includingHiddenFields:NO];
            if (field && ![self.hiddenFieldsAndFieldIDsDictionary objectForKey:field.fieldID]) {
                [deletedFields addObject:field];
                [self.hiddenFieldsAndFieldIDsDictionary addEntriesFromDictionary:@{field.fieldID : field}];
            }
        } else if (target.type == FORMTargetTypeSection) {
            FORMSection *section = [self sectionWithID:target.targetID];
            if (section && ![self.hiddenSections objectForKey:section.sectionID]) {
                [deletedSections addObject:section];
                [self.hiddenSections addEntriesFromDictionary:@{section.sectionID : section}];
            }
        }
    }

    NSMutableSet *deletedIndexPaths = [NSMutableSet set];

    for (FORMField *field in deletedFields) {
        [self fieldWithID:field.fieldID includingHiddenFields:YES completion:^(FORMField *field, NSIndexPath *indexPath) {
            if (field) {
                [deletedIndexPaths addObject:indexPath];
            }
        }];
    }

    for (FORMSection *section in deletedSections) {
        [self sectionWithID:section.sectionID completion:^(FORMSection *foundSection, NSArray *indexPaths) {
            if (foundSection) {
                [deletedIndexPaths addObjectsFromArray:indexPaths];
            }
        }];
    }

    for (FORMField *field in deletedFields) {
        [self indexForFieldWithID:field.fieldID
                  inSectionWithID:field.section.sectionID
                       completion:^(FORMSection *section, NSInteger index) {
                           if (section) {
                               [section.fields removeObjectAtIndex:index];
                           }
                       }];
    }

    for (FORMSection *section in deletedSections) {
        FORMGroup *form = self.forms[[section.form.position integerValue]];
        [self indexForSection:section form:form completion:^(BOOL found, NSInteger index) {
            if (found) {
                [form.sections removeObjectAtIndex:index];
            }
        }];
    }

    return [deletedIndexPaths allObjects];
}

- (NSArray *)updateTargets:(NSArray *)targets
{
    NSMutableArray *updatedIndexPaths = [NSMutableArray new];

    for (FORMTarget *target in targets) {
        if (![self evaluateCondition:target.condition]) continue;

        if (target.type == FORMTargetTypeSection) continue;
        if ([self.hiddenFieldsAndFieldIDsDictionary objectForKey:target.targetID]) continue;

        __block FORMField *field = nil;

        [self fieldWithID:target.targetID includingHiddenFields:YES completion:^(FORMField *foundField, NSIndexPath *indexPath) {
            if (foundField) {
                field = foundField;
                if (indexPath) [updatedIndexPaths addObject:indexPath];
            }
        }];

        if (!field) continue;

        if (target.targetValue) {

            if (field.type == FORMFieldTypeSelect) {
                FORMFieldValue *selectedFieldValue = [field selectFieldValueWithValueID:target.targetValue];

                if (selectedFieldValue) {
                    [self.values setObject:selectedFieldValue.valueID forKey:field.fieldID];
                    field.fieldValue = selectedFieldValue;
                }

            } else {
                field.fieldValue = target.targetValue;
                [self.values setObject:field.fieldValue forKey:field.fieldID];
            }

        } else if (target.actionType == FORMTargetActionClear) {
            field.fieldValue = nil;
            [self.values setObject:[NSNull null] forKey:field.fieldID];
        } else if (field.formula) {
            NSArray *fieldIDs = [field.formula hyp_variables];
            NSMutableDictionary *values = [NSMutableDictionary new];

            for (NSString *fieldID in fieldIDs) {

                id value = [self.values objectForKey:fieldID];
                BOOL isNumericField = (field.type == FORMFieldTypeFloat || field.type == FORMFieldTypeNumber);
                NSString *defaultEmptyValue = (isNumericField) ? @"0" : @"";

                FORMField *targetField = [self fieldWithID:fieldID includingHiddenFields:YES];

                if (targetField.type == FORMFieldTypeSelect) {

                    if ([targetField.fieldValue isKindOfClass:[FORMFieldValue class]]) {

                        FORMFieldValue *fieldValue = targetField.fieldValue;

                        if (fieldValue.value) {
                            [values addEntriesFromDictionary:@{fieldID : fieldValue.value}];
                        }
                    } else {
                        FORMFieldValue *foundFieldValue = nil;
                        for (FORMFieldValue *fieldValue in field.values) {
                            if ([fieldValue identifierIsEqualTo:field.fieldValue]) {
                                foundFieldValue = fieldValue;
                            }
                        }
                        if (foundFieldValue && foundFieldValue.value) {
                            [values addEntriesFromDictionary:@{fieldID : foundFieldValue.value}];
                        }
                    }

                } else if (value) {
                    if ([value isKindOfClass:[NSString class]]) {
                        if ([value length] == 0) value = defaultEmptyValue;
                        [values addEntriesFromDictionary:@{fieldID : value}];
                    } else {
                        if ([value respondsToSelector:NSSelectorFromString(@"stringValue")]) {
                            [self.values setObject:[value stringValue] forKey:field.fieldID];
                            [values addEntriesFromDictionary:@{fieldID : [value stringValue]}];
                        } else {
                            [self.values setObject:@"" forKey:field.fieldID];
                            [values addEntriesFromDictionary:@{fieldID : defaultEmptyValue}];
                        }
                    }
                } else {
                    [values addEntriesFromDictionary:@{fieldID : defaultEmptyValue}];
                }
            }

            field.formula = [field.formula stringByReplacingOccurrencesOfString:@"$" withString:@""];
            id result = [field.formula hyp_runFormulaWithValuesDictionary:values];
            field.fieldValue = result;

            if (result) {
                [self.values setObject:result forKey:field.fieldID];
            } else {
                [self.values removeObjectForKey:field.fieldID];
            }
        }
    }

    return updatedIndexPaths;
}

- (NSArray *)enableTargets:(NSArray *)targets
{
    return [self updateTargets:targets withEnabled:YES];
}

- (NSArray *)disableTargets:(NSArray *)targets
{
    return [self updateTargets:targets withEnabled:NO];
}

- (NSArray *)updateTargets:(NSArray *)targets withEnabled:(BOOL)enabled
{
    NSMutableArray *indexPaths = [NSMutableArray new];

    for (FORMTarget *target in targets) {
        if (![self evaluateCondition:target.condition]) continue;
        if (target.type == FORMTargetTypeSection) continue;
        if ([self.hiddenFieldsAndFieldIDsDictionary objectForKey:target.targetID]) continue;

        [self fieldWithID:target.targetID includingHiddenFields:YES completion:^(FORMField *field, NSIndexPath *indexPath) {
            if (field) {
                field.disabled = !enabled;
                if (indexPath) [indexPaths addObject:indexPath];
            }
        }];
    }

    return indexPaths;
}

- (void)indexForSection:(FORMSection *)section form:(FORMGroup *)form completion:(void (^)(BOOL found, NSInteger index))completion
{
    __block NSInteger index = 0;
    __block BOOL found = NO;
    [form.sections enumerateObjectsUsingBlock:^(FORMSection *aSection, NSUInteger idx, BOOL *stop) {
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

- (BOOL)evaluateCondition:(NSString *)condition
{
    BOOL evaluatedResult = NO;

    if (condition) {
        NSError *error;

        NSSet *set = [self.values keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
            return [obj isEqual:[NSNull null]];
        }];

        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.values];
        [dictionary removeObjectsForKeys:[set allObjects]];

        DDExpression *expression = [DDExpression expressionFromString:condition error:&error];
        if (error == nil && self.values) {
            NSNumber *result = [self.evaluator evaluateExpression:expression
                                                withSubstitutions:dictionary
                                                            error:&error];
            return [result boolValue];
        }
    } else {
        evaluatedResult = YES;
    }

    return evaluatedResult;
}

#pragma mark - Enable/Disable

- (void)disable
{
    self.disabledForm = YES;
}

- (void)enable
{
    self.disabledForm = NO;
}

- (BOOL)isDisabled
{
    return self.disabledForm;
}

- (BOOL)isEnabled
{
    return !self.disabledForm;
}

- (NSInteger)numberOfFields
{
    NSInteger numberOfFields = 0;

    for (FORMGroup *form in self.forms) {
        numberOfFields += [form numberOfFields];
    }

    return numberOfFields;
}

@end
