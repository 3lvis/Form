//
//  HYPFormsCollectionViewController.m

//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPSampleCollectionViewController.h"

#import "HYPFormsCollectionViewDataSource.h"

#import "HYPFieldValue.h"

#import "HYPImagePicker.h"

#import "UIColor+ANDYHex.h"

@interface HYPSampleCollectionViewController () <HYPImagePickerDelegate>

@property (nonatomic, strong) HYPFormsCollectionViewDataSource *dataSource;
@property (nonatomic, copy) NSDictionary *setUpDictionary;
@property (nonatomic, strong) HYPImagePicker *imagePicker;

@end

@implementation HYPSampleCollectionViewController

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    HYPFormsLayout *layout = [[HYPFormsLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (!self) return nil;

    _setUpDictionary = dictionary;
    layout.dataSource = self.dataSource;

    return self;
}

#pragma mark - Getters

- (HYPFormsCollectionViewDataSource *)dataSource
{
    if (_dataSource) return _dataSource;

    _dataSource = [[HYPFormsCollectionViewDataSource alloc] initWithCollectionView:self.collectionView
                                                                     andDictionary:self.setUpDictionary
                                                                          readOnly:NO];

    _dataSource.configureFieldUpdatedBlock = ^(id cell, HYPFormField *field) {
        NSLog(@"field updated: %@ --- %@", field.id, field.fieldValue);
    };

    return _dataSource;
}

- (HYPImagePicker *)imagePicker
{
    if (_imagePicker) return _imagePicker;

    NSString *caption = NSLocalizedString(@"Legg til bilde av den ansatte", @"Legg til bilde av den ansatte");
    _imagePicker = [[HYPImagePicker alloc] initForViewController:self usingCaption:caption];
    _imagePicker.delegate = self;

    return _imagePicker;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    self.collectionView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);

    self.collectionView.backgroundColor = [UIColor colorFromHex:@"DAE2EA"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    UIBarButtonItem *validateButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Validate"
                                                                           style:UIBarButtonItemStyleDone
                                                                          target:self
                                                                          action:@selector(validateButtonAction)];

    UIBarButtonItem *updateButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update"
                                                                           style:UIBarButtonItemStyleDone
                                                                          target:self
                                                                          action:@selector(updateButtonAction)];

    UIBarButtonItem *flexibleBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                           target:nil
                                                                                           action:nil];

    UIView *readOnlyView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 40.0f)];

    UILabel *readOnlyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 90.0f, 40.0f)];
    readOnlyLabel.text = @"Read-only";
    readOnlyLabel.textColor = [UIColor colorFromHex:@"5182AF"];
    readOnlyLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [readOnlyView addSubview:readOnlyLabel];

    UISwitch *readOnlySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(90.0f, 5.0f, 40.0f, 40.0f)];
    readOnlySwitch.tintColor = [UIColor colorFromHex:@"5182AF"];
    readOnlySwitch.onTintColor = [UIColor colorFromHex:@"5182AF"];
    [readOnlySwitch addTarget:self action:@selector(readOnly:) forControlEvents:UIControlEventValueChanged];
    [readOnlyView addSubview:readOnlySwitch];

    UIBarButtonItem *readOnlyBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:readOnlyView];

    [self setToolbarItems:@[validateButtonItem, flexibleBarButtonItem, updateButtonItem, flexibleBarButtonItem, readOnlyBarButtonItem]];

    [self.navigationController setToolbarHidden:NO animated:YES];

    HYPFormTarget *target = [HYPFormTarget new];
    target.id = @"collective_agreement";
    target.typeString = @"field";
    target.actionTypeString = @"hide";

    [self.dataSource processTargets:@[target]];

    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYPFormField *field = [self.dataSource formFieldAtIndexPath:indexPath];

    return (field.type == HYPFormFieldTypeImage);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYPFormField *field = [self.dataSource formFieldAtIndexPath:indexPath];

    if (field.type == HYPFormFieldTypeImage) {
        [self.imagePicker invokeCamera];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource sizeForItemAtIndexPath:indexPath];
}

#pragma mark - Rotation Handling

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [self.view endEditing:YES];

    [self.collectionViewLayout invalidateLayout];
}

#pragma mark - HYPImagePickerDelegate

- (void)imagePicker:(HYPImagePicker *)imagePicker didPickedImage:(UIImage *)image
{
    NSLog(@"picture gotten");
}

#pragma mark - Actions

- (void)updateButtonAction
{
    [self.dataSource reloadWithDictionary:@{@"first_name" : @"Hodo",
                                            @"salary_type" : @1,
                                            @"hourly_pay_level" : @1,
                                            @"hourly_pay_premium_percent" : @10,
                                            @"hourly_pay_premium_currency" : @10
                                            }];
}

- (void)validateButtonAction
{
    [self.dataSource validateForms];
}

- (void)readOnly:(UISwitch *)sender
{
    [self.dataSource disable:sender.isOn];
}

@end
