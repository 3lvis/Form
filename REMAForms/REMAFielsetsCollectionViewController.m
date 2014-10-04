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

@interface REMAFielsetsCollectionViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation REMAFielsetsCollectionViewController

static NSString * const REMAFieldReuseIdentifier = @"REMAFieldReuseIdentifier";
static NSString * const REMAFieldsetHeaderReuseIdentifier = @"REMAFieldsetHeaderReuseIdentifier";

#pragma mark - Initializers

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)aLayout
{
    REMAFormsCollectionViewLayout *layout = [[REMAFormsCollectionViewLayout alloc] initWithItems:self.items];
    
    self = [super initWithCollectionViewLayout:layout];

    if (!self) return nil;

    self.collectionView.contentSize = [[UIScreen mainScreen] bounds].size;

    return self;
}

#pragma mark - Getters

- (NSArray *)items
{
    if (_items) return _items;

    _items = @[@"One", @"treeee", @"Hello there wha", @"Never mind, just walking", @"Nope"];

    return _items;
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
    return 100;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMAFieldCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:REMAFieldReuseIdentifier forIndexPath:indexPath];

    cell.text = self.items[indexPath.row];

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

@end
