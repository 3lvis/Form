#import "FORMDataSource.h"

#import "FORMBackgroundView.h"
#import "FORMLayout.h"

#import "FORMTextFieldCell.h"
#import "FORMSelectFieldCell.h"
#import "FORMDateFieldCell.h"
#import "FORMButtonFieldCell.h"
#import "FORMFieldValue.h"
#import "HYPParsedRelationship.h"

#import "NSString+HYPWordExtractor.h"
#import "NSString+HYPFormula.h"
#import "UIDevice+HYPRealOrientation.h"
#import "NSObject+HYPTesting.h"
#import "NSString+HYPRelationshipParser.h"
#import "NSString+HYPContainsString.h"
#import "NSDictionary+ANDYSafeValue.h"
#import "NSDictionary+HYPNestedAttributes.h"
#import "NSString+HYPRelationshipParser.h"

#import "UIColor+Hex.h"

static const CGFloat FORMDispatchTime = 0.05f;

static NSString * const FORMDynamicAddFieldID = @"add";
static NSString * const FORMDynamicRemoveFieldID = @"remove";
static const CGFloat FORMKeyboardAnimationDuration = 0.3f;

@interface FORMDataSource () <FORMBaseFieldCellDelegate, FORMHeaderViewDelegate>

@property (nonatomic) UIEdgeInsets originalInset;
@property (nonatomic) BOOL disabled;
@property (nonatomic) FORMData *formData;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) FORMLayout *layout;
@property (nonatomic, copy) NSArray *JSON;
@property (nonatomic) NSMutableArray *collapsedGroups;

@end

@implementation FORMDataSource

#pragma mark - Dealloc

- (void)dealloc {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - Initializers

- (instancetype)initWithJSON:(id)JSON
              collectionView:(UICollectionView *)collectionView
                      layout:(FORMLayout *)layout
                      values:(NSDictionary *)values
                    disabled:(BOOL)disabled {
    self = [super init];
    if (!self) return nil;

    _collectionView = collectionView;

    _layout = layout;

    _originalInset = collectionView.contentInset;

    layout.dataSource = self;

    _formData = [[FORMData alloc] initWithJSON:JSON
                                 initialValues:values
                              disabledFieldIDs:@[]
                                      disabled:disabled];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:FORMHideTooltips
                                                        object:@(!disabled)];

    return self;
}

#pragma mark - Getters

- (NSMutableArray *)collapsedGroups {
    if (_collapsedGroups) return _collapsedGroups;

    _collapsedGroups = [NSMutableArray new];

    NSMutableArray *indexPaths = [NSMutableArray new];

    [self.formData.groups enumerateObjectsUsingBlock:^(FORMGroup *formGroup, NSUInteger idx, BOOL *stop) {
        if (formGroup.collapsed) {
            if (![_collapsedGroups containsObject:@(idx)]) {
                for (NSInteger i = 0; i < formGroup.fields.count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:idx];
                    [indexPaths addObject:indexPath];
                }
                [_collapsedGroups addObject:@(idx)];
            }
        }
    }];

    return _collapsedGroups;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.formData.groups.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    FORMGroup *group = self.formData.groups[section];
    if ([self.collapsedGroups containsObject:@(section)]) {
        return 0;
    } else {
        return [group numberOfFields:self.formData.hiddenSections];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FORMGroup *group = self.formData.groups[indexPath.section];
    NSArray *fields = group.fields;
    FORMField *field = fields[indexPath.row];

    if (self.configureCellForItemAtIndexPathBlock) {
        id configuredCell = self.configureCellForItemAtIndexPathBlock(field, collectionView, indexPath);
        if (configuredCell) {
            return configuredCell;
        }
    }

    NSString *identifier;

    switch (field.type) {

        case FORMFieldTypeDate:
        case FORMFieldTypeDateTime:
        case FORMFieldTypeTime:
            identifier = [NSString stringWithFormat:@"%@-%@", FORMDateFormFieldCellIdentifier, field.fieldID];
            [collectionView registerClass:[FORMDateFieldCell class]
               forCellWithReuseIdentifier:identifier];
            break;

        case FORMFieldTypeSelect:
            identifier = [NSString stringWithFormat:@"%@-%@", FORMSelectFormFieldCellIdentifier, field.fieldID];
            [collectionView registerClass:[FORMSelectFieldCell class]
               forCellWithReuseIdentifier:identifier];
            break;

        case FORMFieldTypeText:
        case FORMFieldTypeFloat:
        case FORMFieldTypeNumber:
            identifier = [NSString stringWithFormat:@"%@-%@", FORMTextFieldCellIdentifier, field.fieldID];
            [collectionView registerClass:[FORMTextFieldCell class]
               forCellWithReuseIdentifier:identifier];

            break;

        case FORMFieldTypeCount:
            identifier = [NSString stringWithFormat:@"%@-%@", FORMCountFieldCellIdentifier, field.fieldID];
            [collectionView registerClass:[FORMTextFieldCell class]
               forCellWithReuseIdentifier:identifier];
            break;

        case FORMFieldTypeButton:
            identifier = [NSString stringWithFormat:@"%@-%@", FORMButtonFieldCellIdentifier, field.fieldID];
            [collectionView registerClass:[FORMButtonFieldCell class]
               forCellWithReuseIdentifier:identifier];
            break;

        case FORMFieldTypeCustom: abort();
    }

    FORMBaseFieldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                        forIndexPath:indexPath];
    cell.delegate = self;

    if (self.configureCellBlock) {
        self.configureCellBlock(cell, indexPath, field);
    } else {
        cell.field = field;
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        FORMGroup *group = self.formData.groups[indexPath.section];
        FORMGroupHeaderView *headerView;

        NSString *identifier = [NSString stringWithFormat:@"%@-%@", FORMHeaderReuseIdentifier, group.groupID];
        [collectionView registerClass:[FORMGroupHeaderView class]
           forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                  withReuseIdentifier:identifier];


        if (self.configureGroupHeaderAtIndexPathBlock) {
            id configuredGroupHeaderView = self.configureGroupHeaderAtIndexPathBlock(group, collectionView, indexPath);
            if (configuredGroupHeaderView) {
                headerView = configuredGroupHeaderView;
            }
        }

        if (!headerView) {
            headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                            withReuseIdentifier:identifier
                                                                   forIndexPath:indexPath];
        }

        headerView.group = indexPath.section;

        if (self.configureHeaderViewBlock) {
            self.configureHeaderViewBlock(headerView, kind, indexPath, group);
        } else {
            headerView.headerLabel.text = group.title;
            headerView.styles = group.styles;
            headerView.collapsible = group.collapsible;
            headerView.delegate = self;
        }

        return headerView;
    }

    return nil;
}

#pragma mark - Public methods

- (NSArray *)safeIndexPaths:(NSArray *)indexPaths {
    NSMutableArray *safeIndexPaths = [NSMutableArray new];

    for (NSIndexPath *indexPath in indexPaths) {
        if (![self.collapsedGroups containsObject:@(indexPath.section)]) {
            [safeIndexPaths addObject:indexPath];
        }
    }

    return safeIndexPaths;
}

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths {
    NSArray *reloadedIndexPaths = [self safeIndexPaths:indexPaths];

    if (reloadedIndexPaths.count > 0) {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:reloadedIndexPaths];
        } completion:^(BOOL finished) {
            if (finished) {
                [self.collectionView reloadData];
            }
        }];
    }
}

- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths {
    NSArray *reloadedIndexPaths = [self safeIndexPaths:indexPaths];

    if (reloadedIndexPaths.count > 0) {
        [self.collectionView deleteItemsAtIndexPaths:reloadedIndexPaths];
    }
}

- (void)reloadFieldsAtIndexPaths:(NSArray *)indexPaths {
    NSArray *reloadedIndexPaths = [self safeIndexPaths:indexPaths];

    if (reloadedIndexPaths.count > 0) {
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadItemsAtIndexPaths:reloadedIndexPaths];
        }];
    }
}

- (CGSize)sizeForFieldAtIndexPath:(NSIndexPath *)indexPath {
    FORMGroup *group = self.formData.groups[indexPath.section];
    NSArray *fields = group.fields;

    CGRect bounds = self.collectionView.bounds;
    CGFloat deviceWidth = CGRectGetWidth(bounds) - (FORMMarginHorizontal * 2);
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;

    FORMField *field;
    if (indexPath.row < fields.count) {
        field = fields[indexPath.row];
    }

    if (field.sectionSeparator) {
        width = deviceWidth;
        height = FORMFieldCellItemSmallHeight;
    } else if (field) {
        width = floor(deviceWidth * (field.size.width / 100.0f));

        if (field.type == FORMFieldTypeCustom) {
            height = field.size.height * FORMFieldCellItemHeight;
        } else {
            height = FORMFieldCellItemHeight;
        }
    }

    return CGSizeMake(width, height);
}

- (FORMField *)fieldAtIndexPath:(NSIndexPath *)indexPath {
    FORMGroup *group = self.formData.groups[indexPath.section];
    NSArray *fields = group.fields;
    FORMField *field = fields[indexPath.row];

    return field;
}

- (void)enable {
    [self disable:NO];
}

- (void)disable {
    self.formData.removedValues = nil;

    [self disable:YES];
}

- (void)disable:(BOOL)disabled {
    self.disabled = disabled;

    if (disabled) {
        [self.formData disable];
    } else {
        [self.formData enable];
    }

    NSMutableDictionary *fields = [NSMutableDictionary new];

    for (FORMGroup *group in self.formData.groups) {
        for (FORMField *field in group.fields) {
            if (field.fieldID) {
                [fields addEntriesFromDictionary:@{field.fieldID : field}];
            }
        }
    }

    [fields addEntriesFromDictionary:self.formData.hiddenFieldsAndFieldIDsDictionary];

    for (FORMSection *section in [self.formData.hiddenSections allValues]) {
        for (FORMField *field in section.fields) {
            if (field.fieldID) {
                [fields addEntriesFromDictionary:@{field.fieldID : field}];
            }
        }
    }

    for (NSString *fieldID in fields) {
        FORMField *field = [fields valueForKey:fieldID];
        BOOL shouldChangeState = (![self.formData.disabledFieldsIDs containsObject:fieldID]);

        if (disabled) {
            field.disabled = YES;
        } else if (shouldChangeState) {
            if (!field.initiallyDisabled) {
                field.disabled = NO;
            }

            if (field.targets.count > 0) {
                [self processTargets:field.targets];
            } else if (field.type == FORMFieldTypeSelect) {
                BOOL hasFieldValue = (field.value && [field.value isKindOfClass:[FORMFieldValue class]]);
                if (hasFieldValue) {
                    FORMFieldValue *fieldValue = (FORMFieldValue *)field.value;

                    NSMutableArray *targets = [NSMutableArray new];

                    for (FORMTarget *target in fieldValue.targets) {
                        BOOL targetIsNotEnableOrDisable = (target.actionType != FORMTargetActionEnable &&
                                                           target.actionType != FORMTargetActionDisable);
                        if (targetIsNotEnableOrDisable) {
                            [targets addObject:target];
                        }
                    }

                    if (targets.count > 0) {
                        [self processTargets:targets];
                    }
                }
            }
        }
    }

    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
    }];

    [[NSNotificationCenter defaultCenter] postNotificationName:FORMHideTooltips
                                                        object:@(!disabled)];
}

- (BOOL)isDisabled {
    return _disabled;
}

- (BOOL)isEnabled {
    return !_disabled;
}

- (void)collapseGroup:(NSInteger)group {
    [self collapseFieldsInGroup:group
                 collectionView:self.collectionView];
}

- (void)collapseAllGroups {
    [self collapseAllGroupsForCollectionView:self.collectionView];
}

- (void)collapseAllGroupsForCollectionView:(UICollectionView *)collectionView {
    NSMutableArray *indexPaths = [NSMutableArray new];

    [self.formData.groups enumerateObjectsUsingBlock:^(FORMGroup *formGroup, NSUInteger idx, BOOL *stop) {
        if (formGroup.collapsible) {
            if (![self.collapsedGroups containsObject:@(idx)]) {
                for (NSInteger i = 0; i < formGroup.fields.count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:idx];
                    [indexPaths addObject:indexPath];
                }
                [self.collapsedGroups addObject:@(idx)];
            }
        }
    }];

    [collectionView deleteItemsAtIndexPaths:indexPaths];
    [collectionView.collectionViewLayout invalidateLayout];
}

- (void)reloadWithDictionary:(NSDictionary *)dictionary {
    [self.formData.values setValuesForKeysWithDictionary:dictionary];

    NSMutableArray *updatedIndexPaths = [NSMutableArray new];
    NSMutableArray *targets = [NSMutableArray new];

    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        [self.formData fieldWithID:key
             includingHiddenFields:YES
                        completion:^(FORMField *field, NSIndexPath *indexPath) {
                            BOOL shouldBeNil = ([value isEqual:[NSNull null]]);

                            if (field) {

                                if (field.values.count) {
                                    if (shouldBeNil) {
                                        field.value = nil;
                                    } else {
                                        for (FORMFieldValue *fieldValue in field.values) {
                                            if ([value isEqual:fieldValue.valueID]) {
                                                field.value = fieldValue;
                                                break;
                                            }
                                        }
                                    }

                                } else {
                                    field.value = (shouldBeNil) ? nil : value;
                                }

                                if (indexPath) {
                                    [updatedIndexPaths addObject:indexPath];
                                }
                                [targets addObjectsFromArray:[field safeTargets]];
                            } else {
                                field = ([self fieldInDeletedFields:key]) ?: [self fieldInDeletedSections:key];
                                if (field) {
                                    field.value = (shouldBeNil) ? nil : value;
                                }
                            }
                        }];
    }];

    [self processTargets:targets];
}

- (void)resetDynamicSectionsWithDictionary:(NSDictionary *)dictionary {
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (self.formData.values[key]) {
            self.formData.values[key] = obj;
        }
    }];

    NSMutableSet *currentSections = [NSMutableSet new];
    for (NSString *key in self.formData.values) {
        HYPParsedRelationship *parsed = [key hyp_parseRelationship];
        if (parsed.toMany) {
            parsed.attribute = nil;
            [currentSections addObject:[parsed key]];
        }
    }

    NSMutableDictionary *insertedValues = [NSMutableDictionary new];
    for (NSString *key in dictionary) {
        HYPParsedRelationship *parsed = [key hyp_parseRelationship];
        if (parsed.toMany) {
            parsed.attribute = nil;

            BOOL valueBelongsToInsertedSection = (![currentSections containsObject:[parsed key]] &&
                                                  ![dictionary[key] isKindOfClass:[NSNull class]]);
            if (valueBelongsToInsertedSection) {
                [insertedValues addEntriesFromDictionary:@{key : dictionary[key]}];
            }
        }
    }

    NSArray *removedSections = [self.formData removedSectionsUsingInitialValues:dictionary];
    for (FORMSection *section in removedSections) {
        [self.formData removeSection:section
                    inCollectionView:self.collectionView];
    }

    [self.formData.values setValuesForKeysWithDictionary:dictionary];

    [self insertDynamicSectionsForValues:[insertedValues copy]];

    NSMutableArray *updatedIndexPaths = [NSMutableArray new];
    NSMutableArray *targets = [NSMutableArray new];

    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        [self.formData fieldWithID:key
             includingHiddenFields:YES
                        completion:^(FORMField *field, NSIndexPath *indexPath) {
                            BOOL shouldBeNil = ([value isEqual:[NSNull null]]);

                            if (field) {
                                field.value = (shouldBeNil) ? nil : value;
                                if (indexPath) {
                                    [updatedIndexPaths addObject:indexPath];
                                }
                                [targets addObjectsFromArray:[field safeTargets]];
                            } else {
                                field = ([self fieldInDeletedFields:key]) ?: [self fieldInDeletedSections:key];
                                if (field) {
                                    field.value = (shouldBeNil) ? nil : value;
                                }
                            }
                        }];
    }];

    [self processTargets:targets];
}

- (FORMField *)fieldInDeletedFields:(NSString *)fieldID {
    __block FORMField *foundField = nil;

    [self.formData.hiddenFieldsAndFieldIDsDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, FORMField *field, BOOL *stop) {
        if ([field.fieldID isEqualToString:fieldID]) {
            foundField = field;
            *stop = YES;
        }
    }];

    return foundField;
}

- (FORMField *)fieldInDeletedSections:(NSString *)fieldID {
    __block FORMField *foundField = nil;

    [self.formData.hiddenSections enumerateKeysAndObjectsUsingBlock:^(NSString *key, FORMSection *section, BOOL *stop) {
        [section.fields enumerateObjectsUsingBlock:^(FORMField *field, NSUInteger idx, BOOL *stop) {
            if ([field.fieldID isEqualToString:fieldID]) {
                foundField = field;
                *stop = YES;
            }
        }];
    }];

    return foundField;
}

#pragma mark Validations

- (void)validateForms {
    [self validate];
}

- (BOOL)formFieldsAreValid {
    return [self isValid];
}

- (void)resetForms {
    [self reset];
}

#pragma mark - FORMBaseFieldCellDelegate

- (void)fieldCell:(UICollectionViewCell *)fieldCell
 updatedWithField:(FORMField *)field {
    if (self.fieldUpdatedBlock) {
        self.fieldUpdatedBlock(fieldCell, field);
    }

    NSArray *components = [field.fieldID componentsSeparatedByString:@"."];
    if (components.count == 2) {
        if ([components.lastObject isEqualToString:FORMDynamicAddFieldID]) {
            NSString *sectionTemplateID = [components firstObject];
            FORMSection *section = [self sectionWithID:sectionTemplateID];
            [self.formData insertTemplateSectionWithID:sectionTemplateID
                                    intoCollectionView:self.collectionView
                                            usingGroup:section.group];
        } else if ([components.lastObject isEqualToString:FORMDynamicRemoveFieldID]) {
            HYPParsedRelationship *parsed = [field.fieldID hyp_parseRelationship];
            parsed.attribute = nil;
            NSString *sectionID = [parsed key];
            FORMSection *section = [self.formData sectionWithID:sectionID];
            [self.formData removeSection:section
                        inCollectionView:self.collectionView];
        }

        if (field.targets) {
            [self processTargets:field.targets];
        }
    }

    BOOL isValidField = (!(components.count == 2 &&
                           [components.lastObject isEqualToString:FORMDynamicRemoveFieldID]) &&
                         field != nil);
    if (isValidField) {
        if (!field.value) {
            [self.formData.values removeObjectForKey:field.fieldID];
        } else if ([field.value isKindOfClass:[FORMFieldValue class]]) {
            FORMFieldValue *fieldValue = field.value;
            self.formData.values[field.fieldID] = fieldValue.valueID;
        } else {
            self.formData.values[field.fieldID] = field.value;
        }

        BOOL hasFieldValue = (field.value && [field.value isKindOfClass:[FORMFieldValue class]]);
        if (hasFieldValue) {
            FORMFieldValue *fieldValue = field.value;
            [self processTargets:fieldValue.targets];
        } else if (field.targets.count > 0) {
            [self processTargets:field.targets];
        }
    }
}

- (void)fieldCell:(UICollectionViewCell *)fieldCell
   processTargets:(NSArray *)targets {
    NSTimeInterval delay = ([NSObject isUnitTesting]) ? FORMDispatchTime : 0.0f;
    [self performSelector:@selector(processTargets:)
               withObject:targets
               afterDelay:delay];
}

#pragma mark - Targets Procesing

- (void)processTarget:(FORMTarget *)target {
    switch (target.actionType) {
        case FORMTargetActionShow: {
            NSArray *insertedIndexPaths = [self.formData showTargets:@[target]];
            [self insertItemsAtIndexPaths:insertedIndexPaths];
        } break;
        case FORMTargetActionHide: {
            NSArray *deletedIndexPaths = [self.formData hideTargets:@[target]];
            [self deleteItemsAtIndexPaths:deletedIndexPaths];
        } break;
        case FORMTargetActionClear:
        case FORMTargetActionUpdate: {
            NSArray *updatedIndexPaths = [self.formData updateTargets:@[target]];
            [self reloadFieldsAtIndexPaths:updatedIndexPaths];
        } break;
        case FORMTargetActionEnable: {
            if ([self.formData isEnabled]) {
                NSArray *enabledIndexPaths = [self.formData enableTargets:@[target]];
                [self reloadFieldsAtIndexPaths:enabledIndexPaths];
            }
        } break;
        case FORMTargetActionDisable: {
            NSArray *disabledIndexPaths = [self.formData disableTargets:@[target]];
            [self reloadFieldsAtIndexPaths:disabledIndexPaths];
        } break;
        case FORMTargetActionNone: break;
    }
}

- (NSArray *)sortTargets:(NSArray *)targets {
    NSSortDescriptor *sortByTypeString = [NSSortDescriptor sortDescriptorWithKey:@"typeString"
                                                                       ascending:YES];
    NSArray *sortedTargets = [targets sortedArrayUsingDescriptors:@[sortByTypeString]];

    return sortedTargets;
}

- (void)processTargets:(NSArray *)targets {
    [FORMTarget filteredTargets:targets
                       filtered:^(NSArray *shownTargets,
                                  NSArray *hiddenTargets,
                                  NSArray *updatedTargets,
                                  NSArray *enabledTargets,
                                  NSArray *disabledTargets) {
                           shownTargets  = [self sortTargets:shownTargets];
                           hiddenTargets = [self sortTargets:hiddenTargets];

                           NSArray *insertedIndexPaths;
                           NSArray *deletedIndexPaths;
                           NSArray *updatedIndexPaths;
                           NSArray *enabledIndexPaths;
                           NSArray *disabledIndexPaths;

                           if (shownTargets.count > 0) {
                               insertedIndexPaths = [self.formData showTargets:shownTargets];
                               [self insertItemsAtIndexPaths:insertedIndexPaths];
                           }

                           if (hiddenTargets.count > 0) {
                               deletedIndexPaths = [self.formData hideTargets:hiddenTargets];
                               [self deleteItemsAtIndexPaths:deletedIndexPaths];
                           }

                           if (updatedTargets.count > 0) {
                               updatedIndexPaths = [self.formData updateTargets:updatedTargets];

                               if (deletedIndexPaths) {
                                   NSMutableArray *filteredIndexPaths = [updatedIndexPaths mutableCopy];
                                   for (NSIndexPath *indexPath in updatedIndexPaths) {
                                       if ([deletedIndexPaths containsObject:indexPath]) {
                                           [filteredIndexPaths removeObject:indexPath];
                                       }
                                   }

                                   [self reloadFieldsAtIndexPaths:filteredIndexPaths];
                               } else {
                                   [self reloadFieldsAtIndexPaths:updatedIndexPaths];
                               }
                           }

                           BOOL shouldRunEnableTargets = (enabledTargets.count > 0 && [self.formData isEnabled]);
                           if (shouldRunEnableTargets) {
                               enabledIndexPaths = [self.formData enableTargets:enabledTargets];

                               [self reloadFieldsAtIndexPaths:enabledIndexPaths];
                           }

                           if (disabledTargets.count > 0) {
                               disabledIndexPaths = [self.formData disableTargets:disabledTargets];

                               [self reloadFieldsAtIndexPaths:disabledIndexPaths];
                           }
                       }];
}

#pragma mark - Target helpers

#pragma mark Sections

- (void)insertedIndexPathsAndSectionIndexForSection:(FORMSection *)section
                                         completion:(void (^)(NSArray *indexPaths, NSInteger index))completion {
    NSMutableArray *indexPaths = [NSMutableArray new];

    NSInteger groupIndex = [section.group.position integerValue];
    FORMGroup *group = self.formData.groups[groupIndex];

    NSInteger fieldsIndex = 0;
    NSInteger sectionIndex = 0;
    for (FORMSection *aSection in group.sections) {
        if ([aSection.position integerValue] < [section.position integerValue]) {
            fieldsIndex += aSection.fields.count;
            sectionIndex++;
        }
    }

    NSInteger fieldsInSectionCount = fieldsIndex + section.fields.count;
    for (NSInteger i = fieldsIndex; i < fieldsInSectionCount; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i
                                                 inSection:groupIndex]];
    }

    if (completion) {
        completion(indexPaths, sectionIndex);
    }
}

- (BOOL)groupIsCollapsed:(NSInteger)group {
    return [self.collapsedGroups containsObject:@(group)];
}

#pragma mark - Keyboard Support

- (void)keyboardDidShow:(NSNotification *)notification {
    CGRect keyboardEndFrame;
    [(notification.userInfo)[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

    NSInteger height = CGRectGetHeight(keyboardEndFrame);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        if ([[UIDevice currentDevice] hyp_isLandscape]) {
            height = CGRectGetWidth(keyboardEndFrame);
        }
    }

    UIEdgeInsets inset = self.originalInset;
    inset.bottom += height;

    [UIView animateWithDuration:FORMKeyboardAnimationDuration animations:^{
        self.collectionView.contentInset = inset;
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    CGRect keyboardEndFrame;
    [(notification.userInfo)[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

    [UIView animateWithDuration:FORMKeyboardAnimationDuration animations:^{
        self.collectionView.contentInset = self.originalInset;
    }];
}

#pragma mark - FORMHeaderViewDelegate

- (void)groupHeaderViewWasPressed:(FORMGroupHeaderView *)headerView {
    [self collapseFieldsInGroup:headerView.group
                 collectionView:self.collectionView];
}

#pragma mark - FORMLayoutDataSource

- (NSArray *)groups {
    return self.formData.groups;
}

#pragma mark - FORMData bridge

- (NSDictionary *)invalidFields {
    return [self.formData invalidFormFields];
}

- (NSDictionary *)requiredFields {
    return [self.formData requiredFormFields];
}

- (BOOL)isValid {
    BOOL formIsValid = YES;
    for (FORMGroup *group in self.formData.groups) {
        for (FORMField *field in group.fields) {
            FORMValidationResultType fieldValidation = [field validate];
            BOOL requiredFieldFailedValidation = (fieldValidation != FORMValidationResultTypeValid);
            if (requiredFieldFailedValidation) {
                formIsValid = NO;
            }
        }
    }

    return formIsValid;
}

- (void)reset {
    for (FORMGroup *group in self.formData.groups) {
        for (FORMField *field in group.fields) {
            field.value = nil;
        }
    }

    self.formData.values = nil;
    self.formData.removedValues = nil;

    [self.collapsedGroups removeAllObjects];
    [self.formData.hiddenFieldsAndFieldIDsDictionary removeAllObjects];
    [self.formData.hiddenSections removeAllObjects];
    [self.collectionView reloadData];
}

- (void)validate {
    NSMutableSet *validatedFields = [NSMutableSet set];

    NSArray *cells = [self.collectionView visibleCells];
    for (FORMBaseFieldCell *cell in cells) {
        if ([cell respondsToSelector:@selector(validate)]) {
            [cell validate];

            if (cell.field.fieldID) {
                [validatedFields addObject:cell.field.fieldID];
            }
        }
    }

    for (FORMGroup *group in self.formData.groups) {
        for (FORMField *field in group.fields) {
            if (![validatedFields containsObject:field.fieldID]) {
                [field validate];
            }
        }
    }
}

- (NSDictionary *)invalidFormFields {
    return [self.formData invalidFormFields];
}

- (NSDictionary *)requiredFormFields {
    return [self.formData requiredFormFields];
}

- (NSMutableDictionary *)valuesForFormula:(FORMField *)field {
    return [self.formData valuesForFormula:field];
}

- (FORMGroup *)groupWithID:(NSString *)groupID {
    return [self.formData groupWithID:groupID];
}

- (FORMSection *)sectionWithID:(NSString *)sectionID {
    return [self.formData sectionWithID:sectionID];
}

- (void)sectionWithID:(NSString *)sectionID
           completion:(void (^)(FORMSection *section, NSArray *indexPaths))completion {
    [self.formData sectionWithID:sectionID
                      completion:completion];
}

- (void)indexForFieldWithID:(NSString *)fieldID
            inSectionWithID:(NSString *)sectionID
                 completion:(void (^)(FORMSection *section, NSInteger index))completion {
    [self.formData indexForFieldWithID:fieldID
                       inSectionWithID:sectionID
                            completion:completion];
}

- (FORMField *)fieldWithID:(NSString *)fieldID
     includingHiddenFields:(BOOL)includingHiddenFields {
    return [self.formData fieldWithID:fieldID
                includingHiddenFields:includingHiddenFields];
}

- (void)fieldWithID:(NSString *)fieldID
includingHiddenFields:(BOOL)includingHiddenFields
         completion:(void (^)(FORMField *field, NSIndexPath *indexPath))completion {
    [self.formData fieldWithID:fieldID
         includingHiddenFields:includingHiddenFields
                    completion:completion];
}

- (NSArray *)showTargets:(NSArray *)targets {
    return [self.formData showTargets:targets];
}

- (NSArray *)hideTargets:(NSArray *)targets {
    return [self.formData hideTargets:targets];
}

- (NSArray *)updateTargets:(NSArray *)targets {
    return [self.formData updateTargets:targets];
}

- (NSArray *)enableTargets:(NSArray *)targets {
    return [self.formData enableTargets:targets];
}

- (NSArray *)disableTargets:(NSArray *)targets {
    return [self.formData disableTargets:targets];
}

- (NSInteger)numberOfFields {
    return [self.formData numberOfFields];
}

- (void)updateValuesWithDictionary:(NSDictionary *)dictionary {
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        self.formData.values[key] = obj;
    }];
}

- (NSDictionary *)values {
    return [self.formData.values copy];
}

- (NSDictionary *)removedValues {
    return [self.formData.removedValues copy];
}

#pragma mark - Private methods

- (void)collapseFieldsInGroup:(NSInteger)group
               collectionView:(UICollectionView *)collectionView {
    BOOL headerIsCollapsed = ([self groupIsCollapsed:group]);

    NSMutableArray *indexPaths = [NSMutableArray new];
    FORMGroup *formGroup = self.formData.groups[group];

    for (NSInteger i = 0; i < formGroup.fields.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:group];
        [indexPaths addObject:indexPath];
    }

    if (headerIsCollapsed) {
        [self.collapsedGroups removeObject:@(group)];
        [collectionView insertItemsAtIndexPaths:indexPaths];
        [collectionView.collectionViewLayout invalidateLayout];
    } else if (formGroup.collapsible) {
        [self.collapsedGroups addObject:@(group)];
        [collectionView deleteItemsAtIndexPaths:indexPaths];
        [collectionView.collectionViewLayout invalidateLayout];
    }
}

- (NSDictionary *)updateValueKeys:(NSArray *)currentKeys {
    NSArray *keys = [currentKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
    __block NSNumber *currentIndex;
    __block NSInteger newIndex = 0;

    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        HYPParsedRelationship *parsed = [key hyp_parseRelationship];
        if (parsed.relationship) {
            BOOL shouldIncrementIndex = (currentIndex &&
                                         [parsed.index integerValue] > [currentIndex integerValue]);
            if (shouldIncrementIndex) {
                newIndex++;
            }

            currentIndex = parsed.index;
            NSString *oldKey = [parsed key];
            NSString *newKey = [[parsed key] hyp_updateRelationshipIndex:newIndex];
            mutableDictionary[oldKey] = newKey;
        }
    }];

    return [mutableDictionary copy];
}

- (void)removeDynamicKeysForSection:(FORMSection *)section {
    __block NSString *sectionID = [section.sectionID substringToIndex:[section.sectionID rangeOfString:@"["].location];
    [self.values enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key hasPrefix:sectionID]) {
            [self.formData.values removeObjectForKey:key];
        }
    }];
}

- (void)insertDynamicSectionsForValues:(NSDictionary *)values {
    NSDictionary *JSONAttributes = [values hyp_JSONNestedAttributes];
    [JSONAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            FORMSection *section = [self sectionWithID:key];
            for (NSInteger numberOfSections = 0; numberOfSections < [obj count]; numberOfSections++) {
                [self.formData insertTemplateSectionWithID:key
                                        intoCollectionView:self.collectionView
                                                usingGroup:section.group];
            }
        }
    }];
}

@end
