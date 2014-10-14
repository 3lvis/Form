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
#import "HYPFieldRule.h"
#import "HYPFormTarget.h"

#import "NSString+ZENInflections.h"
#import "NSDictionary+HYPSafeValue.h"

@implementation HYPForm

+ (NSMutableArray *)forms
{
    return [self formsUsingInitialValuesFromDictionary:nil];
}

+ (NSMutableArray *)formsUsingInitialValuesFromDictionary:(NSDictionary *)dictionary
{
    NSArray *JSON = [self JSONObjectWithContentsOfFile:@"forms.json"];

    NSMutableArray *forms = [NSMutableArray array];

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
            section.type = [section typeFromTypeString:[sectionDict hyp_safeValueForKey:@"type"]];
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
                NSString *propertyName = [remoteID zen_camelCase];

                HYPFormField *field = [HYPFormField new];
                field.id   = propertyName;
                field.title = [fieldDict hyp_safeValueForKey:@"title"];
                field.typeString  = [fieldDict hyp_safeValueForKey:@"type"];
                field.type = [field typeFromTypeString:[fieldDict hyp_safeValueForKey:@"type"]];
                field.size  = [fieldDict hyp_safeValueForKey:@"size"];
                field.position = @(fieldIndex);
                field.validations = [fieldDict hyp_safeValueForKey:@"validations"];
                field.disabled = [[fieldDict hyp_safeValueForKey:@"disabled"] boolValue];

                if (dictionary && [dictionary hyp_safeValueForKey:remoteID]) {
                    field.fieldValue = [dictionary hyp_safeValueForKey:remoteID];
                }

                NSMutableArray *values = [NSMutableArray array];
                NSArray *dataSourceValues = [fieldDict hyp_safeValueForKey:@"values"];

                if (dataSourceValues) {
                    for (NSDictionary *valueDict in dataSourceValues) {
                        HYPFieldValue *value = [HYPFieldValue new];
                        value.id = [valueDict hyp_safeValueForKey:@"id"];
                        value.title = [valueDict hyp_safeValueForKey:@"title"];

                        NSMutableArray *targets = [NSMutableArray array];
                        NSArray *dataSourceTargets = [valueDict hyp_safeValueForKey:@"targets"];

                        for (NSDictionary *targetDict in dataSourceTargets) {
                            HYPFormTarget *target = [HYPFormTarget new];
                            target.id = [targetDict hyp_safeValueForKey:@"id"];
                            target.typeString = [targetDict hyp_safeValueForKey:@"type"];
                            target.actionTypeString = [targetDict hyp_safeValueForKey:@"action"];

                            [targets addObject:target];
                        }

                        value.targets = targets;
                        [values addObject:value];
                    }

                    field.values = values;
                }

                field.section = section;
                [fields addObject:field];
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

    return forms;
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
            NSLog(@"field key: %@ --- value: %@ --- position: %@", field.id, field.fieldValue, field.position);
        }
    }
}

@end
