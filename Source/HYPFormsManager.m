#import "HYPFormsManager.h"

#import "HYPForm.h"
#import "HYPFormSection.h"
#import "HYPFormField.h"
#import "HYPFieldValue.h"
#import "HYPFormTarget.h"

#import "NSString+HYPFormula.h"
#import "NSDictionary+ANDYSafeValue.h"
#import "HYPFieldValidation.h"
#import "NSString+HYPWordExtractor.h"

@interface HYPFormsManager ()

@property (nonatomic, strong) NSMutableDictionary *requiredFields;

@end

@implementation HYPFormsManager

- (instancetype)initWithJSON:(id)JSON
               initialValues:(NSDictionary *)initialValues
            disabledFieldIDs:(NSArray *)disabledFieldIDs
                    disabled:(BOOL)disabled
{
    self = [super init];
    if (!self) return nil;

    _disabledFieldsIDs = disabledFieldIDs;

    [self generateFormsWithJSON:JSON
                  initialValues:initialValues
              disabledFieldsIDs:disabledFieldIDs
                       disabled:disabled];

    return self;
}

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

- (void)generateFormsWithJSON:(NSArray *)JSON
                initialValues:(NSDictionary *)initialValues
            disabledFieldsIDs:(NSArray *)disabledFieldsIDs
                     disabled:(BOOL)disabled
{
    NSMutableArray *fieldsWithFormula = [NSMutableArray new];
    NSMutableArray *targetsToRun = [NSMutableArray array];

    [JSON enumerateObjectsUsingBlock:^(NSDictionary *formDict, NSUInteger formIndex, BOOL *stop) {

        HYPForm *form = [[HYPForm alloc] initWithDictionary:formDict
                                                   position:formIndex
                                                   disabled:disabled
                                          disabledFieldsIDs:disabledFieldsIDs];

        for (HYPFormField *field in form.fields) {

            if ([initialValues andy_valueForKey:field.fieldID]) {
                if (field.type == HYPFormFieldTypeSelect) {
                    for (HYPFieldValue *value in field.values) {

                        BOOL isInitialValue = ([value identifierIsEqualTo:[initialValues andy_valueForKey:field.fieldID]]);
                        if (isInitialValue) field.fieldValue = value;
                    }
                } else {
                    field.fieldValue = [initialValues andy_valueForKey:field.fieldID];
                }
            }

            if (field.formula) [fieldsWithFormula addObject:field];

            for (HYPFieldValue *fieldValue in field.values) {

                id initialValue = [initialValues andy_valueForKey:field.fieldID];

                BOOL fieldHasInitialValue = (initialValue != nil);
                if (fieldHasInitialValue) {

                    BOOL fieldValueMatchesInitialValue = ([fieldValue identifierIsEqualTo:initialValue]);
                    if (fieldValueMatchesInitialValue) {

                        for (HYPFormTarget *target in fieldValue.targets) {
                            if (target.actionType == HYPFormTargetActionHide) [targetsToRun addObject:target];
                        }
                    }
                }
            }
        }

        [self.forms addObject:form];
    }];

    [self.values addEntriesFromDictionary:initialValues];

    for (HYPFormField *field in fieldsWithFormula) {
        NSMutableDictionary *values = [self valuesForFormula:field];
        id result = [field.formula hyp_runFormulaWithValuesDictionary:values];
        field.fieldValue = result;
        if (result) [self.values setObject:result forKey:field.fieldID];
    }

    for (HYPFormTarget *target in targetsToRun) {

        if (target.type == HYPFormTargetTypeField) {

            HYPFormField *field = [self fieldWithID:target.targetID includingHiddenFields:YES];
            [self.hiddenFieldsAndFieldIDsDictionary addEntriesFromDictionary:@{target.targetID : field}];

        } else if (target.type == HYPFormTargetTypeSection) {

            HYPFormSection *section = [self sectionWithID:target.targetID];
            [self.hiddenSections addEntriesFromDictionary:@{target.targetID : section}];
        }
    }

    for (HYPFormTarget *target in targetsToRun) {

        if (target.type == HYPFormTargetTypeField) {

            HYPFormField *field = [self fieldWithID:target.targetID includingHiddenFields:YES];
            HYPFormSection *section = [self sectionWithID:field.section.sectionID];
            [section removeField:field inForms:self.forms];

        } else if (target.type == HYPFormTargetTypeSection) {

            HYPFormSection *section = [self sectionWithID:target.targetID];
            if (section) {
                HYPForm *form = section.form;
                NSInteger index = [section indexInForms:self.forms];
                [form.sections removeObjectAtIndex:index];
            }
        }
    }
}

- (NSArray *)invalidFormFields
{
    NSMutableArray *invalidFormFields = [NSMutableArray new];

    NSArray *fields = [self.requiredFields allValues];
    for (HYPFormField *field in fields) {
        BOOL requiredFieldFailedValidation = (![field validate]);
        if (requiredFieldFailedValidation) [invalidFormFields addObject:field];
    }

    return invalidFormFields;
}

- (NSMutableDictionary *)requiredFields
{
    if (_requiredFields) return _requiredFields;

    _requiredFields = [NSMutableDictionary dictionary];

    for (HYPForm *form in self.forms) {
        for (HYPFormSection *section in form.sections) {
            for (HYPFormField *field in section.fields) {
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

- (NSMutableDictionary *)valuesForFormula:(HYPFormField *)field
{
    NSMutableDictionary *values = [NSMutableDictionary dictionary];

    NSString *formula = field.formula;
    NSArray *fieldIDs = [formula hyp_variables];

    for (NSString *fieldID in fieldIDs) {
        HYPFormField *targetField = [self fieldWithID:fieldID includingHiddenFields:YES];
        id value = targetField.fieldValue;
        if (value) {
            if (targetField.type == HYPFormFieldTypeSelect) {
                HYPFieldValue *fieldValue = targetField.fieldValue;
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
            if (field.type == HYPFormFieldTypeNumber || field.type == HYPFormFieldTypeFloat) {
                [values addEntriesFromDictionary:@{fieldID : @"0"}];
            } else {
                [values addEntriesFromDictionary:@{fieldID : @""}];
            }
        }
    }

    return values;
}

#pragma mark - Sections

- (HYPFormSection *)sectionWithID:(NSString *)sectionID
{
    HYPFormSection *foundSection = nil;

    for (HYPForm *form in self.forms) {
        for (HYPFormSection *aSection in form.sections) {
            if ([aSection.sectionID isEqualToString:sectionID]) {
                foundSection = aSection;
                break;
            }
        }
    }

    return foundSection;
}

- (void)sectionWithID:(NSString *)sectionID
           completion:(void (^)(HYPFormSection *section, NSArray *indexPaths))completion
{
    HYPFormSection *foundSection = nil;
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSUInteger formIndex = 0;

    for (HYPForm *form in self.forms) {

        NSInteger fieldsIndex = 0;

        for (HYPFormSection *aSection in form.sections) {

            for (__unused HYPFormField *aField in aSection.fields) {
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

- (HYPFormField *)fieldWithID:(NSString *)fieldID includingHiddenFields:(BOOL)includingHiddenFields
{
    NSParameterAssert(fieldID);

    HYPFormField *foundField = nil;

    NSInteger formIndex = 0;
    for (HYPForm *form in self.forms) {

        NSUInteger fieldIndex = 0;
        for (HYPFormField *field in form.fields) {

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
         completion:(void (^)(HYPFormField *field, NSIndexPath *indexPath))completion
{
    NSParameterAssert(fieldID);

    __block HYPFormField *foundField = nil;
    __block NSIndexPath *indexPath = nil;

    NSInteger formIndex = 0;
    for (HYPForm *form in self.forms) {

        NSUInteger fieldIndex = 0;
        for (HYPFormField *field in form.fields) {

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

- (HYPFormField *)hiddenFieldWithFieldID:(NSString *)fieldID
{
    NSArray *hiddenFields = [self.hiddenFieldsAndFieldIDsDictionary allValues];
    HYPFormField *foundField;

    for (HYPFormField *formField in hiddenFields) {
        if ([formField.fieldID isEqualToString:fieldID]) {
            foundField = formField;
        }
    }

    if (!foundField) {

        NSArray *deletedSections = [self.hiddenSections allValues];

        for (HYPFormSection *section in deletedSections) {
            for (HYPFormField *field in section.fields) {
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
                 completion:(void (^)(HYPFormSection *section, NSInteger index))completion
{
    HYPFormSection *section = [self sectionWithID:sectionID];

    __block NSInteger index = 0;

    NSUInteger idx = 0;
    for (HYPFormField *aField in section.fields) {
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
    NSMutableArray *insertedIndexPaths = [NSMutableArray array];

    for (HYPFormTarget *target in targets) {

        if (target.type == HYPFormTargetTypeField) {
            HYPFormField *field = [self.hiddenFieldsAndFieldIDsDictionary objectForKey:target.targetID];
            if (field) {
                HYPForm *form = self.forms[[field.section.form.position integerValue]];
                HYPFormSection *section = form.sections[[field.section.position integerValue]];
                NSInteger fieldIndex = [field indexInSectionUsingForms:self.forms];
                [section.fields insertObject:field atIndex:fieldIndex];
            }
        } else if (target.type == HYPFormTargetTypeSection) {
            HYPFormSection *section = [self.hiddenSections objectForKey:target.targetID];
            if (section) {
                NSInteger sectionIndex = [section indexInForms:self.forms];
                HYPForm *form = self.forms[[section.form.position integerValue]];
                [form.sections insertObject:section atIndex:sectionIndex];
            }
        }

        if (target.type == HYPFormTargetTypeField) {
            HYPFormField *field = [self.hiddenFieldsAndFieldIDsDictionary objectForKey:target.targetID];
            if (field) {
                [self fieldWithID:target.targetID includingHiddenFields:YES completion:^(HYPFormField *field, NSIndexPath *indexPath) {
                    if (field) {
                        [insertedIndexPaths addObject:indexPath];
                    }

                    [self.hiddenFieldsAndFieldIDsDictionary removeObjectForKey:target.targetID];
                }];
            }
        } else if (target.type == HYPFormTargetTypeSection) {
            HYPFormSection *section = [self.hiddenSections objectForKey:target.targetID];
            if (section) {
                [self sectionWithID:target.targetID completion:^(HYPFormSection *section, NSArray *indexPaths) {
                    if (section) {
                        [insertedIndexPaths addObjectsFromArray:indexPaths];

                        [self.hiddenSections removeObjectForKey:section.sectionID];
                    }
                }];
            }
        }
    }

    return insertedIndexPaths;
}

- (NSArray *)hideTargets:(NSArray *)targets
{
    NSMutableArray *deletedFields = [NSMutableArray array];
    NSMutableArray *deletedSections = [NSMutableArray array];

    for (HYPFormTarget *target in targets) {
        if (target.type == HYPFormTargetTypeField) {
            HYPFormField *field = [self fieldWithID:target.targetID includingHiddenFields:NO];
            if (field && ![self.hiddenFieldsAndFieldIDsDictionary objectForKey:field.fieldID]) {
                [deletedFields addObject:field];
                [self.hiddenFieldsAndFieldIDsDictionary addEntriesFromDictionary:@{field.fieldID : field}];
            }
        } else if (target.type == HYPFormTargetTypeSection) {
            HYPFormSection *section = [self sectionWithID:target.targetID];
            if (section && ![self.hiddenSections objectForKey:section.sectionID]) {
                [deletedSections addObject:section];
                [self.hiddenSections addEntriesFromDictionary:@{section.sectionID : section}];
            }
        }
    }

    NSMutableSet *deletedIndexPaths = [NSMutableSet set];

    for (HYPFormField *field in deletedFields) {
        [self fieldWithID:field.fieldID includingHiddenFields:YES completion:^(HYPFormField *field, NSIndexPath *indexPath) {
            if (field) {
                [deletedIndexPaths addObject:indexPath];
            }
        }];
    }

    for (HYPFormSection *section in deletedSections) {
        [self sectionWithID:section.sectionID completion:^(HYPFormSection *foundSection, NSArray *indexPaths) {
            if (foundSection) {
                [deletedIndexPaths addObjectsFromArray:indexPaths];
            }
        }];
    }

    for (HYPFormField *field in deletedFields) {
        [self indexForFieldWithID:field.fieldID
                               inSectionWithID:field.section.sectionID
                                    completion:^(HYPFormSection *section, NSInteger index) {
                                        if (section) {
                                            [section.fields removeObjectAtIndex:index];
                                        }
                                    }];
    }

    for (HYPFormSection *section in deletedSections) {
        HYPForm *form = self.forms[[section.form.position integerValue]];
        [self indexForSection:section form:form completion:^(BOOL found, NSInteger index) {
            if (found) {
                [form.sections removeObjectAtIndex:index];
            }
        }];
    }

    return [deletedIndexPaths allObjects];

    //[self deleteItemsAtIndexPaths:[deletedIndexPaths allObjects]];
}

- (NSArray *)updateTargets:(NSArray *)targets
{
    NSMutableArray *updatedIndexPaths = [NSMutableArray array];

    for (HYPFormTarget *target in targets) {
        if (target.type == HYPFormTargetTypeSection) continue;
        if ([self.hiddenFieldsAndFieldIDsDictionary objectForKey:target.targetID]) continue;

        __block HYPFormField *field = nil;

        [self fieldWithID:target.targetID includingHiddenFields:YES completion:^(HYPFormField *foundField, NSIndexPath *indexPath) {
            if (foundField) {
                field = foundField;
                if (indexPath) [updatedIndexPaths addObject:indexPath];
            }
        }];

        if (!field) continue;

        NSArray *fieldIDs = [field.formula hyp_variables];
        NSMutableDictionary *values = [NSMutableDictionary dictionary];

        for (NSString *fieldID in fieldIDs) {

            id value = [self.values objectForKey:fieldID];
            BOOL isNumericField = (field.type == HYPFormFieldTypeFloat || field.type == HYPFormFieldTypeNumber);
            NSString *defaultEmptyValue = (isNumericField) ? @"0" : @"";

            HYPFormField *targetField = [self fieldWithID:fieldID includingHiddenFields:YES];

            if (targetField.type == HYPFormFieldTypeSelect) {

                if ([targetField.fieldValue isKindOfClass:[HYPFieldValue class]]) {

                    HYPFieldValue *fieldValue = targetField.fieldValue;

                    if (fieldValue.value) {
                        [values addEntriesFromDictionary:@{fieldID : fieldValue.value}];
                    }
                } else {
                    HYPFieldValue *foundFieldValue = nil;
                    for (HYPFieldValue *fieldValue in field.values) {
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

        id result = [field.formula hyp_runFormulaWithValuesDictionary:values];
        field.fieldValue = result;

        if (result) {
            [self.values setObject:result forKey:field.fieldID];
        } else {
            [self.values removeObjectForKey:field.fieldID];
        }
    }

    return updatedIndexPaths;
//    [self reloadItemsAtIndexPaths:updatedIndexPaths];
}

- (void)indexForSection:(HYPFormSection *)section form:(HYPForm *)form completion:(void (^)(BOOL found, NSInteger index))completion
{
    __block NSInteger index = 0;
    __block BOOL found = NO;
    [form.sections enumerateObjectsUsingBlock:^(HYPFormSection *aSection, NSUInteger idx, BOOL *stop) {
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

@end
