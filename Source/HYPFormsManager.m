#import "HYPFormsManager.h"

#import "HYPForm.h"
#import "HYPFormSection.h"
#import "HYPFormField.h"
#import "HYPFieldValue.h"
#import "HYPFormTarget.h"

#import "NSString+HYPFormula.h"
#import "NSDictionary+ANDYSafeValue.h"

@interface HYPFormsManager ()

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
{
    self = [super init];
    if (!self) return nil;

    _forms = forms;

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
    NSMutableArray *fieldsWithFormula = [NSMutableArray new];
    NSMutableArray *targetsToRun = [NSMutableArray array];
    NSMutableDictionary *fieldValues = [NSMutableDictionary new];
    [fieldValues addEntriesFromDictionary:initialValues];

    [JSON enumerateObjectsUsingBlock:^(NSDictionary *formDict, NSUInteger formIndex, BOOL *stop) {

        HYPForm *form = [[HYPForm alloc] initWithDictionary:formDict
                                                   position:formIndex
                                                   disabled:disabled
                                          disabledFieldsIDs:disabledFieldsIDs
                                              initialValues:initialValues];
        [forms addObject:form];

        for (HYPFormField *field in form.fields) {

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
    }];

    for (HYPFormField *field in fieldsWithFormula) {
        NSMutableDictionary *values = [field valuesForFormulaInForms:forms];
        id result = [field.formula hyp_runFormulaWithValuesDictionary:values];
        field.fieldValue = result;
        if (result) [fieldValues setObject:result forKey:field.fieldID];
    }

    NSMutableDictionary *hiddenFields = [NSMutableDictionary dictionary];
    NSMutableDictionary *hiddenSections = [NSMutableDictionary dictionary];

    for (HYPFormTarget *target in targetsToRun) {

        if (target.type == HYPFormTargetTypeField) {

            HYPFormField *field = [HYPFormField fieldWithID:target.targetID inForms:forms withIndexPath:YES];
            [hiddenFields addEntriesFromDictionary:@{target.targetID : field}];

        } else if (target.type == HYPFormTargetTypeSection) {

            HYPFormSection *section = [HYPFormSection sectionWithID:target.targetID inForms:forms];
            [hiddenSections addEntriesFromDictionary:@{target.targetID : section}];
        }
    }

    for (HYPFormTarget *target in targetsToRun) {

        if (target.type == HYPFormTargetTypeField) {

            HYPFormField *field = [HYPFormField fieldWithID:target.targetID inForms:forms withIndexPath:NO];
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

    for (HYPForm *form in self.forms) {
        NSDictionary *requiredFieldIDs = form.requiredFieldIDs;
        for (HYPFormField *field in form.fields) {
            BOOL requiredFieldFailedValidation = (requiredFieldIDs[field.fieldID] &&
                                                  ![field validate]);
            if (requiredFieldFailedValidation) [invalidFormFields addObject:field];
        }
    }

    return invalidFormFields;
}

@end
