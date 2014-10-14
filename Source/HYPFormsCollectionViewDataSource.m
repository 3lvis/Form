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

#import "UIColor+ANDYHex.h"
#import "UIScreen+HYPLiveBounds.h"
#import "NSString+ZENInflections.h"

@interface HYPFormsCollectionViewDataSource ()

@property (nonatomic, strong) NSMutableDictionary *resultsDictionary;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HYPFormsCollectionViewDataSource

#pragma mark - Initializers

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [self initWithCollectionView:collectionView andDictionary:nil];
    if (!self) return nil;

    return self;
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView andDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (!self) return nil;

    if (dictionary) {
        _resultsDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    }

    _collectionView = collectionView;
    collectionView.dataSource = self;

    [collectionView registerClass:[HYPBlankFormFieldCell class]
       forCellWithReuseIdentifier:HYPBlankFormFieldCellIdentifier];

    [collectionView registerClass:[HYPTextFormFieldCell class]
       forCellWithReuseIdentifier:HYPTextFormFieldCellIdentifier];

    [collectionView registerClass:[HYPDropdownFormFieldCell class]
       forCellWithReuseIdentifier:HYPDropdownFormFieldCellIdentifier];

    [collectionView registerClass:[HYPDateFormFieldCell class]
       forCellWithReuseIdentifier:HYPDateFormFieldCellIdentifier];

    [collectionView registerClass:[HYPFormHeaderView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:HYPFormHeaderReuseIdentifier];

    return self;
}

#pragma mark - Getters

- (NSMutableArray *)forms
{
    if (_forms) return _forms;

    if (self.resultsDictionary) {
        _forms = [HYPForm formsUsingInitialValuesFromDictionary:self.resultsDictionary];
    } else {
        _forms = [HYPForm forms];
    }

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
    }

    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                        forIndexPath:indexPath];

    if (self.configureCellBlock) {
        self.configureCellBlock(cell, indexPath, field);
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
        height = HYPFieldCellItemHeight;
    }

    return CGSizeMake(width, height);
}

- (void)validateForms
{
    NSArray *cells = [self.collectionView visibleCells];
    for (HYPBaseFormFieldCell *cell in cells) {
        [cell validate];
    }
}

- (BOOL)formFieldsAreValid
{
    for (HYPForm *form in self.forms) {
        for (HYPFormField *field in form.fields) {
            if (![field isValid]) {
                return NO;
            }
        }
    }

    return YES;
}

- (void)resetForms
{
    self.forms = nil;
    [self.collectionView reloadData];
}

- (void)processTargetsForFieldValue:(HYPFieldValue *)fieldValue
{
    [fieldValue filteredTargets:^(NSArray *shownTargets,
                                  NSArray *hiddenTargets,
                                  NSArray *enabledTargets,
                                  NSArray *disabledTargets,
                                  NSArray *updatedTargets) {
        [self showTargets:shownTargets];
        [self hideTargets:hiddenTargets];
        [self enableTargets:enabledTargets];
        [self disableTargets:disabledTargets];
        [self updateTargets:updatedTargets];
    }];
}

- (void)showTargets:(NSArray *)targets
{
    NSMutableArray *insertedIndexPaths = [NSMutableArray array];

    [targets enumerateObjectsUsingBlock:^(HYPFormTarget *target, NSUInteger idx, BOOL *stop) {
        NSString *key = [target.id zen_camelCase];
        HYPFormField *field = [self.deletedFields objectForKey:key];
        if (field) {
            [insertedIndexPaths addObject:[field.indexPath copy]];
            HYPForm *form = self.forms[[field.section.form.position integerValue]];
            HYPFormSection *section = form.sections[[field.section.position integerValue]];
            [section.fields insertObject:field atIndex:[field.position integerValue]];
            [self.deletedFields removeObjectForKey:key];
        }
    }];

    if (insertedIndexPaths.count > 0) {
        [self.collectionView insertItemsAtIndexPaths:insertedIndexPaths];
        [self.collectionView.collectionViewLayout invalidateLayout];
    }
}

- (void)hideTargets:(NSArray *)targets
{
    NSMutableArray *deletedFields = [NSMutableArray array];
    NSMutableArray *deletedSections = [NSMutableArray array];

    [targets enumerateObjectsUsingBlock:^(HYPFormTarget *target, NSUInteger idx, BOOL *stop) {
        if (target.type == HYPFormTargetTypeField) {
            [self findFieldForTarget:target completion:^(HYPFormField *field) {
                if (field && ![self.deletedFields objectForKey:field.id]) {
                    [deletedFields addObject:field];
                    [self.deletedFields addEntriesFromDictionary:@{field.id : field}];
                }
            }];
        } else if (target.type == HYPFormTargetTypeSection) {
            [self findSectionForTarget:target completion:^(HYPFormSection *section) {
                if (section && ![self.deletedSections objectForKey:section.id]) {
                    [deletedSections addObject:section];
                    [self.deletedSections addEntriesFromDictionary:@{section.id : section}];
                }
            }];
        }
    }];

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
        [self.collectionView.collectionViewLayout invalidateLayout];
    }
}

- (void)enableTargets:(NSArray *)targets
{
    // look for the fields
    // get their index paths
    // enable them
}

- (void)disableTargets:(NSArray *)targets
{
    // look for the fields
    // get their index paths
    // disable them
}

- (void)updateTargets:(NSArray *)targets
{
    // look for the fields
    // get their index paths
    // update them
}

#pragma mark - Target helpers

#pragma mark Fields

- (void)findFieldForTarget:(HYPFormTarget *)target completion:(void (^)(HYPFormField *field))completion
{
    __block BOOL found = NO;

    [self.forms enumerateObjectsUsingBlock:^(HYPForm *form, NSUInteger formIndex, BOOL *formStop) {
        [form.fields enumerateObjectsUsingBlock:^(HYPFormField *field, NSUInteger fieldIndex, BOOL *fieldStop) {
            if ([[field.id zen_rubyCase] isEqualToString:target.id]) {
                field.indexPath = [NSIndexPath indexPathForRow:fieldIndex inSection:formIndex];

                if (completion) {
                    completion(field);
                }

                found = YES;
            }
        }];
    }];

    if (!found) {
        completion(nil);
    }
}

- (void)sectionAndIndexForField:(HYPFormField *)field completion:(void (^)(BOOL found, HYPFormSection *section, NSInteger index))completion
{
    HYPForm *form = self.forms[[field.section.form.position integerValue]];
    HYPFormSection *section = form.sections[[field.section.position integerValue]];

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
        [form.sections enumerateObjectsUsingBlock:^(HYPFormSection *aSection, NSUInteger sectionIndex, BOOL *sectionStop) {
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

@end
