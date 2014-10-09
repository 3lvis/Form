//
//  REMAFieldset.m
//
//  Created by Elvis Nunez on 08/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFieldset.h"

#import "REMAFormSection.h"
#import "REMAFormField.h"
#import "REMAFieldValue.h"
#import "REMAFieldRule.h"

#import "NSString+ZENInflections.h"

@implementation REMAFieldset

+ (NSArray *)fieldsets
{
    NSArray *JSON = [self JSONObjectWithContentsOfFile:@"forms.json"];

    NSMutableArray *fieldsets = [NSMutableArray array];

    [JSON enumerateObjectsUsingBlock:^(NSDictionary *fieldsetDict, NSUInteger fieldsetIndex, BOOL *stop) {

        REMAFieldset *fieldset = [REMAFieldset new];
        fieldset.id = [fieldsetDict objectForKey:@"id"];
        fieldset.title = [fieldsetDict objectForKey:@"title"];
        fieldset.position = @(fieldsetIndex);

        NSMutableArray *sections = [NSMutableArray array];
        NSArray *dataSourceSections = [fieldsetDict objectForKey:@"sections"];
        NSDictionary *lastObject = [dataSourceSections lastObject];

        [dataSourceSections enumerateObjectsUsingBlock:^(NSDictionary *sectionDict, NSUInteger sectionIndex, BOOL *stop) {

            REMAFormSection *section = [REMAFormSection new];
            section.type = [section typeFromTypeString:[sectionDict objectForKey:@"type"]];
            section.id = [sectionDict objectForKey:@"id"];
            section.position = @(sectionIndex);

            BOOL isLastSection = (lastObject == sectionDict);
            if (isLastSection) {
                section.isLast = YES;
            }

            NSArray *dataSourceFields = [sectionDict objectForKey:@"fields"];
            NSMutableArray *fields = [NSMutableArray array];

            [dataSourceFields enumerateObjectsUsingBlock:^(NSDictionary *fieldDict, NSUInteger fieldIndex, BOOL *stop) {

                NSString *remoteID = [fieldDict objectForKey:@"id"];
                NSString *propertyName = [remoteID zen_camelCase];

                REMAFormField *field = [REMAFormField new];
                field.id   = propertyName;
                field.title = [fieldDict objectForKey:@"title"];
                field.typeString  = [fieldDict objectForKey:@"type"];
                field.type = [field typeFromTypeString:[fieldDict objectForKey:@"type"]];
                field.size  = [fieldDict objectForKey:@"size"];
                field.position = @(fieldIndex);
                field.validations = [fieldDict objectForKey:@"validations"];

                NSMutableArray *values = [NSMutableArray array];
                NSArray *dataSourceValues = [fieldDict objectForKey:@"values"];

                for (NSDictionary *valueDict in dataSourceValues) {
                    REMAFieldValue *value = [REMAFieldValue new];
                    value.id = [valueDict objectForKey:@"id"];
                    value.title = [valueDict objectForKey:@"title"];

                    [values addObject:value];
                }

                field.values = values;
                [fields addObject:field];
            }];

            if (!isLastSection) {
                REMAFormField *field = [REMAFormField new];
                field.sectionSeparator = YES;
                field.position = @(fields.count);
                [fields addObject:field];
            }

            section.fields = fields;
            [sections addObject:section];
        }];

        fieldset.sections = sections;
        [fieldsets addObject:fieldset];
    }];

    return fieldsets;
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

    for (REMAFormSection *section in self.sections) {
        [array addObjectsFromArray:section.fields];
    }

    return array;
}

- (NSInteger)numberOfFields
{
    NSInteger count = 0;

    for (REMAFormSection *section in self.sections) {
        count += section.fields.count;
    }

    return count;
}

- (void)printFieldValues
{
    for (REMAFormSection *section in self.sections) {
        for (REMAFormField *field in section.fields) {
            NSLog(@"field key: %@ --- value: %@", field.id, field.fieldValue);
        }
    }
}

@end
