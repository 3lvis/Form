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

    NSMutableArray *sections = [NSMutableArray new];
    NSArray *dataSourceSections = [dictionary andy_valueForKey:@"sections"];
    NSDictionary *lastObject = [dataSourceSections lastObject];

    [dataSourceSections enumerateObjectsUsingBlock:^(NSDictionary *sectionDict, NSUInteger sectionIndex, BOOL *stop) {

        BOOL isLastSection = (lastObject == sectionDict);

        HYPFormSection *section = [[HYPFormSection alloc] initWithDictionary:sectionDict
                                                                    position:sectionIndex
                                                                    disabled:disabled
                                                           disabledFieldsIDs:disabledFieldsIDs
                                                               isLastSection:isLastSection];

        section.form = self;
        [sections addObject:section];
    }];

    self.sections = sections;

    return self;
}

- (NSArray *)targetsUsingArray:(NSArray *)array
{
    NSMutableArray *targets = [NSMutableArray new];

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
    NSMutableArray *array = [NSMutableArray new];

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
