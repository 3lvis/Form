#import "FORMDataSource.h"

#import "FORMBackgroundView.h"
#import "FORMLayout.h"

#import "FORMTextFieldCell.h"
#import "FORMSelectFieldCell.h"
#import "FORMDateFieldCell.h"
#import "FORMButtonFieldCell.h"
#import "FORMFieldValue.h"
#import "HYPParsedRelationship.h"

#import "UIColor+Hex.h"
#import "UIScreen+HYPLiveBounds.h"
#import "NSString+HYPWordExtractor.h"
#import "NSString+HYPFormula.h"
#import "UIDevice+HYPRealOrientation.h"
#import "NSObject+HYPTesting.h"
#import "NSString+HYPRelationshipParser.h"
#import "NSString+HYPContainsString.h"
#import "NSDictionary+ANDYSafeValue.h"

static const CGFloat FORMDispatchTime = 0.05f;

static NSString * const FORMDynamicAddFieldID = @"add";
static NSString * const FORMDynamicRemoveFieldID = @"remove";

@interface FORMDataSource () <FORMBaseFieldCellDelegate, FORMHeaderViewDelegate>

@property (nonatomic) UIEdgeInsets originalInset;
@property (nonatomic) BOOL disabled;
@property (nonatomic) FORMData *formsManager;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) FORMLayout *layout;
@property (nonatomic, copy) NSArray *JSON;
@property (nonatomic) NSMutableArray *collapsedForms;

@end

@implementation FORMDataSource

#pragma mark - Dealloc

- (void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - Initializers

- (instancetype)initWithJSON:(id)JSON
              collectionView:(UICollectionView *)collectionView
                      layout:(FORMLayout *)layout
                      values:(NSDictionary *)values
                    disabled:(BOOL)disabled
{
    self = [super init];
    if (!self) return nil;

    _collectionView = collectionView;

    _layout = layout;

    _originalInset = collectionView.contentInset;

    layout.dataSource = self;

    _formsManager = [[FORMData alloc] initWithJSON:JSON
                                     initialValues:values
                                  disabledFieldIDs:@[]
                                          disabled:disabled];

    [collectionView registerClass:[FORMTextFieldCell class]
       forCellWithReuseIdentifier:FORMTextFieldCellIdentifier];

    [collectionView registerClass:[FORMSelectFieldCell class]
       forCellWithReuseIdentifier:FORMSelectFormFieldCellIdentifier];

    [collectionView registerClass:[FORMDateFieldCell class]
       forCellWithReuseIdentifier:FORMDateFormFieldCellIdentifier];

    [collectionView registerClass:[FORMButtonFieldCell class]
       forCellWithReuseIdentifier:FORMButtonFieldCellIdentifier];

    [collectionView registerClass:[FORMGroupHeaderView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:FORMHeaderReuseIdentifier];

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
    FORMGroup *form = self.formsManager.forms[section];
    if ([self.collapsedForms containsObject:@(section)]) {
        return 0;
    }

    return [form numberOfFields:self.formsManager.hiddenSections];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FORMGroup *form = self.formsManager.forms[indexPath.section];
    NSArray *fields = form.fields;
    FORMField *field = fields[indexPath.row];

    if (self.configureCellForIndexPath) {
        id configuredCell = self.configureCellForIndexPath(field, collectionView, indexPath);
        if (configuredCell) return configuredCell;
    }

    NSString *identifier;

    switch (field.type) {
        case FORMFieldTypeDate:
            identifier = FORMDateFormFieldCellIdentifier;
            break;
        case FORMFieldTypeSelect:
            identifier = FORMSelectFormFieldCellIdentifier;
            break;

        case FORMFieldTypeText:
        case FORMFieldTypeFloat:
        case FORMFieldTypeNumber:
            identifier = FORMTextFieldCellIdentifier;
            break;

        case FORMFieldTypeButton:
            identifier = FORMButtonFieldCellIdentifier;
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
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        FORMGroupHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                             withReuseIdentifier:FORMHeaderReuseIdentifier
                                                                                    forIndexPath:indexPath];

        FORMGroup *form = self.formsManager.forms[indexPath.section];
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
    FORMGroup *form = self.formsManager.forms[section];

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
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:reloadedIndexPaths];
        } completion:^(BOOL finished) {
            if (finished) [self.collectionView reloadData];
        }];
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
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadItemsAtIndexPaths:reloadedIndexPaths];
        }];
    }
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FORMGroup *form = self.formsManager.forms[indexPath.section];

    NSArray *fields = form.fields;

    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
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

- (FORMField *)formFieldAtIndexPath:(NSIndexPath *)indexPath
{
    FORMGroup *form = self.formsManager.forms[indexPath.section];
    NSArray *fields = form.fields;
    FORMField *field = fields[indexPath.row];

    return field;
}

- (void)enable
{
    [self disable:NO];
}

- (void)disable
{
    [self disable:YES];
}

- (void)disable:(BOOL)disabled
{
    self.disabled = disabled;

    if (disabled) {
        [self.formsManager disable];
    } else {
        [self.formsManager enable];
    }

    NSMutableDictionary *fields = [NSMutableDictionary new];

    for (FORMGroup *form in self.formsManager.forms) {
        for (FORMField *field in form.fields) {
            if (field.fieldID) [fields addEntriesFromDictionary:@{field.fieldID : field}];
        }
    }

    [fields addEntriesFromDictionary:self.formsManager.hiddenFieldsAndFieldIDsDictionary];

    for (FORMSection *section in [self.formsManager.hiddenSections allValues]) {
        for (FORMField *field in section.fields) {
            if (field.fieldID) [fields addEntriesFromDictionary:@{field.fieldID : field}];
        }
    }

    for (NSString *fieldID in fields) {
        FORMField *field = [fields valueForKey:fieldID];
        BOOL shouldChangeState = (![self.formsManager.disabledFieldsIDs containsObject:fieldID]);

        if (disabled) {
            field.disabled = YES;
        } else if (shouldChangeState) {
            if (!field.initiallyDisabled) field.disabled = NO;

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
                        if (targetIsNotEnableOrDisable) [targets addObject:target];
                    }

                    if (targets.count > 0) [self processTargets:targets];
                }
            }
        }
    }

    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
    }];
}

- (BOOL)isDisabled
{
    return self.disabled;
}

- (BOOL)isEnabled
{
    return !self.disabled;
}

- (void)reloadWithDictionary:(NSDictionary *)dictionary
{
    [self.formsManager.values setValuesForKeysWithDictionary:dictionary];

    NSMutableArray *updatedIndexPaths = [NSMutableArray new];
    NSMutableArray *targets = [NSMutableArray new];

    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        [self.formsManager fieldWithID:key includingHiddenFields:YES completion:^(FORMField *field, NSIndexPath *indexPath) {
            BOOL shouldBeNil = ([value isEqual:[NSNull null]]);

            if (field) {
                field.value = (shouldBeNil) ? nil : value;
                if (indexPath) [updatedIndexPaths addObject:indexPath];
                [targets addObjectsFromArray:[field safeTargets]];
            } else {
                field = ([self fieldInDeletedFields:key]) ?: [self fieldInDeletedSections:key];
                if (field) field.value = (shouldBeNil) ? nil : value;
            }
        }];
    }];

    [self processTargets:targets];
}

- (FORMField *)fieldInDeletedFields:(NSString *)fieldID
{
    __block FORMField *foundField = nil;

    [self.formsManager.hiddenFieldsAndFieldIDsDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, FORMField *field, BOOL *stop) {
        if ([field.fieldID isEqualToString:fieldID]) {
            foundField = field;
            *stop = YES;
        }
    }];

    return foundField;
}

- (FORMField *)fieldInDeletedSections:(NSString *)fieldID
{
    __block FORMField *foundField = nil;

    [self.formsManager.hiddenSections enumerateKeysAndObjectsUsingBlock:^(NSString *key, FORMSection *section, BOOL *stop) {
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

- (void)validateForms
{
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

    for (FORMGroup *form in self.formsManager.forms) {
        for (FORMField *field in form.fields) {
            if (![validatedFields containsObject:field.fieldID]) {
                [field validate];
            }
        }
    }
}

- (BOOL)formFieldsAreValid
{
    for (FORMGroup *form in self.formsManager.forms) {
        for (FORMField *field in form.fields) {
            FORMValidationResultType fieldValidation = [field validate];
            BOOL requiredFieldFailedValidation = (fieldValidation != FORMValidationResultTypePassed);
            if (requiredFieldFailedValidation) {
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

#pragma mark - FORMBaseFieldCellDelegate

- (void)fieldCell:(UICollectionViewCell *)fieldCell updatedWithField:(FORMField *)field
{
    if (self.configureFieldUpdatedBlock) {
        self.configureFieldUpdatedBlock(fieldCell, field);
    }

    NSArray *components = [field.fieldID componentsSeparatedByString:@"."];
    if (components.count == 2) {
        if ([components.lastObject isEqualToString:FORMDynamicAddFieldID]) {
            NSString *sectionTemplateID = [components firstObject];
            FORMSection *section = [self sectionWithID:sectionTemplateID];
            [self.formsManager insertTemplateSectionWithID:sectionTemplateID intoCollectionView:self.collectionView usingForm:section.form];
        } else if ([components.lastObject isEqualToString:FORMDynamicRemoveFieldID]) {
            HYPParsedRelationship *parsed = [field.fieldID hyp_parseRelationship];
            parsed.attribute = nil;
            NSString *sectionID = [parsed key];
            [self.formsManager sectionWithID:sectionID completion:^(FORMSection *section, NSArray *indexPaths) {
                [self updateSectionPosition:section];

                NSMutableArray *removedKeys = [NSMutableArray new];
                __block HYPParsedRelationship *foundParsed;
                [self.values enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
                    if ([key hasPrefix:section.sectionID]) {
                        foundParsed = [key hyp_parseRelationship];
                        [removedKeys addObject:[foundParsed key]];
                    }
                }];

                foundParsed = [section.sectionID hyp_parseRelationship];
                foundParsed.attribute = nil;
                foundParsed.index = @(self.formsManager.removedValues.count);

                for (NSString *removedKey in removedKeys) {
                    [self.formsManager.removedValues setValue:self.values[removedKey] forKey:removedKey];
                    [self.formsManager.values removeObjectForKey:removedKey];
                }

                FORMGroup *group = section.form;
                [group.sections removeObject:section];

                if (indexPaths) {
                    [self.collectionView deleteItemsAtIndexPaths:indexPaths];
                }

                NSDictionary *updatedValueKeys = [self updateValueKeys:[self.values allKeys]];
                NSDictionary *currentValues = self.values;

                [self removeDynamicKeysForSection:section];

                [currentValues enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
                    if (updatedValueKeys[key]) {
                        self.formsManager.values[updatedValueKeys[key]] = obj;
                    }
                }];

            }];
        }
    }

    BOOL isValidField = !(components.count == 2 &&
                          [components.lastObject isEqualToString:FORMDynamicRemoveFieldID]);
    if (isValidField) {
        if (!field.value) {
            [self.formsManager.values removeObjectForKey:field.fieldID];
        } else if ([field.value isKindOfClass:[FORMFieldValue class]]) {
            FORMFieldValue *fieldValue = field.value;
            self.formsManager.values[field.fieldID] = fieldValue.valueID;
        } else {
            self.formsManager.values[field.fieldID] = field.value;
        }

        if (field.value && [field.value isKindOfClass:[FORMFieldValue class]]) {
            FORMFieldValue *fieldValue = field.value;
            [self processTargets:fieldValue.targets];
        } else if (field.targets.count > 0) {
            [self processTargets:field.targets];
        }
    }
}

- (void)fieldCell:(UICollectionViewCell *)fieldCell processTargets:(NSArray *)targets
{
    NSTimeInterval delay = ([NSObject isUnitTesting]) ? FORMDispatchTime : 0.0f;
    [self performSelector:@selector(processTargets:) withObject:targets afterDelay:delay];
}

#pragma mark - Targets Procesing

- (void)processTarget:(FORMTarget *)target
{
    switch (target.actionType) {
        case FORMTargetActionShow: {
            NSArray *insertedIndexPaths = [self.formsManager showTargets:@[target]];
            [self insertItemsAtIndexPaths:insertedIndexPaths];
        } break;
        case FORMTargetActionHide: {
            NSArray *deletedIndexPaths = [self.formsManager hideTargets:@[target]];
            [self deleteItemsAtIndexPaths:deletedIndexPaths];
        } break;
        case FORMTargetActionClear:
        case FORMTargetActionUpdate: {
            NSArray *updatedIndexPaths = [self.formsManager updateTargets:@[target]];
            [self reloadItemsAtIndexPaths:updatedIndexPaths];
        } break;
        case FORMTargetActionEnable: {
            if ([self.formsManager isEnabled]) {
                NSArray *enabledIndexPaths = [self.formsManager enableTargets:@[target]];
                [self reloadItemsAtIndexPaths:enabledIndexPaths];
            }
        } break;
        case FORMTargetActionDisable: {
            NSArray *disabledIndexPaths = [self.formsManager disableTargets:@[target]];
            [self reloadItemsAtIndexPaths:disabledIndexPaths];
        } break;
        case FORMTargetActionNone: break;
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
                                   [self reloadItemsAtIndexPaths:updatedIndexPaths];
                               }
                           }

                           BOOL shouldRunEnableTargets = (enabledTargets.count > 0 && [self.formsManager isEnabled]);
                           if (shouldRunEnableTargets) {
                               enabledIndexPaths = [self.formsManager enableTargets:enabledTargets];

                               [self reloadItemsAtIndexPaths:enabledIndexPaths];
                           }

                           if (disabledTargets.count > 0) {
                               disabledIndexPaths = [self.formsManager disableTargets:disabledTargets];

                               [self reloadItemsAtIndexPaths:disabledIndexPaths];
                           }
                       }];
}

#pragma mark - Target helpers

#pragma mark Sections

- (void)insertedIndexPathsAndSectionIndexForSection:(FORMSection *)section
                                         completion:(void (^)(NSArray *indexPaths, NSInteger index))completion
{
    NSMutableArray *indexPaths = [NSMutableArray new];

    NSInteger formIndex = [section.form.position integerValue];
    FORMGroup *form = self.formsManager.forms[formIndex];

    NSInteger fieldsIndex = 0;
    NSInteger sectionIndex = 0;
    for (FORMSection *aSection in form.sections) {
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

#pragma mark - FORMHeaderViewDelegate

- (void)formHeaderViewWasPressed:(FORMGroupHeaderView *)headerView
{
    [self collapseFieldsInSection:headerView.section collectionView:self.collectionView];
}

#pragma mark - FORMLayoutDataSource

- (NSArray *)forms
{
    return self.formsManager.forms;
}

#pragma mark - FORMData bridge

- (NSArray *)invalidFormFields
{
    return [self.formsManager invalidFormFields];
}

- (NSDictionary *)requiredFormFields
{
    return [self.formsManager requiredFormFields];
}

- (NSMutableDictionary *)valuesForFormula:(FORMField *)field
{
    return [self.formsManager valuesForFormula:field];
}

- (FORMSection *)sectionWithID:(NSString *)sectionID
{
    return [self.formsManager sectionWithID:sectionID];
}

- (void)sectionWithID:(NSString *)sectionID
           completion:(void (^)(FORMSection *section, NSArray *indexPaths))completion
{
    [self.formsManager sectionWithID:sectionID completion:completion];
}

- (void)indexForFieldWithID:(NSString *)fieldID
            inSectionWithID:(NSString *)sectionID
                 completion:(void (^)(FORMSection *section, NSInteger index))completion
{
    [self.formsManager indexForFieldWithID:fieldID inSectionWithID:sectionID completion:completion];
}

- (FORMField *)fieldWithID:(NSString *)fieldID includingHiddenFields:(BOOL)includingHiddenFields
{
    return [self.formsManager fieldWithID:fieldID includingHiddenFields:includingHiddenFields];
}

- (void)fieldWithID:(NSString *)fieldID includingHiddenFields:(BOOL)includingHiddenFields
         completion:(void (^)(FORMField *field, NSIndexPath *indexPath))completion
{
    [self.formsManager fieldWithID:fieldID includingHiddenFields:includingHiddenFields completion:completion];
}

- (NSArray *)showTargets:(NSArray *)targets
{
    return [self.formsManager showTargets:targets];
}

- (NSArray *)hideTargets:(NSArray *)targets
{
    return [self.formsManager hideTargets:targets];
}

- (NSArray *)updateTargets:(NSArray *)targets
{
    return [self.formsManager updateTargets:targets];
}

- (NSArray *)enableTargets:(NSArray *)targets
{
    return [self.formsManager enableTargets:targets];
}

- (NSArray *)disableTargets:(NSArray *)targets
{
    return [self.formsManager disableTargets:targets];
}

- (NSInteger)numberOfFields
{
    return [self.formsManager numberOfFields];
}

- (void)updateValuesWithDictionary:(NSDictionary *)dictionary
{
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        self.formsManager.values[key] = obj;
    }];
}

- (NSDictionary *)values
{
    return [self.formsManager.values copy];
}

- (NSDictionary *)removedValues
{
    return [self.formsManager.removedValues copy];
}

- (void)resetRemovedValues
{
    [self.formsManager resetRemovedValues];
}

#pragma mark - Private methods

- (void)updateSectionPosition:(FORMSection *)section
{
    for (FORMSection *currentSection in section.form.sections) {
        if ([currentSection.position integerValue] > [section.position integerValue]) {
            currentSection.position = @([currentSection.position integerValue] - 1);
        }
    }
}

- (NSDictionary *)updateValueKeys:(NSArray *)currentKeys
{
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

- (void)removeDynamicKeysForSection:(FORMSection *)section
{
    __block NSString *sectionID = [section.sectionID substringToIndex:[section.sectionID rangeOfString:@"["].location];
    [self.values enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key hasPrefix:sectionID]) {
            [self.formsManager.values removeObjectForKey:key];
        }
    }];
}

#pragma mark - Deprecated

- (NSDictionary *)valuesDictionary
{
    return [self values];
}

@end
