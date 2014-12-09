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
                       disabled:disabled
                     completion:^(NSMutableArray *forms,
                                  NSDictionary *fieldValues,
                                  NSMutableDictionary *hiddenFields,
                                  NSMutableDictionary *hiddenSections) {
                         self.forms = forms;
                         self.hiddenFields = hiddenFields;
                         self.hiddenSections = hiddenSections;
                         self.values = [fieldValues mutableCopy];
                     }];

    return self;
}

- (instancetype)initWithForms:(NSMutableArray *)forms
                initialValues:(NSDictionary *)initialValues
{
    self = [super init];
    if (!self) return nil;

    [self generateFormsWithForms:forms
                  initialValues:initialValues
              disabledFieldsIDs:nil
                       disabled:NO
                     completion:^(NSMutableArray *forms,
                                  NSDictionary *fieldValues,
                                  NSMutableDictionary *hiddenFields,
                                  NSMutableDictionary *hiddenSections) {
                         self.forms = forms;
                         self.hiddenFields = hiddenFields;
                         self.hiddenSections = hiddenSections;
                         self.values = [fieldValues mutableCopy];
                     }];

    return self;
}

- (NSMutableArray *)forms
{
    if (_forms) return _forms;

    _forms = [NSMutableArray new];

    return _forms;
}

- (NSMutableDictionary *)hiddenFields
{
    if (_hiddenFields) return _hiddenFields;

    _hiddenFields = [NSMutableDictionary new];

    return _hiddenFields;
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
                   completion:(void (^)(NSMutableArray *forms,
                                        NSDictionary *fieldValues,
                                        NSMutableDictionary *hiddenFields,
                                        NSMutableDictionary *hiddenSections))completion
{
    NSMutableArray *forms = [NSMutableArray array];

    [JSON enumerateObjectsUsingBlock:^(NSDictionary *formDict, NSUInteger formIndex, BOOL *stop) {

        HYPForm *form = [[HYPForm alloc] initWithDictionary:formDict
                                                   position:formIndex
                                                   disabled:disabled
                                          disabledFieldsIDs:disabledFieldsIDs];
        [forms addObject:form];
    }];

    [self generateFormsWithForms:forms
                   initialValues:initialValues
               disabledFieldsIDs:disabledFieldsIDs
                        disabled:disabled
                      completion:completion];
}

- (void)generateFormsWithForms:(NSMutableArray *)forms
                initialValues:(NSDictionary *)initialValues
            disabledFieldsIDs:(NSArray *)disabledFieldsIDs
                     disabled:(BOOL)disabled
                   completion:(void (^)(NSMutableArray *forms,
                                        NSDictionary *fieldValues,
                                        NSMutableDictionary *hiddenFields,
                                        NSMutableDictionary *hiddenSections))completion
{
    NSMutableArray *fieldsWithFormula = [NSMutableArray new];
    NSMutableArray *targetsToRun = [NSMutableArray array];
    NSMutableDictionary *fieldValues = [NSMutableDictionary new];
    [fieldValues addEntriesFromDictionary:initialValues];

    for (HYPForm *form in forms) {
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
    }

    for (HYPFormField *field in fieldsWithFormula) {
        NSMutableDictionary *values = [self valuesForFormula:field usingForms:forms];
        id result = [field.formula hyp_runFormulaWithValuesDictionary:values];
        field.fieldValue = result;
        if (result) [fieldValues setObject:result forKey:field.fieldID];
    }

    NSMutableDictionary *hiddenFields = [NSMutableDictionary dictionary];
    NSMutableDictionary *hiddenSections = [NSMutableDictionary dictionary];

    for (HYPFormTarget *target in targetsToRun) {

        if (target.type == HYPFormTargetTypeField) {

            HYPFormField *field = [self fieldWithID:target.targetID withIndexPath:YES inForms:forms];
            [hiddenFields addEntriesFromDictionary:@{target.targetID : field}];

        } else if (target.type == HYPFormTargetTypeSection) {

            HYPFormSection *section = [HYPFormSection sectionWithID:target.targetID inForms:forms];
            [hiddenSections addEntriesFromDictionary:@{target.targetID : section}];
        }
    }

    for (HYPFormTarget *target in targetsToRun) {

        if (target.type == HYPFormTargetTypeField) {

            HYPFormField *field = [self fieldWithID:target.targetID withIndexPath:YES];
            HYPFormSection *section = [HYPFormSection sectionWithID:field.section.sectionID inForms:forms];
            [section removeField:field inForms:forms];

        } else if (target.type == HYPFormTargetTypeSection) {

            HYPFormSection *section = [HYPFormSection sectionWithID:target.targetID inForms:forms];
            HYPForm *form = forms[[section.form.position integerValue]];
            NSInteger index = [section indexInForms:forms];
            [form.sections removeObjectAtIndex:index];
        }
    }

    if (completion) completion(forms, fieldValues, hiddenFields, hiddenSections);
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

- (NSMutableDictionary *)valuesForFormula:(HYPFormField *)field usingForms:(NSArray *)forms
{
    NSMutableDictionary *values = [NSMutableDictionary dictionary];

    NSString *formula = field.formula;
    NSArray *fieldIDs = [formula hyp_variables];

    for (NSString *fieldID in fieldIDs) {
        HYPFormField *targetField = [self fieldWithID:fieldID withIndexPath:YES inForms:forms];
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

- (HYPFormField *)fieldWithID:(NSString *)fieldID
                withIndexPath:(BOOL)withIndexPath
{
    return [self fieldWithID:fieldID withIndexPath:withIndexPath inForms:self.forms];
}

- (HYPFormField *)fieldWithID:(NSString *)fieldID
                withIndexPath:(BOOL)withIndexPath
                      inForms:(NSArray *)forms
{
    NSParameterAssert(fieldID);

    __block HYPFormField *foundField = nil;

    NSInteger formIndex = 0;
    for (HYPForm *form in forms) {

        NSUInteger fieldIndex = 0;
        for (HYPFormField *field in form.fields) {

            if ([field.fieldID isEqualToString:fieldID]) {

                if (withIndexPath) {
                    field.indexPath = [NSIndexPath indexPathForItem:fieldIndex inSection:formIndex];
                }

                foundField = field;
                break;
            }

            ++fieldIndex;
        }

        if (foundField) break;

        ++formIndex;
    }

    if (!foundField) {

        [self.hiddenFields enumerateKeysAndObjectsUsingBlock:^(NSString *hiddenFieldID, HYPFormField *formField, BOOL *stop) {
            if ([hiddenFieldID isEqualToString:fieldID]) {
                foundField = formField;
                *stop = YES;
            }
        }];
    }

    if (!foundField) {
        NSArray *deletedSections = [self.hiddenSections allValues];
        [deletedSections enumerateObjectsUsingBlock:^(HYPFormSection *section, NSUInteger sectionIndex, BOOL *sectionStop) {
            [section.fields enumerateObjectsUsingBlock:^(HYPFormField *field, NSUInteger fieldIndex, BOOL *fieldStop) {
                if ([field.fieldID isEqualToString:fieldID]) {
                    if (withIndexPath) {
                        field.indexPath = [NSIndexPath indexPathForItem:fieldIndex inSection:sectionIndex];
                    }

                    foundField = field;
                    *sectionStop = YES;
                }
            }];
        }];
    }

    return foundField;
}

@end
