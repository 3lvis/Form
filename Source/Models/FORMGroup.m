#import "FORMGroup.h"

#import "FORMSection.h"
#import "FORMField.h"
#import "FORMFieldValue.h"
#import "FORMTarget.h"
#import "FORMClassFactory.h"
#import "FORMValidator.h"

#import "NSString+HYPFormula.h"
#import "NSDictionary+ANDYSafeValue.h"
#import "NSJSONSerialization+ANDYJSONFile.h"

@interface FORMGroup ()

@end

@implementation FORMGroup

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

        FORMSection *section = [[FORMSection alloc] initWithDictionary:sectionDict
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
        FORMTarget *target = [FORMTarget new];
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

    for (FORMSection *section in self.sections) {
        [array addObjectsFromArray:section.fields];
    }

    return array;
}

- (NSInteger)numberOfFields
{
    NSInteger count = 0;

    for (FORMSection *section in self.sections) {
        count += section.fields.count;
    }

    return count;
}

- (NSInteger)numberOfFields:(NSMutableDictionary *)deletedSections
{
    NSInteger count = 0;

    for (FORMSection *section in self.sections) {
        if (![deletedSections objectForKey:section.sectionID]) {
            count += section.fields.count;
        }
    }

    return count;
}

- (NSString *)description
{
    NSMutableArray *fields = [NSMutableArray new];

    for (FORMSection *section in self.sections) {
        for (FORMField *field in section.fields) {
            [fields addObject:[NSString stringWithFormat:@"%@ --- %@ (section %@ : field %@)\n", field.fieldID, field.value, field.section.position, field.position]];
        }
        [fields addObject:@" "];
    }

    return [NSString stringWithFormat:@"\n — Group: %@ —\n title: %@\n position: %@\n shouldValidate: %@\n sections: %@\n",
            self.formID, self.title, self.position, self.shouldValidate ? @"YES" : @"NO", fields];
}

@end
