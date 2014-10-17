//
// HYPFormSection.m
//
//  Created by Elvis Nunez on 10/07/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFormSection.h"
#import "HYPFormField.h"
#import "HYPForm.h"

@implementation HYPFormSection

#pragma mark - Public Methods

#pragma mark Class

+ (HYPFormSection *)sectionWithID:(NSString *)id inForms:(NSArray *)forms
{
    __block BOOL found = NO;
    __block HYPFormSection *foundSection = nil;
    __block NSMutableArray *indexPaths = [NSMutableArray array];

    [forms enumerateObjectsUsingBlock:^(HYPForm *form, NSUInteger formIndex, BOOL *formStop) {
        if (found) {
            *formStop = YES;
        }

        __block NSInteger fieldsIndex = 0;

        [form.sections enumerateObjectsUsingBlock:^(HYPFormSection *aSection,
                                                    NSUInteger sectionIndex,
                                                    BOOL *sectionStop) {
            if ([aSection.id isEqualToString:id]) {
                NSInteger fieldsInSectionCount = fieldsIndex + aSection.fields.count;
                for (NSInteger i = fieldsIndex; i < fieldsInSectionCount; i++) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:formIndex]];
                }
                aSection.indexPaths = indexPaths;
                foundSection = aSection;

                found = YES;
                *sectionStop = YES;
            }

            fieldsIndex += aSection.fields.count;
        }];
    }];

    return foundSection;
}

+ (void)sectionAndIndexForField:(HYPFormField *)field
                        inForms:(NSArray *)forms
                     completion:(void (^)(BOOL found,
                                          HYPFormSection *section,
                                          NSInteger index))completion
{
    HYPForm *form = forms[[field.section.form.position integerValue]];
    HYPFormSection *section = form.sections[[field.section.position integerValue]];

    __block NSInteger index = 0;
    __block BOOL found = NO;
    [section.fields enumerateObjectsUsingBlock:^(HYPFormField *aField, NSUInteger idx, BOOL *stop) {
        if ([aField.id isEqualToString:field.id]) {
            index = idx;
            found = YES;
            *stop = YES;
        }
    }];

    if (completion) {
        completion(found, section, index);
    }
}

#pragma mark Instance

- (NSInteger)indexInForms:(NSArray *)forms
{
    HYPForm *form = forms[[self.form.position integerValue]];

    __block NSInteger index = 0;

    [form.sections enumerateObjectsUsingBlock:^(HYPFormSection *aSection, NSUInteger idx, BOOL *stop) {
        if ([aSection.id isEqualToString:self.id]) {
            index = idx;
            *stop = YES;
        }
    }];

    return index;
}

- (void)removeField:(HYPFormField *)field inForms:(NSArray *)forms
{
    __block NSInteger index = 0;
    [self.fields enumerateObjectsUsingBlock:^(HYPFormField *aField, NSUInteger idx, BOOL *stop) {
        if ([aField.id isEqualToString:field.id]) {
            index = idx;
            *stop = YES;
        }
    }];

    [self.fields removeObjectAtIndex:index];
}

@end
