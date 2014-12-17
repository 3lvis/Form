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

    _collapsedForms = [NSMutableArray new];

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
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
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

    return nil;
}

#pragma mark - Public methods

- (void)collapseFieldsInSection:(NSInteger)section collectionView:(UICollectionView *)collectionView
{
    BOOL headerIsCollapsed = ([self.collapsedForms containsObject:@(section)]);

    NSMutableArray *indexPaths = [NSMutableArray new];
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

- (void)disable:(BOOL)disabled
{
    self.disabled = disabled;

    NSMutableDictionary *fields = [NSMutableDictionary new];

    for (HYPForm *form in self.formsManager.forms) {
        for (HYPFormField *field in form.fields) {
            if (field.fieldID) {
                [fields addEntriesFromDictionary:@{field.fieldID : field}];
            }
        }
    }

    [fields addEntriesFromDictionary:self.formsManager.hiddenFieldsAndFieldIDsDictionary];

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

    NSMutableArray *updatedIndexPaths = [NSMutableArray new];
    NSMutableArray *targets = [NSMutableArray new];

    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        [self.formsManager fieldWithID:key includingHiddenFields:YES completion:^(HYPFormField *field, NSIndexPath *indexPath) {
            BOOL shouldBeNil = ([value isEqual:[NSNull null]]);

            if (field) {
                field.fieldValue = (shouldBeNil) ? nil : value;
                if (indexPath) [updatedIndexPaths addObject:indexPath];
                [targets addObjectsFromArray:[field safeTargets]];
            } else {
                field = ([self fieldInDeletedFields:key]) ?: [self fieldInDeletedSections:key];
                if (field) field.fieldValue = (shouldBeNil) ? nil : value;
            }
        }];
    }];

    if (updatedIndexPaths.count > 0) {
        [self reloadItemsAtIndexPaths:updatedIndexPaths];
        [self.collectionView performBatchUpdates:^{
            [self processTargets:targets];
        } completion:nil];
    }
}

- (HYPFormField *)fieldInDeletedFields:(NSString *)fieldID
{
    __block HYPFormField *foundField = nil;

    [self.formsManager.hiddenFieldsAndFieldIDsDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, HYPFormField *field, BOOL *stop) {
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
    [self.formsManager.hiddenFieldsAndFieldIDsDictionary removeAllObjects];
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
        case HYPFormTargetActionShow: {
            NSArray *insertedIndexPaths = [self.formsManager showTargets:@[target]];
            [self insertItemsAtIndexPaths:insertedIndexPaths];
        } break;
        case HYPFormTargetActionHide: {
            NSArray *deletedIndexPaths = [self.formsManager hideTargets:@[target]];
            [self deleteItemsAtIndexPaths:deletedIndexPaths];
        } break;
        case HYPFormTargetActionUpdate: {
            NSArray *updatedIndexPaths = [self.formsManager updateTargets:@[target]];
            [self reloadItemsAtIndexPaths:updatedIndexPaths];
        } break;
        case HYPFormTargetActionNone: break;
    }
}

- (NSArray *)sortTargets:(NSArray *)targets
{
    NSSortDescriptor *sortByTypeString = [NSSortDescriptor sortDescriptorWithKey:@"typeString" ascending:YES];
    NSArray *sortedTargets = [targets sortedArrayUsingDescriptors:@[sortByTypeString]];

    return sortedTargets;
}

- (void)processTargets:(NSArray *)targets
{
    [HYPFormTarget filteredTargets:targets
                          filtered:^(NSArray *shownTargets,
                                     NSArray *hiddenTargets,
                                     NSArray *updatedTargets) {
                              shownTargets  = [self sortTargets:shownTargets];
                              hiddenTargets = [self sortTargets:hiddenTargets];

                              NSArray *insertedIndexPaths;
                              NSArray *deletedIndexPaths;
                              NSArray *updatedIndexPaths;

                              if (shownTargets.count > 0) {
                                  insertedIndexPaths = [self.formsManager showTargets:shownTargets];
                                  [self insertItemsAtIndexPaths:insertedIndexPaths];
                              }

                              if (hiddenTargets.count > 0) {
                                  deletedIndexPaths = [self.formsManager hideTargets:hiddenTargets];
                                  [self deleteItemsAtIndexPaths:deletedIndexPaths];
                              }

                              if (updatedTargets.count > 0) {
                                  updatedIndexPaths = [self.formsManager updateTargets:updatedTargets];

                                  if (deletedIndexPaths) {
                                      NSMutableArray *filteredIndexPaths = [updatedIndexPaths mutableCopy];
                                      for (NSIndexPath *indexPath in updatedIndexPaths) {
                                          if ([deletedIndexPaths containsObject:indexPath]) {
                                              [filteredIndexPaths removeObject:indexPath];
                                          }
                                      }

                                      [self reloadItemsAtIndexPaths:filteredIndexPaths];
                                  } else {
                                      [self reloadItemsAtIndexPaths:deletedIndexPaths];
                                  }

                              }
                          }];
}

#pragma mark - Target helpers

#pragma mark Sections

- (void)insertedIndexPathsAndSectionIndexForSection:(HYPFormSection *)section
                                         completion:(void (^)(NSArray *indexPaths, NSInteger index))completion
{
    NSMutableArray *indexPaths = [NSMutableArray new];

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
