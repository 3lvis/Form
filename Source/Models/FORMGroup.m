#import "FORMGroup.h"

#import "FORMSection.h"
#import "FORMField.h"
#import "FORMFieldValue.h"
#import "FORMTarget.h"
#import "FORMClassFactory.h"
#import "HYPParsedRelationship.h"

#import "NSString+HYPFormula.h"
#import "NSDictionary+ANDYSafeValue.h"
#import "NSJSONSerialization+ANDYJSONFile.h"
#import "NSString+HYPRelationshipParser.h"

@interface FORMGroup ()

@end

@implementation FORMGroup

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          position:(NSInteger)position
                          disabled:(BOOL)disabled
                 disabledFieldsIDs:(NSArray *)disabledFieldsIDs {
    self = [super init];
    if (!self) return nil;

    self.groupID = [dictionary andy_valueForKey:@"id"];
    self.title = NSLocalizedString([dictionary andy_valueForKey:@"title"], nil);
    self.position = @(position);
    
    self.collapsed = [[dictionary andy_valueForKey:@"collapsed"] boolValue];
    
    if ([dictionary andy_valueForKey:@"collapsible"]) {
        self.collapsible = [[dictionary andy_valueForKey:@"collapsible"] boolValue];
    } else {
        self.collapsible = YES;
    }

    NSDictionary *styles = [dictionary andy_valueForKey:@"styles"];
    _styles = styles;

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

        section.group = self;

        [sections addObject:section];
    }];

    self.sections = sections;

    return self;
}

- (NSArray *)targetsUsingArray:(NSArray *)array {
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

- (NSArray *)fields {
    NSMutableArray *array = [NSMutableArray new];

    for (FORMSection *section in self.sections) {
        [array addObjectsFromArray:section.fields];
    }

    return array;
}

- (NSInteger)numberOfFields {
    NSInteger count = 0;

    for (FORMSection *section in self.sections) {
        count += section.fields.count;
    }

    return count;
}

- (NSInteger)numberOfFields:(NSMutableDictionary *)deletedSections {
    NSInteger count = 0;

    for (FORMSection *section in self.sections) {
        if (!deletedSections[section.sectionID]) {
            count += section.fields.count;
        }
    }

    return count;
}

- (NSString *)description {
    NSMutableArray *fields = [NSMutableArray new];

    for (FORMSection *section in self.sections) {
        [fields addObject:[NSString stringWithFormat:@"--- Section: %@ ---", section.sectionID]];
        for (FORMField *field in section.fields) {
            [fields addObject:[NSString stringWithFormat:@"%@ --- %@ (section %@ : field %@)\n", field.fieldID, field.value, field.section.position, field.position]];
        }
        [fields addObject:@" "];
    }

    return [NSString stringWithFormat:@"\n — Group: %@ —\n title: %@\n position: %@\n shouldValidate: %@\n sections: %@\n",
            self.groupID, self.title, self.position, self.shouldValidate ? @"YES" : @"NO", fields];
}

- (void)removeSection:(FORMSection *)section {
    __block BOOL found = NO;
    __block NSInteger index = 0;

    [self.sections enumerateObjectsUsingBlock:^(FORMSection *currentSection, NSUInteger idx, BOOL *stop) {
        if (found) {
            currentSection.position = @([currentSection.position integerValue] - 1);
        }

        if ([currentSection.sectionID isEqualToString:section.sectionID]) {
            index = idx;
            found = YES;
        }
    }];

    if (!found) index = [self.sections count];

    [self.sections removeObjectAtIndex:index];
    [self resetSectionPositions];
}

- (void)resetSectionPositions {
    [self.sections enumerateObjectsUsingBlock:^(FORMSection *section, NSUInteger idx, BOOL *stop) {
        section.position = @(idx);
    }];
}

@end
