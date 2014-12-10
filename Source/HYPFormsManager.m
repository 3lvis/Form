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
                     completion:^(NSDictionary *fieldValues,
                                  NSMutableDictionary *hiddenFields,
                                  NSMutableDictionary *hiddenSections) {
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
                   completion:(void (^)(NSDictionary *fieldValues,
                                        NSMutableDictionary *hiddenFields,
                                        NSMutableDictionary *hiddenSections))completion
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

    NSMutableDictionary *fieldValues = [NSMutableDictionary new];
    [fieldValues addEntriesFromDictionary:initialValues];

    for (HYPFormField *field in fieldsWithFormula) {
        NSMutableDictionary *values = [self valuesForFormula:field];
        id result = [field.formula hyp_runFormulaWithValuesDictionary:values];
        field.fieldValue = result;
        if (result) [fieldValues setObject:result forKey:field.fieldID];
    }

    NSMutableDictionary *hiddenFields = [NSMutableDictionary dictionary];
    NSMutableDictionary *hiddenSections = [NSMutableDictionary dictionary];

    for (HYPFormTarget *target in targetsToRun) {

        if (target.type == HYPFormTargetTypeField) {

            HYPFormField *field = [self fieldWithID:target.targetID];
            [hiddenFields addEntriesFromDictionary:@{target.targetID : field}];

        } else if (target.type == HYPFormTargetTypeSection) {

            HYPFormSection *section = [HYPFormSection sectionWithID:target.targetID inForms:self.forms];
            [hiddenSections addEntriesFromDictionary:@{target.targetID : section}];
        }
    }

    for (HYPFormTarget *target in targetsToRun) {

        if (target.type == HYPFormTargetTypeField) {

            HYPFormField *field = [self fieldWithID:target.targetID];
            HYPFormSection *section = [HYPFormSection sectionWithID:field.section.sectionID inForms:self.forms];
            [section removeField:field inForms:self.forms];

        } else if (target.type == HYPFormTargetTypeSection) {

            HYPFormSection *section = [HYPFormSection sectionWithID:target.targetID inForms:self.forms];
            HYPForm *form = self.forms[[section.form.position integerValue]];
            NSInteger index = [section indexInForms:self.forms];
            [form.sections removeObjectAtIndex:index];
        }
    }

    if (completion) completion(fieldValues, hiddenFields, hiddenSections);
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

- (HYPFormField *)fieldWithID:(NSString *)fieldID
{
    return [self fieldWithID:fieldID includingHiddenFields:YES];
}

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

    if (includingHiddenFields) {
        if (!foundField) {

            for (HYPFormField *formField in self.hiddenFields) {
                if ([formField.fieldID isEqualToString:fieldID]) {
                    foundField = formField;
                }
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
    }

    return foundField;
}

- (void)fieldWithID:(NSString *)fieldID
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

    if (completion) completion(foundField, indexPath);
}

@end
