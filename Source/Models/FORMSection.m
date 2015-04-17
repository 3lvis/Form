#import "FORMSection.h"
#import "FORMField.h"
#import "FORMGroup.h"
#import "NSDictionary+ANDYSafeValue.h"
#import "FORMTarget.h"

@implementation FORMSection

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                          position:(NSInteger)position
                          disabled:(BOOL)disabled
                 disabledFieldsIDs:(NSArray *)disabledFieldsIDs
                     isLastSection:(BOOL)isLastSection {
    self = [super init];
    if (!self) return nil;

    _sectionID = [dictionary andy_valueForKey:@"id"];
    _position = @(position);
    _isLast = isLastSection;
    _typeString  = [dictionary andy_valueForKey:@"type"] ?: @"default";
    _type = [self typeFromTypeString:_typeString];

    NSArray *dataSourceFields = [dictionary andy_valueForKey:@"fields"];
    NSMutableArray *fields = [NSMutableArray new];

    [dataSourceFields enumerateObjectsUsingBlock:^(NSDictionary *fieldDict, NSUInteger fieldIndex, BOOL *stop) {

        FORMField *field = [[FORMField  alloc] initWithDictionary:fieldDict
                                                         position:fieldIndex
                                                         disabled:disabled
                                                disabledFieldsIDs:disabledFieldsIDs];
        field.section = self;
        [fields addObject:field];
    }];

    if (_type == FORMSectionTypeDynamic) {
        FORMField *field = [FORMField new];
        field.position = @(fields.count);
        field.section = self;
        field.fieldID = [NSString stringWithFormat:@"%@.add", self.sectionID];
        field.typeString = @"button";
        field.type = FORMFieldTypeButton;

        NSString *actionTitle = [dictionary andy_valueForKey:@"action_title"];
        if (!actionTitle) {
            NSLog(@"Specify and `action_title` for your dynamic section");
            abort();
        }
        field.title = actionTitle;
        field.section = self;
        field.size = CGSizeMake(100.0f, 2.0f);
        field.disabled = disabled;

        NSMutableArray *targets = [NSMutableArray new];

        for (NSDictionary *targetDictionary in [dictionary andy_valueForKey:@"targets"]) {
            FORMTarget *target = [[FORMTarget alloc] initWithDictionary:targetDictionary];
            [targets addObject:target];
        }

        if (targets) {
            field.targets = targets;
        }

        [fields addObject:field];
    }

    if (!isLastSection || _type == FORMSectionTypeDynamic) {
        FORMField *field = [FORMField new];
        field.sectionSeparator = YES;
        field.position = @(fields.count);
        field.section = self;
        field.fieldID = [NSString stringWithFormat:@"separator-%@", _sectionID];
        [fields addObject:field];
    }

    self.fields = fields;

    return self;
}

- (FORMSectionType)typeFromTypeString:(NSString *)typeString {
    if ([typeString isEqualToString:@"dynamic"]) {
        return FORMSectionTypeDynamic;
    } else {
        return FORMSectionTypeDefault;
    }
}

#pragma mark - Public Methods

#pragma mark Class

+ (void)sectionAndIndexForField:(FORMField *)field
                       inGroups:(NSArray *)groups
                     completion:(void (^)(BOOL found,
                                          FORMSection *section,
                                          NSInteger index))completion {
    FORMGroup *group = groups[[field.section.group.position integerValue]];
    FORMSection *section = group.sections[[field.section.position integerValue]];

    __block NSInteger index = 0;
    __block BOOL found = NO;
    [section.fields enumerateObjectsUsingBlock:^(FORMField *aField, NSUInteger idx, BOOL *stop) {
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

- (NSInteger)indexInGroups:(NSArray *)groups {
    FORMGroup *group = groups[[self.group.position integerValue]];

    BOOL found = NO;
    NSInteger index = 0;
    NSUInteger idx = 0;

    for (FORMSection *aSection in group.sections) {
        if ([aSection.position integerValue] >= [self.position integerValue]) {
            index = idx;
            found = YES;
            break;
        }

        idx++;
    }

    if (!found) index = [group.sections count];

    return index;
}

- (void)removeField:(FORMField *)field inGroups:(NSArray *)groups {
    __block NSInteger index = 0;
    __block BOOL found = NO;

    [self.fields enumerateObjectsUsingBlock:^(FORMField *currentField, NSUInteger idx, BOOL *stop) {
        if ([currentField.fieldID isEqualToString:field.fieldID]) {
            index = idx;
            found = YES;
        }
    }];

    [self.fields removeObjectAtIndex:index];
}

- (void)resetFieldPositions {
    [self.fields enumerateObjectsUsingBlock:^(FORMField *field, NSUInteger idx, BOOL *stop) {
        field.position = @(idx);
    }];
}

- (NSString *)description {
    NSMutableArray *fields = [NSMutableArray new];
    for (FORMField *field in self.fields) {
        if (field.fieldID) {
            [fields addObject:field.fieldID];
        } else if (field.sectionSeparator) {
            [fields addObject:@"sectionSeparator"];
        }
    }

    return [NSString stringWithFormat:@"\n — Section: %@ —\n position: %@\n formID: %@\n shouldValidate: %@\n containsSpecialField: %@\n isLast: %@\n fields: %@\n",
            self.sectionID, self.position, self.group.groupID, self.shouldValidate ? @"YES" : @"NO", self.containsSpecialField ? @"YES" : @"NO", self.isLast ? @"YES" : @"NO", fields];
}

@end
