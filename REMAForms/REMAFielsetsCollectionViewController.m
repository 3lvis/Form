//
//  REMAFielsetsCollectionViewController.m
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFielsetsCollectionViewController.h"

#import "REMAFieldsetHeaderCollectionReusableView.h"
#import "REMAFieldCollectionViewCell.h"
#import "REMAFormsCollectionViewLayout.h"

#import "UIScreen+HYPLiveBounds.h"

#import "REMAFieldset.h"
#import "REMAFormField.h"

@interface REMAFielsetsCollectionViewController ()

@property (nonatomic, strong) NSArray *fieldsets;

@end

@implementation REMAFielsetsCollectionViewController

static NSString * const REMAFieldReuseIdentifier = @"REMAFieldReuseIdentifier";
static NSString * const REMAFieldsetHeaderReuseIdentifier = @"REMAFieldsetHeaderReuseIdentifier";

#pragma mark - Initializers

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (!self) return nil;

    return self;
}

#pragma mark - Getters

- (NSArray *)fieldsets
{
    if (_fieldsets) return _fieldsets;

    _fieldsets = [REMAFieldset fieldsets];

    return _fieldsets;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.collectionView registerClass:[REMAFieldCollectionViewCell class] forCellWithReuseIdentifier:REMAFieldReuseIdentifier];
    [self.collectionView registerClass:[REMAFieldsetHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REMAFieldsetHeaderReuseIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.fieldsets.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    REMAFieldset *fieldset = self.fieldsets[section];

    return [fieldset numberOfFields];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMAFieldCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:REMAFieldReuseIdentifier forIndexPath:indexPath];

    REMAFieldset *fieldset = self.fieldsets[indexPath.section];
    NSArray *fields = fieldset.fields;
    REMAFormField *field = fields[indexPath.row];

    if (field.sectionSeparator) {
        cell.contentView.backgroundColor = [UIColor brownColor];
    } else {
        cell.contentView.backgroundColor = [UIColor redColor];
    }

    cell.text = @"Hello world";//self.fieldsets[indexPath.row];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320.0f, 44.0f);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind != UICollectionElementKindSectionHeader) return nil;

    REMAFieldsetHeaderCollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                withReuseIdentifier:REMAFieldsetHeaderReuseIdentifier
                                                                                                       forIndexPath:indexPath];
    reusableview.headerLabel.text = [NSString stringWithFormat:@"Fieldset #%li", indexPath.section + 1];

    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMAFieldset *fieldset = self.fieldsets[indexPath.section];

    NSArray *fields = fieldset.fields;

    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat deviceWidth = CGRectGetWidth(bounds) - 40;
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;

    REMAFormField *field = fields[indexPath.row];
    if (field.sectionSeparator) {
        width = deviceWidth;
        height = 5.0f;
    } else {
        width = floor(deviceWidth * ([field.size floatValue] / 100.0f));
        height = 50.0f;
    }

    return CGSizeMake(width, height);
}

@end
