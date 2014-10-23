//
//  HYPFormsCollectionViewDataSource.m

//
//  Created by Elvis Nunez on 10/6/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFormsCollectionViewDataSource.h"

#import "HYPFormBackgroundView.h"
#import "HYPFormsLayout.h"

#import "HYPTextFormFieldCell.h"
#import "HYPDropdownFormFieldCell.h"
#import "HYPDateFormFieldCell.h"
#import "HYPBlankFormFieldCell.h"
#import "HYPImageFormFieldCell.h"

#import "UIColor+ANDYHex.h"
#import "UIScreen+HYPLiveBounds.h"
#import "NSString+HYPWordExtractor.h"
#import "NSString+HYPFormula.h"
#import "UIDevice+HYPRealOrientation.h"

@interface HYPFormsCollectionViewDataSource () <HYPBaseFormFieldCellDelegate, HYPFormHeaderViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *valuesDictionary;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic) UIEdgeInsets originalInset;
@property (nonatomic) BOOL readOnly;
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
                         andDictionary:(NSDictionary *)dictionary
                              readOnly:(BOOL)readOnly
{
    self = [super init];
    if (!self) return nil;

    _readOnly = readOnly;

    [self.valuesDictionary addEntriesFromDictionary:dictionary];

    _collectionView = collectionView;

    collectionView.dataSource = self;

    _originalInset = collectionView.contentInset;

    [collectionView registerClass:[HYPBlankFormFieldCell class]
       forCellWithReuseIdentifier:HYPBlankFormFieldCellIdentifier];

    [collectionView registerClass:[HYPTextFormFieldCell class]
       forCellWithReuseIdentifier:HYPTextFormFieldCellIdentifier];

    [collectionView registerClass:[HYPDropdownFormFieldCell class]
       forCellWithReuseIdentifier:HYPDropdownFormFieldCellIdentifier];

    [collectionView registerClass:[HYPDateFormFieldCell class]
       forCellWithReuseIdentifier:HYPDateFormFieldCellIdentifier];

    [collectionView registerClass:[HYPImageFormFieldCell class]
       forCellWithReuseIdentifier:HYPImageFormFieldCellIdentifier];

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

- (NSMutableDictionary *)valuesDictionary
{
    if (_valuesDictionary) return _valuesDictionary;

    _valuesDictionary = [NSMutableDictionary dictionary];

    return _valuesDictionary;
}

- (NSMutableArray *)forms
{
    if (_forms) return _forms;

    _forms = [HYPForm formsUsingInitialValuesFromDictionary:self.valuesDictionary
                                                   readOnly:self.readOnly
                                           additionalValues:^(NSMutableDictionary *deletedFields,
                                                              NSMutableDictionary *deletedSections) {
                                               [self.deletedFields addEntriesFromDictionary:deletedFields];
                                               [self.deletedSections addEntriesFromDictionary:deletedSections];
                                           }];

    return _forms;
}

- (NSMutableArray *)collapsedForms
{
    if (_collapsedForms) return _collapsedForms;

    _collapsedForms = [NSMutableArray array];

    return _collapsedForms;
}

- (NSMutableDictionary *)deletedFields
{
    if (_deletedFields) return _deletedFields;

    _deletedFields = [NSMutableDictionary dictionary];

    return _deletedFields;
}

- (NSMutableDictionary *)deletedSections
{
    if (_deletedSections) return _deletedSections;

    _deletedSections = [NSMutableDictionary dictionary];

    return _deletedSections;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.forms.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    HYPForm *form = self.forms[section];
    if ([self.collapsedForms containsObject:@(section)]) {
        return 0;
    }

    return [form numberOfFields:self.deletedSections];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYPForm *form = self.forms[indexPath.section];
    NSArray *fields = form.fields;
    HYPFormField *field = fields[indexPath.row];

    NSString *identifier;

    switch (field.type) {
        case HYPFormFieldTypeDate:
            identifier = HYPDateFormFieldCellIdentifier;
            break;
        case HYPFormFieldTypeSelect:
            identifier = HYPDropdownFormFieldCellIdentifier;
            break;

        case HYPFormFieldTypeDefault:
        case HYPFormFieldTypeFloat:
        case HYPFormFieldTypeNumber:
        case HYPFormFieldTypePicture:
            identifier = HYPTextFormFieldCellIdentifier;
            break;

        case HYPFormFieldTypeNone:
        case HYPFormFieldTypeBlank:
            identifier = HYPBlankFormFieldCellIdentifier;
            break;

        case HYPFormFieldTypeImage:
            identifier = HYPImageFormFieldCellIdentifier;
            break;
    }

    HYPBaseFormFieldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                           forIndexPath:indexPath];
    if (field.type == HYPFormFieldTypeImage) return cell;

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

        HYPForm *form = self.forms[indexPath.section];
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
    HYPForm *form = self.forms[section];

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

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYPForm *form = self.forms[indexPath.section];

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
        width = floor(deviceWidth * ([field.size floatValue] / 100.0f));

        if (field.type == HYPFormFieldTypeImage) {
            height = HYPImageFormFieldCellItemHeight;
        } else {
            height = HYPFieldCellItemHeight;
        }
    }

    return CGSizeMake(width, height);
}

- (HYPFormField *)formFieldAtIndexPath:(NSIndexPath *)indexPath
{
    HYPForm *form = self.forms[indexPath.section];
    NSArray *fields = form.fields;
    HYPFormField *field = fields[indexPath.row];
    return field;
}

- (void)disable:(BOOL)disabled
{
    self.readOnly = disabled;

    [self resetForms];
}

- (void)reloadWithDictionary:(NSDictionary *)dictionary
{
    [self.valuesDictionary setValuesForKeysWithDictionary:dictionary];

    NSMutableArray *updatedIndexPaths = [NSMutableArray array];
    NSMutableArray *targets = [NSMutableArray array];

    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        HYPFormField *field = [HYPFormField fieldWithID:key inForms:self.forms withIndexPath:YES];
        if (field) {
            field.fieldValue = value;
            [updatedIndexPaths addObject:field.indexPath];
            [targets addObjectsFromArray:[field safeTargets]];
        } else {
            field = ([self fieldInDeletedFields:key]) ?: [self fieldInDeletedSections:key];
            if (field) field.fieldValue = value;
        }
    }];

    if (updatedIndexPaths.count > 0) {
        [self.collectionView reloadItemsAtIndexPaths:updatedIndexPaths];
    }

    [self processTargets:targets];
}

- (HYPFormField *)fieldInDeletedFields:(NSString *)fieldID
{
    __block HYPFormField *foundField = nil;

    [self.deletedFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, HYPFormField *field, BOOL *stop) {
        if ([field.id isEqualToString:fieldID]) {
            foundField = field;
            *stop = YES;
        }
    }];

    return foundField;
}

- (HYPFormField *)fieldInDeletedSections:(NSString *)fieldID
{
    __block HYPFormField *foundField = nil;

    [self.deletedSections enumerateKeysAndObjectsUsingBlock:^(NSString *key, HYPFormSection *section, BOOL *stop) {
        [section.fields enumerateObjectsUsingBlock:^(HYPFormField *field, NSUInteger idx, BOOL *stop) {
            if ([field.id isEqualToString:fieldID]) {
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

            if (cell.field.id) {
                [validatedFields addObject:cell.field.id];
            }
        }
    }

    for (HYPForm *form in self.forms) {
        for (HYPFormField *field in form.fields) {
            if (![validatedFields containsObject:field.id]) {
                [field validate];
            }
        }
    }
}

- (BOOL)formFieldsAreValid
{
    for (HYPForm *form in self.forms) {
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
    self.forms = nil;
    [self.collapsedForms removeAllObjects];
    [self.deletedFields removeAllObjects];
    [self.deletedSections removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - HYPBaseFormFieldCellDelegate

- (void)fieldCell:(UICollectionViewCell *)fieldCell updatedWithField:(HYPFormField *)field
{
    if (self.configureFieldUpdatedBlock) {
        self.configureFieldUpdatedBlock(fieldCell, field);
    }

    if (!field.fieldValue) {
        [self.valuesDictionary removeObjectForKey:field.id];
    } else if ([field.fieldValue isKindOfClass:[HYPFieldValue class]]) {
        HYPFieldValue *fieldValue = field.fieldValue;
        self.valuesDictionary[field.id] = fieldValue.id;
    } else {
        self.valuesDictionary[field.id] = field.fieldValue;
    }

    if (field.fieldValue && [field.fieldValue isKindOfClass:[HYPFieldValue class]]) {
        HYPFieldValue *fieldValue = field.fieldValue;
        [self processTargets:fieldValue.targets];
    } else if (field.targets.count > 0) {
        [self processTargets:field.targets];
    }
}

#pragma mark - Targets Procesing

- (void)processTargets:(NSArray *)targets
{
    [HYPFormTarget filteredTargets:targets
                          filtered:^(NSArray *shownTargets,
                                     NSArray *hiddenTargets,
                                     NSArray *updatedTargets) {
                              [self showTargets:shownTargets];
                              [self hideTargets:hiddenTargets];
                              [self updateTargets:updatedTargets];

                              [self.collectionView.collectionViewLayout invalidateLayout];
                          }];
}

- (void)showTargets:(NSArray *)targets
{
    NSMutableArray *insertedIndexPaths = [NSMutableArray array];

    for (HYPFormTarget *target in targets) {
        if (target.type == HYPFormTargetTypeField) {
            HYPFormField *field = [self.deletedFields objectForKey:target.id];
            if (field) {
                [insertedIndexPaths addObject:field.indexPath];
                HYPForm *form = self.forms[[field.section.form.position integerValue]];
                HYPFormSection *section = form.sections[[field.section.position integerValue]];
                NSInteger fieldIndex = [field indexInForms:self.forms];
                [section.fields insertObject:field atIndex:fieldIndex];
                [self.deletedFields removeObjectForKey:target.id];
            }
        } else if (target.type == HYPFormTargetTypeSection) {
            HYPFormSection *section = [self.deletedSections objectForKey:target.id];
            if (section) {
                [insertedIndexPaths addObjectsFromArray:section.indexPaths];
                NSInteger sectionIndex = [section indexInForms:self.forms];
                HYPForm *form = self.forms[[section.form.position integerValue]];
                [form.sections insertObject:section atIndex:sectionIndex];
                [self.deletedSections removeObjectForKey:section.id];
            }
        }
    }

    if (insertedIndexPaths.count > 0) {
        [self.collectionView insertItemsAtIndexPaths:insertedIndexPaths];
    }
}

- (void)hideTargets:(NSArray *)targets
{
    NSMutableArray *deletedFields = [NSMutableArray array];
    NSMutableArray *deletedSections = [NSMutableArray array];

    for (HYPFormTarget *target in targets) {
        if (target.type == HYPFormTargetTypeField) {
            HYPFormField *field = [self fieldForTarget:target];
            if (field && ![self.deletedFields objectForKey:field.id]) {
                [deletedFields addObject:field];
                [self.deletedFields addEntriesFromDictionary:@{field.id : field}];
            }
        } else if (target.type == HYPFormTargetTypeSection) {
            [self findSectionForTarget:target completion:^(HYPFormSection *section) {
                if (section && ![self.deletedSections objectForKey:section.id]) {
                    [deletedSections addObject:section];
                    [self.deletedSections addEntriesFromDictionary:@{section.id : section}];
                }
            }];
        }
    }

    NSMutableSet *deletedIndexPaths = [NSMutableSet set];

    for (HYPFormField *field in deletedFields) {
        [deletedIndexPaths addObject:field.indexPath];
        [self sectionAndIndexForField:field completion:^(BOOL found, HYPFormSection *section, NSInteger index) {
            if (found) {
                [section.fields removeObjectAtIndex:index];
            }
        }];
    }

    for (HYPFormSection *section in deletedSections) {
        [deletedIndexPaths addObjectsFromArray:section.indexPaths];
        HYPForm *form = self.forms[[section.form.position integerValue]];
        [self indexForSection:section completion:^(BOOL found, NSInteger index) {
            if (found) {
                [form.sections removeObjectAtIndex:index];
            }
        }];
    }

    if (deletedIndexPaths.count > 0) {
        [self.collectionView deleteItemsAtIndexPaths:[deletedIndexPaths allObjects]];
    }
}

- (void)updateTargets:(NSArray *)targets
{
    NSMutableArray *updatedIndexPaths = [NSMutableArray array];

    for (HYPFormTarget *target in targets) {
        if (target.type == HYPFormTargetTypeSection) return;
        if ([self.deletedFields objectForKey:target.id]) return;

        HYPFormField *field = [self fieldForTarget:target];
        if (!field) return;

        [updatedIndexPaths addObject:field.indexPath];

        NSArray *fieldIDs = [field.formula hyp_variables];
        NSMutableDictionary *values = [NSMutableDictionary dictionary];

        for (NSString *fieldID in fieldIDs) {
            HYPFormField *field = [self fieldForTarget:target];

            id value = [self.valuesDictionary objectForKey:fieldID];
            if (value) {
                HYPFormField *targetField = [HYPFormField fieldWithID:fieldID inForms:self.forms withIndexPath:NO];

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

                } else {
                    if ([value isKindOfClass:[NSString class]] && [value length] > 0) {
                        [values addEntriesFromDictionary:@{fieldID : value}];
                    } else {
                        if ([value respondsToSelector:NSSelectorFromString(@"stringValue")]) {
                            [self.valuesDictionary setObject:[value stringValue] forKey:field.id];
                            [values addEntriesFromDictionary:@{fieldID : [value stringValue]}];
                        } else {
                            [self.valuesDictionary setObject:@"" forKey:field.id];
                            [values addEntriesFromDictionary:@{fieldID : @""}];
                        }
                    }
                }
            }
        }

        id result = [field.formula hyp_runFormulaWithDictionary:values];
        field.fieldValue = result;

        if (result) {
            [self.valuesDictionary setObject:result forKey:field.id];
        } else {
            [self.valuesDictionary removeObjectForKey:field.id];
        }
    }

    [self.collectionView reloadItemsAtIndexPaths:updatedIndexPaths];
}

#pragma mark - Target helpers

#pragma mark Fields

- (HYPFormField *)fieldForTarget:(HYPFormTarget *)target
{
    __block BOOL found = NO;
    __block HYPFormField *foundField = nil;

    [self.forms enumerateObjectsUsingBlock:^(HYPForm *form, NSUInteger formIndex, BOOL *formStop) {
        if (found) {
            *formStop = YES;
        }

        [form.fields enumerateObjectsUsingBlock:^(HYPFormField *field, NSUInteger fieldIndex, BOOL *fieldStop) {
            if ([field.id isEqualToString:target.id]) {
                field.indexPath = [NSIndexPath indexPathForRow:fieldIndex inSection:formIndex];
                foundField = field;

                found = YES;
                *fieldStop = YES;
            }
        }];
    }];

    return foundField;
}

- (void)sectionAndIndexForField:(HYPFormField *)field
                     completion:(void (^)(BOOL found, HYPFormSection *section, NSInteger index))completion
{
    HYPFormSection *section = [HYPFormSection sectionWithID:field.section.id inForms:self.forms];

    __block NSInteger index = 0;
    __block BOOL found = NO;
    [section.fields enumerateObjectsUsingBlock:^(HYPFormField *aField, NSUInteger idx, BOOL *stop) {
        if ([aField.id isEqualToString:field.id]) {
            index = idx;
            found = YES;
            *stop = YES;
        }
    }];

    if (completion) {
        completion(found, section, index);
    }
}

#pragma mark Sections

- (void)findSectionForTarget:(HYPFormTarget *)target completion:(void (^)(HYPFormSection *section))completion
{
    __block BOOL found = NO;

    __block NSMutableArray *indexPaths = [NSMutableArray array];

    [self.forms enumerateObjectsUsingBlock:^(HYPForm *form, NSUInteger formIndex, BOOL *formStop) {
        if (found) {
            *formStop = YES;
        }

        __block NSInteger fieldsIndex = 0;
        [form.sections enumerateObjectsUsingBlock:^(HYPFormSection *aSection,
                                                    NSUInteger sectionIndex,
                                                    BOOL *sectionStop) {
            if ([aSection.id isEqualToString:target.id]) {
                NSInteger fieldsInSectionCount = fieldsIndex + aSection.fields.count;
                for (NSInteger i = fieldsIndex; i < fieldsInSectionCount; i++) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:formIndex]];
                }
                aSection.indexPaths = indexPaths;

                if (completion) {
                    completion(aSection);
                }

                found = YES;
                *sectionStop = YES;
            }

            fieldsIndex += aSection.fields.count;
        }];
    }];

    if (!found) {
        completion(nil);
    }
}

- (void)indexForSection:(HYPFormSection *)section completion:(void (^)(BOOL found, NSInteger index))completion
{
    HYPForm *form = self.forms[[section.form.position integerValue]];

    __block NSInteger index = 0;
    __block BOOL found = NO;
    [form.sections enumerateObjectsUsingBlock:^(HYPFormSection *aSection, NSUInteger idx, BOOL *stop) {
        if ([aSection.id isEqualToString:section.id]) {
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
    HYPForm *form = self.forms[formIndex];

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
