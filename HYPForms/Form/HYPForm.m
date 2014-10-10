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

@implementation HYPForm

+ (NSArray *)forms
{
    NSArray *JSON = [self JSONObjectWithContentsOfFile:@"forms.json"];

    NSMutableArray *forms = [NSMutableArray array];

    [JSON enumerateObjectsUsingBlock:^(NSDictionary *formDict, NSUInteger formIndex, BOOL *stop) {

        HYPForm *form = [HYPForm new];
        form.id = [formDict objectForKey:@"id"];
        form.title = [formDict objectForKey:@"title"];
        form.position = @(formIndex);

        NSMutableArray *sections = [NSMutableArray array];
        NSArray *dataSourceSections = [formDict objectForKey:@"sections"];
        NSDictionary *lastObject = [dataSourceSections lastObject];

        [dataSourceSections enumerateObjectsUsingBlock:^(NSDictionary *sectionDict, NSUInteger sectionIndex, BOOL *stop) {

            HYPFormSection *section = [HYPFormSection new];
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

                HYPFormField *field = [HYPFormField new];
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
                    HYPFieldValue *value = [HYPFieldValue new];
                    value.id = [valueDict objectForKey:@"id"];
                    value.title = [valueDict objectForKey:@"title"];

                    [values addObject:value];
                }

                field.values = values;
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
