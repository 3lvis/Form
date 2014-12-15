#import "HYPFormSection.h"
#import "HYPFormField.h"
#import "HYPForm.h"
#import "NSDictionary+ANDYSafeValue.h"
#import "HYPFormTarget.h"

@implementation HYPFormSection

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          position:(NSInteger)position
                          disabled:(BOOL)disabled
                 disabledFieldsIDs:(NSArray *)disabledFieldsIDs
                     isLastSection:(BOOL)isLastSection
{
    self = [super init];
    if (!self) return nil;

    self.sectionID = [dictionary andy_valueForKey:@"id"];
    self.position = @(position);
    self.isLast = isLastSection;

    NSArray *dataSourceFields = [dictionary andy_valueForKey:@"fields"];
    NSMutableArray *fields = [NSMutableArray array];

    [dataSourceFields enumerateObjectsUsingBlock:^(NSDictionary *fieldDict, NSUInteger fieldIndex, BOOL *stop) {

        HYPFormField *field = [[HYPFormField  alloc] initWithDictionary:fieldDict
                                                               position:fieldIndex
                                                               disabled:disabled
                                                      disabledFieldsIDs:disabledFieldsIDs];
        field.section = self;
        [fields addObject:field];
    }];

    if (!isLastSection) {
        HYPFormField *field = [HYPFormField new];
        field.sectionSeparator = YES;
        field.position = @(fields.count);
        field.section = self;
        [fields addObject:field];
    }

    self.fields = fields;

    return self;
}

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
