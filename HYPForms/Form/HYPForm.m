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

#import "NSString+ZENInflections.h"
#import "NSDictionary+HYPSafeValueForKey.h"

@implementation HYPForm

+ (NSArray *)forms
{
    return [self formsUsingInitialValuesFromDictionary:nil];
}

+ (NSArray *)formsUsingInitialValuesFromDictionary:(NSDictionary *)dictionary
{
    NSArray *JSON = [self JSONObjectWithContentsOfFile:@"forms.json"];

    NSMutableArray *forms = [NSMutableArray array];

    [JSON enumerateObjectsUsingBlock:^(NSDictionary *formDict, NSUInteger formIndex, BOOL *stop) {

        HYPForm *form = [HYPForm new];
        form.id = [formDict hyp_safeObjectForKey:@"id"];
        form.title = [formDict hyp_safeObjectForKey:@"title"];
        form.position = @(formIndex);

        NSMutableArray *sections = [NSMutableArray array];
        NSArray *dataSourceSections = [formDict hyp_safeObjectForKey:@"sections"];
        NSDictionary *lastObject = [dataSourceSections lastObject];

        [dataSourceSections enumerateObjectsUsingBlock:^(NSDictionary *sectionDict, NSUInteger sectionIndex, BOOL *stop) {

            HYPFormSection *section = [HYPFormSection new];
            section.type = [section typeFromTypeString:[sectionDict hyp_safeObjectForKey:@"type"]];
            section.id = [sectionDict hyp_safeObjectForKey:@"id"];
            section.position = @(sectionIndex);

            BOOL isLastSection = (lastObject == sectionDict);
            if (isLastSection) {
                section.isLast = YES;
            }

            NSArray *dataSourceFields = [sectionDict hyp_safeObjectForKey:@"fields"];
            NSMutableArray *fields = [NSMutableArray array];

            [dataSourceFields enumerateObjectsUsingBlock:^(NSDictionary *fieldDict, NSUInteger fieldIndex, BOOL *stop) {

                NSString *remoteID = [fieldDict hyp_safeObjectForKey:@"id"];
                NSString *propertyName = [remoteID zen_camelCase];

                HYPFormField *field = [HYPFormField new];
                field.id   = propertyName;
                field.title = [fieldDict hyp_safeObjectForKey:@"title"];
                field.typeString  = [fieldDict hyp_safeObjectForKey:@"type"];
                field.type = [field typeFromTypeString:[fieldDict hyp_safeObjectForKey:@"type"]];
                field.size  = [fieldDict hyp_safeObjectForKey:@"size"];
                field.position = @(fieldIndex);
                field.validations = [fieldDict hyp_safeObjectForKey:@"validations"];

                if (dictionary && [dictionary valueForKey:remoteID]) {
                    field.fieldValue = [dictionary valueForKey:remoteID];
                }

                NSMutableArray *values = [NSMutableArray array];
                NSArray *dataSourceValues = [fieldDict hyp_safeObjectForKey:@"values"];

                if (dataSourceValues) {
                    for (NSDictionary *valueDict in dataSourceValues) {
                        HYPFieldValue *value = [HYPFieldValue new];
                        value.id = [valueDict hyp_safeObjectForKey:@"id"];
                        value.title = [valueDict hyp_safeObjectForKey:@"title"];

                        [values addObject:value];
                    }
                    
                    field.values = values;
                }

                [fields addObject:field];
            }];

            if (!isLastSection) {
                HYPFormField *field = [HYPFormField new];
                field.sectionSeparator = YES;
                field.position = @(fields.count);
                [fields addObject:field];
            }

            section.fields = fields;
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

- (void)printFieldValues
{
    for (HYPFormSection *section in self.sections) {
        for (HYPFormField *field in section.fields) {
            NSLog(@"field key: %@ --- value: %@", field.id, field.fieldValue);
        }
    }
}

@end
