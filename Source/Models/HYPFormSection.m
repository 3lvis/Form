#import "HYPFormSection.h"
#import "HYPFormField.h"
#import "HYPForm.h"

@implementation HYPFormSection

#pragma mark - Public Methods

#pragma mark Class

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
        if ([aField.fieldID isEqualToString:field.fieldID]) {
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

    BOOL found = NO;
    NSInteger index = 0;
    NSUInteger idx = 0;

    for (HYPFormSection *aSection in form.sections) {
        if ([aSection.position integerValue] >= [self.position integerValue]) {
            index = idx;
            found = YES;
            break;
        }

        idx++;
    }

    if (!found) index = [form.sections count];

    return index;
}

- (void)removeField:(HYPFormField *)field inForms:(NSArray *)forms
{
    __block NSInteger index = 0;
    [self.fields enumerateObjectsUsingBlock:^(HYPFormField *aField, NSUInteger idx, BOOL *stop) {
        if ([aField.fieldID isEqualToString:field.fieldID]) {
            index = idx;
            *stop = YES;
        }
    }];

    [self.fields removeObjectAtIndex:index];
}

@end
