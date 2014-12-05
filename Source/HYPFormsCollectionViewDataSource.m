#import "HYPFormsCollectionViewDataSource.h"

#import "HYPFormBackgroundView.h"
#import "HYPFormsLayout.h"

#import "HYPTextFormFieldCell.h"
#import "HYPSelectFormFieldCell.h"
#import "HYPDateFormFieldCell.h"

#import "UIColor+ANDYHex.h"
#import "UIScreen+HYPLiveBounds.h"
#import "NSString+HYPWordExtractor.h"
#import "NSString+HYPFormula.h"
#import "UIDevice+HYPRealOrientation.h"

@interface HYPFormsCollectionViewDataSource () <HYPBaseFormFieldCellDelegate, HYPFormHeaderViewDelegate
, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic) UIEdgeInsets originalInset;
@property (nonatomic) BOOL disabled;
@property (nonatomic, weak) HYPFormsManager *formsManager;

@end

@implementation HYPFormsCollectionViewDataSource

#pragma mark - Dealloc

- (void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - Initializers

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                       andFormsManager:(HYPFormsManager *)formsManager
{
    self = [super init];
    if (!self) return nil;

    _formsManager = formsManager;

    _collectionView = collectionView;

    collectionView.dataSource = self;

    _originalInset = collectionView.contentInset;

    [collectionView registerClass:[HYPTextFormFieldCell class]
       forCellWithReuseIdentifier:HYPTextFormFieldCellIdentifier];

    [collectionView registerClass:[HYPSelectFormFieldCell class]
       forCellWithReuseIdentifier:HYPSelectFormFieldCellIdentifier];

    [collectionView registerClass:[HYPDateFormFieldCell class]
       forCellWithReuseIdentifier:HYPDateFormFieldCellIdentifier];

    [collectionView registerClass:[HYPFormHeaderView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:HYPFormHeaderReuseIdentifier];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

    return self;
}

#pragma mark - Getters

- (NSMutableArray *)collapsedForms
{
    if (_collapsedForms) return _collapsedForms;

    _collapsedForms = [NSMutableArray array];

    return _collapsedForms;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.formsManager.forms.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    HYPForm *form = self.formsManager.forms[section];
    if ([self.collapsedForms containsObject:@(section)]) {
        return 0;
    }

    return [form numberOfFields:self.formsManager.hiddenSections];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYPForm *form = self.formsManager.forms[indexPath.section];
    NSArray *fields = form.fields;
    HYPFormField *field = fields[indexPath.row];

    if ([self.dataSource respondsToSelector:@selector(formsCollectionDataSource:cellForField:atIndexPath:)]) {
        UICollectionViewCell *cell = [self.dataSource formsCollectionDataSource:self cellForField:field atIndexPath:indexPath];
        if (cell) return cell;
    }

    NSString *identifier;

    switch (field.type) {
        case HYPFormFieldTypeDate:
            identifier = HYPDateFormFieldCellIdentifier;
            break;
        case HYPFormFieldTypeSelect:
            identifier = HYPSelectFormFieldCellIdentifier;
            break;

        case HYPFormFieldTypeText:
        case HYPFormFieldTypeFloat:
        case HYPFormFieldTypeNumber:
            identifier = HYPTextFormFieldCellIdentifier;
            break;

        case HYPFormFieldTypeCustom: abort();
    }

    HYPBaseFormFieldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                           forIndexPath:indexPath];
    cell.delegate = self;

    if (self.configureCellBlock) {
        self.configureCellBlock(cell, indexPath, field);
    } else {
        cell.field = field;

        if (field.sectionSeparator) {
            cell.backgroundColor = [UIColor colorFromHex:@"C6C6C6"];
        } else {
            cell.backgroundColor = [UIColor clearColor];
        }
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        HYPFormHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                           withReuseIdentifier:HYPFormHeaderReuseIdentifier
                                                                                  forIndexPath:indexPath];

        HYPForm *form = self.formsManager.forms[indexPath.section];
        headerView.section = indexPath.section;

        if (self.configureHeaderViewBlock) {
            self.configureHeaderViewBlock(headerView, kind, indexPath, form);
        } else {
            headerView.headerLabel.text = form.title;
            headerView.delegate = self;
        }

        return headerView;
    }

    HYPFormBackgroundView *backgroundView = [collectionView dequeueReusableSupplementaryViewOfKind:HYPFormBackgroundKind
                                                                               withReuseIdentifier:HYPFormBackgroundReuseIdentifier
                                                                                      forIndexPath:indexPath];

    return backgroundView;
}

#pragma mark - Public methods

- (void)collapseFieldsInSection:(NSInteger)section collectionView:(UICollectionView *)collectionView
{
    BOOL headerIsCollapsed = ([self.collapsedForms containsObject:@(section)]);

    NSMutableArray *indexPaths = [NSMutableArray array];
    HYPForm *form = self.formsManager.forms[section];

    for (NSInteger i = 0; i < form.fields.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }

    if (headerIsCollapsed) {
        [self.collapsedForms removeObject:@(section)];
        [collectionView insertItemsAtIndexPaths:indexPaths];
        [collectionView.collectionViewLayout invalidateLayout];
    } else {
        [self.collapsedForms addObject:@(section)];
        [collectionView deleteItemsAtIndexPaths:indexPaths];
        [collectionView.collectionViewLayout invalidateLayout];
    }
}

- (NSArray *)safeIndexPaths:(NSArray *)indexPaths
{
    NSMutableArray *safeIndexPaths = [NSMutableArray new];

    for (NSIndexPath *indexPath in indexPaths) {
        if (![self.collapsedForms containsObject:@(indexPath.section)]) {
            [safeIndexPaths addObject:indexPath];
        }
    }

    return safeIndexPaths;
}

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths
{
    NSArray *reloadedIndexPaths = [self safeIndexPaths:indexPaths];

    if (reloadedIndexPaths.count > 0) {
        [self.collectionView insertItemsAtIndexPaths:reloadedIndexPaths];
    }
}

- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths
{
    NSArray *reloadedIndexPaths = [self safeIndexPaths:indexPaths];

    if (reloadedIndexPaths.count > 0) {
        [self.collectionView deleteItemsAtIndexPaths:reloadedIndexPaths];
    }
}

- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths
{
    NSArray *reloadedIndexPaths = [self safeIndexPaths:indexPaths];

    if (reloadedIndexPaths.count > 0) {
        [self.collectionView reloadItemsAtIndexPaths:reloadedIndexPaths];
    }
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYPForm *form = self.formsManager.forms[indexPath.section];

    NSArray *fields = form.fields;

    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
    CGFloat deviceWidth = CGRectGetWidth(bounds) - (HYPFormMarginHorizontal * 2);
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;

    HYPFormField *field = fields[indexPath.row];
    if (field.sectionSeparator) {
        width = deviceWidth;
        height = HYPFieldCellItemSmallHeight;
    } else {
        width = floor(deviceWidth * (field.size.width / 100.0f));

        if (field.type == HYPFormFieldTypeCustom) {
            height = field.size.height * HYPFieldCellItemHeight;
        } else {
            height = HYPFieldCellItemHeight;
        }
    }

    return CGSizeMake(width, height);
}

- (HYPFormField *)formFieldAtIndexPath:(NSIndexPath *)indexPath
{
    HYPForm *form = self.formsManager.forms[indexPath.section];
    NSArray *fields = form.fields;
    HYPFormField *field = fields[indexPath.row];
    return field;
}

- (HYPFormField *)fieldWithID:(NSString *)fieldID withIndexPath:(BOOL)withIndexPath
{
    NSParameterAssert(fieldID);

    __block HYPFormField *foundField = nil;

    [self.formsManager.forms enumerateObjectsUsingBlock:^(HYPForm *form, NSUInteger formIndex, BOOL *formStop) {
        [form.fields enumerateObjectsUsingBlock:^(HYPFormField *field, NSUInteger fieldIndex, BOOL *fieldStop) {
            if ([field.fieldID isEqualToString:fieldID]) {
                if (withIndexPath) {
                    field.indexPath = [NSIndexPath indexPathForItem:fieldIndex inSection:formIndex];
                }

                foundField = field;
                *formStop = YES;
            }
        }];
    }];

    if (!foundField) {
        [self.formsManager.hiddenFields enumerateKeysAndObjectsUsingBlock:^(NSString *hiddenFieldID, HYPFormField *formField, BOOL *stop) {
            if ([hiddenFieldID isEqualToString:fieldID]) {
                foundField = formField;
                *stop = YES;
            }
        }];
    }

    if (!foundField) {
        NSArray *deletedSections = [self.formsManager.hiddenSections allValues];
        [deletedSections enumerateObjectsUsingBlock:^(HYPFormSection *section, NSUInteger sectionIndex, BOOL *sectionStop) {
            [section.fields enumerateObjectsUsingBlock:^(HYPFormField *field, NSUInteger fieldIndex, BOOL *fieldStop) {
                if ([field.fieldID isEqualToString:fieldID]) {
                    if (withIndexPath) {
                        field.indexPath = [NSIndexPath indexPathForItem:fieldIndex inSection:sectionIndex];
                    }

                    foundField = field;
                    *sectionStop = YES;
                }
            }];
        }];
    }

    return foundField;
}

- (void)disable:(BOOL)disabled
{
    self.disabled = disabled;

    NSMutableDictionary *fields = [NSMutableDictionary dictionary];

    for (HYPForm *form in self.formsManager.forms) {
        for (HYPFormField *field in form.fields) {
            if (field.fieldID) {
                [fields addEntriesFromDictionary:@{field.fieldID : field}];
            }
        }
    }

    [fields addEntriesFromDictionary:self.formsManager.hiddenFields];

    for (HYPFormSection *section in [self.formsManager.hiddenSections allValues]) {
        for (HYPFormField *field in section.fields) {
            if (field.fieldID) {
                [fields addEntriesFromDictionary:@{field.fieldID : field}];
            }
        }
    }

    for (NSString *fieldID in fields) {
        BOOL shouldDisable = (![fieldID isEqualToString:@"blank"] && ![self.formsManager.disabledFieldsIDs containsObject:fieldID]);

        if (shouldDisable) {
            HYPFormField *field = [fields valueForKey:fieldID];
            field.disabled = disabled;
        }
    }

    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
    }];
}

- (void)reloadWithDictionary:(NSDictionary *)dictionary
{
    [self.formsManager.values setValuesForKeysWithDictionary:dictionary];

    NSMutableArray *updatedIndexPaths = [NSMutableArray array];
    NSMutableArray *targets = [NSMutableArray array];

    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        BOOL shouldBeNil = ([value isEqual:[NSNull null]]);

        HYPFormField *field = [HYPFormField fieldWithID:key inForms:self.formsManager.forms withIndexPath:YES];
        if (field) {
            field.fieldValue = (shouldBeNil) ? nil : value;
            [updatedIndexPaths addObject:field.indexPath];
            [targets addObjectsFromArray:[field safeTargets]];
        } else {
            field = ([self fieldInDeletedFields:key]) ?: [self fieldInDeletedSections:key];
            if (field) field.fieldValue = (shouldBeNil) ? nil : value;
        }
    }];

    if (updatedIndexPaths.count > 0) {
        [self.collectionView performBatchUpdates:^{
            [self reloadItemsAtIndexPaths:updatedIndexPaths];
        } completion:^(BOOL finished) {
            [self processTargets:targets];
        }];
    }
}

- (HYPFormField *)fieldInDeletedFields:(NSString *)fieldID
{
    __block HYPFormField *foundField = nil;

    [self.formsManager.hiddenFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, HYPFormField *field, BOOL *stop) {
        if ([field.fieldID isEqualToString:fieldID]) {
            foundField = field;
            *stop = YES;
        }
    }];

    return foundField;
}

- (HYPFormField *)fieldInDeletedSections:(NSString *)fieldID
{
    __block HYPFormField *foundField = nil;

    [self.formsManager.hiddenSections enumerateKeysAndObjectsUsingBlock:^(NSString *key, HYPFormSection *section, BOOL *stop) {
        [section.fields enumerateObjectsUsingBlock:^(HYPFormField *field, NSUInteger idx, BOOL *stop) {
            if ([field.fieldID isEqualToString:fieldID]) {
                foundField = field;
                *stop = YES;
            }
        }];
    }];

    return foundField;
}

#pragma mark Validations

- (void)validateForms
{
    NSMutableSet *validatedFields = [NSMutableSet set];

    NSArray *cells = [self.collectionView visibleCells];
    for (HYPBaseFormFieldCell *cell in cells) {
        if ([cell respondsToSelector:@selector(validate)]) {
            [cell validate];

            if (cell.field.fieldID) {
                [validatedFields addObject:cell.field.fieldID];
            }
        }
    }

    for (HYPForm *form in self.formsManager.forms) {
        for (HYPFormField *field in form.fields) {
            if (![validatedFields containsObject:field.fieldID]) {
                [field validate];
            }
        }
    }
}

- (BOOL)formFieldsAreValid
{
    for (HYPForm *form in self.formsManager.forms) {
        for (HYPFormField *field in form.fields) {
            if (![field validate]) {
                return NO;
            }
        }
    }

    return YES;
}

- (void)resetForms
{
    self.formsManager = nil;
    [self.collapsedForms removeAllObjects];
    [self.formsManager.hiddenFields removeAllObjects];
    [self.formsManager.hiddenSections removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - HYPBaseFormFieldCellDelegate

- (void)fieldCell:(UICollectionViewCell *)fieldCell updatedWithField:(HYPFormField *)field
{
    if (self.configureFieldUpdatedBlock) {
        self.configureFieldUpdatedBlock(fieldCell, field);
    }

    if (!field.fieldValue) {
        [self.formsManager.values removeObjectForKey:field.fieldID];
    } else if ([field.fieldValue isKindOfClass:[HYPFieldValue class]]) {
        HYPFieldValue *fieldValue = field.fieldValue;
        self.formsManager.values[field.fieldID] = fieldValue.valueID;
    } else {
        self.formsManager.values[field.fieldID] = field.fieldValue;
    }

    if (field.fieldValue && [field.fieldValue isKindOfClass:[HYPFieldValue class]]) {
        HYPFieldValue *fieldValue = field.fieldValue;
        [self processTargets:fieldValue.targets];
    } else if (field.targets.count > 0) {
        [self processTargets:field.targets];
    }
}

#pragma mark - Targets Procesing

- (void)processTarget:(HYPFormTarget *)target
{
    switch (target.actionType) {
        case HYPFormTargetActionShow: [self showTargets:@[target]]; break;
        case HYPFormTargetActionHide: [self hideTargets:@[target]]; break;
        case HYPFormTargetActionUpdate: [self updateTargets:@[target]]; break;
        case HYPFormTargetActionNone: break;
    }
}

- (void)processTargets:(NSArray *)targets
{
    [HYPFormTarget filteredTargets:targets
                          filtered:^(NSArray *shownTargets,
                                     NSArray *hiddenTargets,
                                     NSArray *updatedTargets) {
                              if (shownTargets.count > 0) [self showTargets:shownTargets];
                              if (hiddenTargets.count > 0) [self hideTargets:hiddenTargets];
                              if (updatedTargets.count > 0) [self updateTargets:updatedTargets];
                          }];
}

- (void)showTargets:(NSArray *)targets
{
    NSMutableArray *insertedIndexPaths = [NSMutableArray array];

    for (HYPFormTarget *target in targets) {
        if (target.type == HYPFormTargetTypeField) {
            HYPFormField *field = [self.formsManager.hiddenFields objectForKey:target.targetID];
            if (field) {
                HYPForm *form = self.formsManager.forms[[field.section.form.position integerValue]];
                HYPFormSection *section = form.sections[[field.section.position integerValue]];
                NSInteger fieldIndex = [field indexInForms:self.formsManager.forms];
                [section.fields insertObject:field atIndex:fieldIndex];

                HYPFormField *newField = [HYPFormField fieldWithID:target.targetID inForms:self.formsManager.forms withIndexPath:YES];
                [insertedIndexPaths addObject:newField.indexPath];

                [self.formsManager.hiddenFields removeObjectForKey:target.targetID];
            }
        } else if (target.type == HYPFormTargetTypeSection) {
            HYPFormSection *section = [self.formsManager.hiddenSections objectForKey:target.targetID];
            if (section) {
                NSInteger sectionIndex = [section indexInForms:self.formsManager.forms];
                HYPForm *form = self.formsManager.forms[[section.form.position integerValue]];
                [form.sections insertObject:section atIndex:sectionIndex];

                HYPFormSection *foundSection = [self findSectionForTarget:target];
                [insertedIndexPaths addObjectsFromArray:foundSection.indexPaths];

                [self.formsManager.hiddenSections removeObjectForKey:section.sectionID];
            }
        }
    }

    [self insertItemsAtIndexPaths:insertedIndexPaths];
}

- (void)hideTargets:(NSArray *)targets
{
    NSMutableArray *deletedFields = [NSMutableArray array];
    NSMutableArray *deletedSections = [NSMutableArray array];

    for (HYPFormTarget *target in targets) {
        if (target.type == HYPFormTargetTypeField) {
            HYPFormField *field = [HYPFormField fieldWithID:target.targetID inForms:self.formsManager.forms withIndexPath:YES];
            if (field && ![self.formsManager.hiddenFields objectForKey:field.fieldID]) {
                [deletedFields addObject:field];
                [self.formsManager.hiddenFields addEntriesFromDictionary:@{field.fieldID : field}];
            }
        } else if (target.type == HYPFormTargetTypeSection) {
            HYPFormSection *section = [self findSectionForTarget:target];
            if (section && ![self.formsManager.hiddenSections objectForKey:section.sectionID]) {
                [deletedSections addObject:section];
                [self.formsManager.hiddenSections addEntriesFromDictionary:@{section.sectionID : section}];
            }
        }
    }

    NSMutableSet *deletedIndexPaths = [NSMutableSet set];

    for (HYPFormField *field in deletedFields) {
        [deletedIndexPaths addObject:field.indexPath];
        [field sectionAndIndexInForms:self.formsManager.forms completion:^(BOOL found, HYPFormSection *section, NSInteger index) {
            if (found) {
                [section.fields removeObjectAtIndex:index];
            }
        }];
    }

    for (HYPFormSection *section in deletedSections) {
        [deletedIndexPaths addObjectsFromArray:section.indexPaths];
        HYPForm *form = self.formsManager.forms[[section.form.position integerValue]];
        [self indexForSection:section completion:^(BOOL found, NSInteger index) {
            if (found) {
                [form.sections removeObjectAtIndex:index];
            }
        }];
    }

    [self deleteItemsAtIndexPaths:[deletedIndexPaths allObjects]];
}

- (void)updateTargets:(NSArray *)targets
{
    NSMutableArray *updatedIndexPaths = [NSMutableArray array];

    for (HYPFormTarget *target in targets) {
        if (target.type == HYPFormTargetTypeSection) continue;
        if ([self.formsManager.hiddenFields objectForKey:target.targetID]) continue;

        HYPFormField *field = [HYPFormField fieldWithID:target.targetID inForms:self.formsManager.forms withIndexPath:YES];
        if (!field) continue;

        [updatedIndexPaths addObject:field.indexPath];

        NSArray *fieldIDs = [field.formula hyp_variables];
        NSMutableDictionary *values = [NSMutableDictionary dictionary];

        for (NSString *fieldID in fieldIDs) {

            id value = [self.formsManager.values objectForKey:fieldID];

            HYPFormField *targetField = [HYPFormField fieldWithID:fieldID inForms:self.formsManager.forms withIndexPath:NO];

            if (targetField.type == HYPFormFieldTypeSelect) {

                if ([targetField.fieldValue isKindOfClass:[HYPFieldValue class]]) {

                    HYPFieldValue *fieldValue = targetField.fieldValue;

                    if (fieldValue.value) {
                        [values addEntriesFromDictionary:@{fieldID : fieldValue.value}];
                    }
                } else {
                    HYPFieldValue *foundFieldValue = nil;
                    for (HYPFieldValue *fieldValue in field.values) {
                        if ([fieldValue identifierIsEqualTo:field.fieldValue]) {
                            foundFieldValue = fieldValue;
                        }
                    }
                    if (foundFieldValue && foundFieldValue.value) {
                        [values addEntriesFromDictionary:@{fieldID : foundFieldValue.value}];
                    }
                }

            } else if (value) {

                if (value && [value isKindOfClass:[NSString class]]) {
                    if (field.type == HYPFormFieldTypeFloat || field.type == HYPFormFieldTypeNumber) {
                        NSString *stringValue = value;
                        if (stringValue.length == 0) {
                            stringValue = @"0";
                        }
                        [values addEntriesFromDictionary:@{fieldID : stringValue}];
                    } else {
                        [values addEntriesFromDictionary:@{fieldID : @""}];
                    }
                } else {
                    if ([value respondsToSelector:NSSelectorFromString(@"stringValue")]) {
                        [self.formsManager.values setObject:[value stringValue] forKey:field.fieldID];
                        [values addEntriesFromDictionary:@{fieldID : [value stringValue]}];
                    } else {
                        [self.formsManager.values setObject:@"" forKey:field.fieldID];
                        if (field.type == HYPFormFieldTypeFloat || field.type == HYPFormFieldTypeNumber) {
                            [values addEntriesFromDictionary:@{fieldID : @"0"}];
                        } else {
                            [values addEntriesFromDictionary:@{fieldID : @""}];
                        }
                    }
                }
            } else {
                if (field.type == HYPFormFieldTypeFloat || field.type == HYPFormFieldTypeNumber) {
                    [values addEntriesFromDictionary:@{fieldID : @"0"}];
                } else {
                    [values addEntriesFromDictionary:@{fieldID : @""}];
                }
            }
        }

        id result = [field.formula hyp_runFormulaWithValuesDictionary:values];
        field.fieldValue = result;

        if (result) {
            [self.formsManager.values setObject:result forKey:field.fieldID];
        } else {
            [self.formsManager.values removeObjectForKey:field.fieldID];
        }
    }

    [self reloadItemsAtIndexPaths:updatedIndexPaths];
}

#pragma mark - Target helpers

#pragma mark Sections

- (HYPFormSection *)findSectionForTarget:(HYPFormTarget *)target
{
    __block BOOL found = NO;

    __block NSMutableArray *indexPaths = [NSMutableArray array];

    __block HYPFormSection *foundSection;

    [self.formsManager.forms enumerateObjectsUsingBlock:^(HYPForm *form, NSUInteger formIndex, BOOL *formStop) {
        if (found) {
            *formStop = YES;
        }

        __block NSInteger fieldsIndex = 0;
        [form.sections enumerateObjectsUsingBlock:^(HYPFormSection *aSection,
                                                    NSUInteger sectionIndex,
                                                    BOOL *sectionStop) {
            if ([aSection.sectionID isEqualToString:target.targetID]) {
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

- (void)indexForSection:(HYPFormSection *)section completion:(void (^)(BOOL found, NSInteger index))completion
{
    HYPForm *form = self.formsManager.forms[[section.form.position integerValue]];

    __block NSInteger index = 0;
    __block BOOL found = NO;
    [form.sections enumerateObjectsUsingBlock:^(HYPFormSection *aSection, NSUInteger idx, BOOL *stop) {
        if ([aSection.sectionID isEqualToString:section.sectionID]) {
            index = idx;
            found = YES;
            *stop = YES;
        }
    }];

    if (completion) {
        completion(found, index);
    }
}

- (void)insertedIndexPathsAndSectionIndexForSection:(HYPFormSection *)section
                                         completion:(void (^)(NSArray *indexPaths, NSInteger index))completion
{
    NSMutableArray *indexPaths = [NSMutableArray array];

    NSInteger formIndex = [section.form.position integerValue];
    HYPForm *form = self.formsManager.forms[formIndex];

    NSInteger fieldsIndex = 0;
    NSInteger sectionIndex = 0;
    for (HYPFormSection *aSection in form.sections) {
        if ([aSection.position integerValue] < [section.position integerValue]) {
            fieldsIndex += aSection.fields.count;
            sectionIndex++;
        }
    }

    NSInteger fieldsInSectionCount = fieldsIndex + section.fields.count;
    for (NSInteger i = fieldsIndex; i < fieldsInSectionCount; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:formIndex]];
    }

    if (completion) {
        completion(indexPaths, sectionIndex);
    }
}

#pragma mark - Keyboard Support

- (void)keyboardDidShow:(NSNotification *)notification
{
    CGRect keyboardEndFrame;
    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

    NSInteger height = CGRectGetHeight(keyboardEndFrame);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        if ([[UIDevice currentDevice] hyp_isLandscape]) {
            height = CGRectGetWidth(keyboardEndFrame);
        }
    }

    UIEdgeInsets inset = self.originalInset;
    inset.bottom += height;

    [UIView animateWithDuration:0.3f animations:^{
        self.collectionView.contentInset = inset;
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    CGRect keyboardEndFrame;
    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

    [UIView animateWithDuration:0.3f animations:^{
        self.collectionView.contentInset = self.originalInset;
    }];
}

#pragma mark - HYPFormHeaderViewDelegate

- (void)formHeaderViewWasPressed:(HYPFormHeaderView *)headerView
{
    [self collapseFieldsInSection:headerView.section collectionView:self.collectionView];
}

@end
