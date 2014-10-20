//
//  HYPForm.m
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPForm.h"

#import "HYPFormSection.h"
#import "HYPFormField.h"
#import "HYPFieldValue.h"
#import "HYPFormTarget.h"

#import "NSDictionary+HYPSafeValue.h"
#import "NSString+HYPFormula.h"

@implementation HYPForm

+ (NSMutableArray *)formsUsingInitialValuesFromDictionary:(NSDictionary *)dictionary
                                                 readOnly:(BOOL)readOnly
                                         additionalValues:(void (^)(NSMutableDictionary *deletedFields,
                                                                    NSMutableDictionary *deletedSections))additionalValues
{
    NSArray *JSON = [self JSONObjectWithContentsOfFile:@"forms.json"];

    NSMutableArray *forms = [NSMutableArray array];

    NSMutableArray *targetsToRun = [NSMutableArray array];

    NSMutableArray *fieldsWithFormula = [NSMutableArray array];

    [JSON enumerateObjectsUsingBlock:^(NSDictionary *formDict, NSUInteger formIndex, BOOL *stop) {

        HYPForm *form = [HYPForm new];
        form.id = [formDict hyp_safeValueForKey:@"id"];
        form.title = [formDict hyp_safeValueForKey:@"title"];
        form.position = @(formIndex);

        NSMutableArray *sections = [NSMutableArray array];
        NSArray *dataSourceSections = [formDict hyp_safeValueForKey:@"sections"];
        NSDictionary *lastObject = [dataSourceSections lastObject];

        [dataSourceSections enumerateObjectsUsingBlock:^(NSDictionary *sectionDict, NSUInteger sectionIndex, BOOL *stop) {

            HYPFormSection *section = [HYPFormSection new];
            section.id = [sectionDict hyp_safeValueForKey:@"id"];
            section.position = @(sectionIndex);

            BOOL isLastSection = (lastObject == sectionDict);
            if (isLastSection) {
                section.isLast = YES;
            }

            NSArray *dataSourceFields = [sectionDict hyp_safeValueForKey:@"fields"];
            NSMutableArray *fields = [NSMutableArray array];

            [dataSourceFields enumerateObjectsUsingBlock:^(NSDictionary *fieldDict, NSUInteger fieldIndex, BOOL *stop) {

                NSString *remoteID = [fieldDict hyp_safeValueForKey:@"id"];

                HYPFormField *field = [HYPFormField new];
                field.id   = remoteID;
                field.title = [fieldDict hyp_safeValueForKey:@"title"];
                field.typeString  = [fieldDict hyp_safeValueForKey:@"type"];
                field.type = [field typeFromTypeString:[fieldDict hyp_safeValueForKey:@"type"]];
                field.size  = [fieldDict hyp_safeValueForKey:@"size"];
                field.position = @(fieldIndex);
                field.validations = [fieldDict hyp_safeValueForKey:@"validations"];
                field.disabled = [[fieldDict hyp_safeValueForKey:@"disabled"] boolValue];
                field.formula = [fieldDict hyp_safeValueForKey:@"formula"];
                field.targets = [self targetsUsingArray:[fieldDict hyp_safeValueForKey:@"targets"]];

                if (readOnly) {
                    field.disabled = YES;
                }

                if (readOnly && field.type == HYPFormFieldTypeImage) {
                    return;
                }

                NSMutableArray *values = [NSMutableArray array];
                NSArray *dataSourceValues = [fieldDict hyp_safeValueForKey:@"values"];

                if (dataSourceValues) {
                    for (NSDictionary *valueDict in dataSourceValues) {
                        HYPFieldValue *fieldValue = [HYPFieldValue new];
                        fieldValue.id = [valueDict hyp_safeValueForKey:@"id"];
                        fieldValue.title = [valueDict hyp_safeValueForKey:@"title"];
                        fieldValue.value = [valueDict hyp_safeValueForKey:@"value"];

                        BOOL needsToRun = NO;

                        if ([dictionary hyp_safeValueForKey:remoteID]) {
                            if ([fieldValue identifierIsEqualTo:[dictionary hyp_safeValueForKey:remoteID]]) {
                                needsToRun = YES;
                            }
                        }

                        NSArray *targets = [self targetsUsingArray:[valueDict hyp_safeValueForKey:@"targets"]];
                        for (HYPFormTarget *target in targets) {
                            target.value = fieldValue;

                            if (needsToRun && target.actionType == HYPFormTargetActionHide) {
                                [targetsToRun addObject:target];
                            }
                        }

                        fieldValue.targets = targets;
                        fieldValue.field = field;
                        [values addObject:fieldValue];
                    }
                }

                if ([dictionary hyp_safeValueForKey:remoteID]) {
                    if (field.type == HYPFormFieldTypeSelect) {
                        for (HYPFieldValue *value in values) {
                            if ([value identifierIsEqualTo:[dictionary hyp_safeValueForKey:remoteID]]) {
                                field.fieldValue = value;
                            }
                        }
                    } else {
                        field.fieldValue = [dictionary hyp_safeValueForKey:remoteID];
                    }
                }

                field.values = values;
                field.section = section;
                [fields addObject:field];

                if (field.formula) {
                    [fieldsWithFormula addObject:field];
                }
            }];

            if (!isLastSection) {
                HYPFormField *field = [HYPFormField new];
                field.sectionSeparator = YES;
                field.position = @(fields.count);
                field.section = section;
                [fields addObject:field];
            }

            section.fields = fields;
            section.form = form;
            [sections addObject:section];
        }];

        form.sections = sections;
        [forms addObject:form];
    }];

    [self processFieldWithFormula:fieldsWithFormula inForms:forms];

    [self processHiddenFieldsInTargets:targetsToRun
                               inForms:forms
                            completion:^(NSMutableDictionary *fields, NSMutableDictionary *sections) {
        [self removeHiddenFieldsInTargets:targetsToRun inForms:forms];

        if (additionalValues) {
            additionalValues(fields, sections);
        }
    }];

    return forms;
}

+ (NSArray *)targetsUsingArray:(NSArray *)array
{
    NSMutableArray *targets = [NSMutableArray array];

    for (NSDictionary *targetDict in array) {
        HYPFormTarget *target = [HYPFormTarget new];
        target.id = [targetDict hyp_safeValueForKey:@"id"];
        target.typeString = [targetDict hyp_safeValueForKey:@"type"];
        target.actionTypeString = [targetDict hyp_safeValueForKey:@"action"];
        [targets addObject:target];
    }

    return targets;
}

+ (id)JSONObjectWithContentsOfFile:(NSString*)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension]
                                                         ofType:[fileName pathExtension]];

    NSData *data = [NSData dataWithContentsOfFile:filePath];

    NSError *error = nil;

    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    if (error != nil) return nil;

    return result;
}

- (NSArray *)fields
{
    NSMutableArray *array = [NSMutableArray array];

    for (HYPFormSection *section in self.sections) {
        [array addObjectsFromArray:section.fields];
    }

    return array;
}

- (NSInteger)numberOfFields
{
    NSInteger count = 0;

    for (HYPFormSection *section in self.sections) {
        count += section.fields.count;
    }

    return count;
}

- (NSInteger)numberOfFields:(NSMutableDictionary *)deletedSections
{
    NSInteger count = 0;

    for (HYPFormSection *section in self.sections) {
        if (![deletedSections objectForKey:section.id]) {
            count += section.fields.count;
        }
    }

    return count;
}

- (void)printFieldValues
{
    for (HYPFormSection *section in self.sections) {
        for (HYPFormField *field in section.fields) {
            NSLog(@"field key: %@ --- value: %@ (%@ : %@)", field.id, field.fieldValue,
                  field.section.position, field.position);
        }
    }
}

#pragma mark - Private Methods

+ (void)processFieldWithFormula:(NSArray *)fieldsWithFormula inForms:(NSArray *)forms
{
    for (HYPFormField *field in fieldsWithFormula) {
        NSMutableDictionary *values = [field valuesForFormulaInForms:forms];
        id result = [field.formula hyp_runFormulaWithDictionary:values];
        field.fieldValue = result;
    }
}

+ (void)processHiddenFieldsInTargets:(NSArray *)targets
                             inForms:(NSArray *)forms
                          completion:(void (^)(NSMutableDictionary *fields,
                                               NSMutableDictionary *sections))completion
{
    NSMutableDictionary *hiddenFields = [NSMutableDictionary dictionary];
    NSMutableDictionary *hiddenSections = [NSMutableDictionary dictionary];

    for (HYPFormTarget *target in targets) {

        if (target.type == HYPFormTargetTypeField) {

            HYPFormField *field = [HYPFormField fieldWithID:target.id inForms:forms withIndexPath:YES];
            [hiddenFields addEntriesFromDictionary:@{target.id : field}];

        } else if (target.type == HYPFormTargetTypeSection) {

            HYPFormSection *section = [HYPFormSection sectionWithID:target.id inForms:forms];
            [hiddenSections addEntriesFromDictionary:@{target.id : section}];
        }
    }

    if (completion) {
        completion(hiddenFields, hiddenSections);
    }
}

+ (void)removeHiddenFieldsInTargets:(NSArray *)targets inForms:(NSArray *)forms
{
    for (HYPFormTarget *target in targets) {

        if (target.type == HYPFormTargetTypeField) {

            HYPFormField *field = [HYPFormField fieldWithID:target.id inForms:forms withIndexPath:NO];
            HYPFormSection *section = [HYPFormSection sectionWithID:field.section.id inForms:forms];
            [section removeField:field inForms:forms];

        } else if (target.type == HYPFormTargetTypeSection) {

            HYPFormSection *section = [HYPFormSection sectionWithID:target.id inForms:forms];
            HYPForm *form = forms[[section.form.position integerValue]];
            NSInteger index = [section indexInForms:forms];
            [form.sections removeObjectAtIndex:index];
        }
    }
}

@end
