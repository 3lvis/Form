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

#import "NSDictionary+Networking.h"
#import "NSString+ZENInflections.h"

@implementation REMAFieldset

+ (NSArray *)fieldsets
{
    NSArray *JSON = [self JSONObjectWithContentsOfFile:@"forms.json"];

    NSMutableArray *fieldsets = [NSMutableArray array];

    [JSON enumerateObjectsUsingBlock:^(NSDictionary *fieldsetDict, NSUInteger fieldsetIndex, BOOL *stop) {

        REMAFieldset *fieldset = [REMAFieldset new];
        fieldset.id = [fieldsetDict safeObjectForKey:@"id"];
        fieldset.title = [fieldsetDict safeObjectForKey:@"title"];
        fieldset.position = @(fieldsetIndex);

        NSMutableArray *sections = [NSMutableArray array];
        NSArray *dataSourceSections = [fieldsetDict safeObjectForKey:@"sections"];
        NSDictionary *lastObject = [dataSourceSections lastObject];

        [dataSourceSections enumerateObjectsUsingBlock:^(NSDictionary *sectionDict, NSUInteger sectionIndex, BOOL *stop) {

            REMAFormSection *section = [REMAFormSection new];
            section.type = [section typeFromTypeString:[sectionDict safeObjectForKey:@"type"]];
            section.id = [sectionDict safeObjectForKey:@"id"];
            section.position = @(sectionIndex);

            BOOL isLastSection = (lastObject == sectionDict);
            if (isLastSection) {
                section.isLast = YES;
            }

            NSArray *dataSourceFields = [sectionDict safeObjectForKey:@"fields"];
            NSMutableArray *fields = [NSMutableArray array];

            [dataSourceFields enumerateObjectsUsingBlock:^(NSDictionary *fieldDict, NSUInteger fieldIndex, BOOL *stop) {

                NSString *remoteID = [fieldDict safeObjectForKey:@"id"];
                NSString *propertyName = [remoteID zen_camelCase];

                REMAFormField *field = [REMAFormField new];
                field.id   = propertyName;
                field.title = [fieldDict safeObjectForKey:@"title"];
                field.typeString  = [fieldDict safeObjectForKey:@"type"];
                field.type = [field typeFromTypeString:[fieldDict safeObjectForKey:@"type"]];
                field.size  = [fieldDict safeObjectForKey:@"size"];
                field.position = @(fieldIndex);
                field.validations = [fieldDict safeObjectForKey:@"validations"];

                NSMutableArray *values = [NSMutableArray array];
                NSArray *dataSourceValues = [fieldDict safeObjectForKey:@"values"];

                for (NSDictionary *valueDict in dataSourceValues) {
                    REMAFieldValue *value = [REMAFieldValue new];
                    value.id = [valueDict safeObjectForKey:@"id"];
                    value.title = [valueDict safeObjectForKey:@"title"];

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
