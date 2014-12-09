#import "HYPForm.h"

#import "HYPFormSection.h"
#import "HYPFormField.h"
#import "HYPFieldValue.h"
#import "HYPFormTarget.h"

#import "HYPClassFactory.h"
#import "HYPValidator.h"

#import "NSString+HYPFormula.h"
#import "NSDictionary+ANDYSafeValue.h"
#import "NSJSONSerialization+ANDYJSONFile.h"

@interface HYPForm ()

@end

@implementation HYPForm

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          position:(NSInteger)position
                          disabled:(BOOL)disabled
                 disabledFieldsIDs:(NSArray *)disabledFieldsIDs
{
    self = [super init];
    if (!self) return nil;

    self.formID = [dictionary andy_valueForKey:@"id"];
    self.title = [dictionary andy_valueForKey:@"title"];
    self.position = @(position);

    NSMutableArray *sections = [NSMutableArray array];
    NSArray *dataSourceSections = [dictionary andy_valueForKey:@"sections"];
    NSDictionary *lastObject = [dataSourceSections lastObject];

    [dataSourceSections enumerateObjectsUsingBlock:^(NSDictionary *sectionDict, NSUInteger sectionIndex, BOOL *stop) {

        HYPFormSection *section = [HYPFormSection new];
        section.sectionID = [sectionDict andy_valueForKey:@"id"];
        section.position = @(sectionIndex);

        BOOL isLastSection = (lastObject == sectionDict);

        if (isLastSection) section.isLast = YES;

        NSArray *dataSourceFields = [sectionDict andy_valueForKey:@"fields"];
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
        section.form = self;
        [sections addObject:section];
    }];

    self.sections = sections;

    return self;
}

- (NSArray *)targetsUsingArray:(NSArray *)array
{
    NSMutableArray *targets = [NSMutableArray array];

    for (NSDictionary *targetDict in array) {
        HYPFormTarget *target = [HYPFormTarget new];
        target.targetID = [targetDict andy_valueForKey:@"id"];
        target.typeString = [targetDict andy_valueForKey:@"type"];
        target.actionTypeString = [targetDict andy_valueForKey:@"action"];
        [targets addObject:target];
    }

    return targets;
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
        if (![deletedSections objectForKey:section.sectionID]) {
            count += section.fields.count;
        }
    }

    return count;
}

- (void)printFieldValues
{
    for (HYPFormSection *section in self.sections) {
        for (HYPFormField *field in section.fields) {
            NSLog(@"field key: %@ --- value: %@ (%@ : %@)", field.fieldID, field.fieldValue,
                  field.section.position, field.position);
        }
    }
}

@end
