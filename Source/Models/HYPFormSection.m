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

        NSString *remoteID = [fieldDict andy_valueForKey:@"id"];

        HYPFormField *field = [HYPFormField new];
        field.fieldID   = remoteID;
        field.title = [fieldDict andy_valueForKey:@"title"];
        field.subtitle = [fieldDict andy_valueForKey:@"subtitle"];
        field.typeString  = [fieldDict andy_valueForKey:@"type"];
        field.type = [field typeFromTypeString:[fieldDict andy_valueForKey:@"type"]];
        NSNumber *width = [fieldDict andy_valueForKey:@"size.width"];
        NSNumber *height = [fieldDict andy_valueForKey:@"size.height"];
        if (!height || !width) abort();

        field.size = CGSizeMake([width floatValue], [height floatValue]);
        field.position = @(fieldIndex);
        field.validations = [fieldDict andy_valueForKey:@"validations"];
        field.disabled = [[fieldDict andy_valueForKey:@"disabled"] boolValue];
        field.formula = [fieldDict andy_valueForKey:@"formula"];

        NSMutableArray *targets = [NSMutableArray array];

        for (NSDictionary *targetDict in [fieldDict andy_valueForKey:@"targets"]) {
            HYPFormTarget *target = [HYPFormTarget new];
            target.targetID = [targetDict andy_valueForKey:@"id"];
            target.typeString = [targetDict andy_valueForKey:@"type"];
            target.actionTypeString = [targetDict andy_valueForKey:@"action"];
            [targets addObject:target];
        }

        field.targets = targets;

        BOOL shouldDisable = (disabled || [disabledFieldsIDs containsObject:field.fieldID]);

        if (shouldDisable) field.disabled = YES;

        NSMutableArray *values = [NSMutableArray array];
        NSArray *dataSourceValues = [fieldDict andy_valueForKey:@"values"];

        if (dataSourceValues) {
            for (NSDictionary *valueDict in dataSourceValues) {
                HYPFieldValue *fieldValue = [HYPFieldValue new];
                fieldValue.valueID = [valueDict andy_valueForKey:@"id"];
                fieldValue.title = [valueDict andy_valueForKey:@"title"];
                fieldValue.subtitle = [valueDict andy_valueForKey:@"subtitle"];
                fieldValue.value = [valueDict andy_valueForKey:@"value"];

                NSMutableArray *targets = [NSMutableArray array];

                for (NSDictionary *targetDict in [valueDict andy_valueForKey:@"targets"]) {
                    HYPFormTarget *target = [HYPFormTarget new];
                    target.targetID = [targetDict andy_valueForKey:@"id"];
                    target.typeString = [targetDict andy_valueForKey:@"type"];
                    target.actionTypeString = [targetDict andy_valueForKey:@"action"];
                    [targets addObject:target];
                }

                for (HYPFormTarget *target in targets) {
                    target.value = fieldValue;
                }

                fieldValue.targets = targets;
                fieldValue.field = field;
                [values addObject:fieldValue];
            }
        }

        field.values = values;
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
