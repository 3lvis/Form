#import "HYPSampleCollectionViewController.h"

#import "FORMCollectionViewDataSource.h"
#import "HYPPostalCodeManager.h"
#import "FORMFieldValue.h"
#import "HYPImagePicker.h"
#import "HYPImageFormFieldCell.h"
#import "FORMData.h"
#import "FORMTextFieldCell.h"

#import "UIColor+ANDYHex.h"
#import "UIColor+HYPFormsColors.h"
#import "NSObject+HYPTesting.h"

@interface HYPSampleCollectionViewController () <HYPImagePickerDelegate>

@property (nonatomic, strong) FORMCollectionViewDataSource *dataSource;
@property (nonatomic, copy) NSDictionary *initialValues;
@property (nonatomic, strong) HYPImagePicker *imagePicker;
@property (nonatomic, strong) FORMCollectionViewLayout *layout;
@property (nonatomic, copy) NSArray *JSON;

@end

@implementation HYPSampleCollectionViewController

#pragma mark - Initialization

- (instancetype)initWithJSON:(NSArray *)JSON andInitialValues:(NSDictionary *)initialValues
{
    FORMCollectionViewLayout *layout = [[FORMCollectionViewLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (!self) return nil;

    _JSON = JSON;
    self.layout = layout;
    self.initialValues = initialValues;

    [self.collectionView registerClass:[HYPImageFormFieldCell class]
            forCellWithReuseIdentifier:HYPImageFormFieldCellIdentifier];

    self.collectionView.dataSource = self.dataSource;

    if ([NSObject isUnitTesting]) {
        [self.collectionView numberOfSections];
    }

    return self;
}

#pragma mark - Getters

- (FORMCollectionViewDataSource *)dataSource
{
    if (_dataSource) return _dataSource;

    _dataSource = [[FORMCollectionViewDataSource alloc] initWithJSON:self.JSON
                                                          collectionView:self.collectionView
                                                                  layout:self.layout
                                                                  values:self.initialValues
                                                                disabled:YES];

    _dataSource.configureCellForIndexPath = ^(FORMField *field, UICollectionView *collectionView, NSIndexPath *indexPath) {
        id cell;
        BOOL isImageCell = (field.type == FORMFieldTypeCustom && [field.typeString isEqual:@"image"]);
        if (isImageCell) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:HYPImageFormFieldCellIdentifier
                                                             forIndexPath:indexPath];
        }
        return cell;
    };

    __weak typeof(self)weakSelf = self;

    _dataSource.configureFieldUpdatedBlock = ^(id cell, FORMField *field) {
        NSLog(@"field updated: %@ --- %@", field.fieldID, field.fieldValue);

        BOOL shouldUpdateStartDate = ([field.fieldID isEqualToString:@"contract_type"]);

        if (shouldUpdateStartDate) {
            [weakSelf.dataSource.formsManager fieldWithID:@"start_date" includingHiddenFields:YES completion:^(FORMField *field, NSIndexPath *indexPath) {
                if (field) {
                    field.fieldValue = [NSDate date];
                    field.minimumDate = [NSDate date];
                    [weakSelf.dataSource reloadItemsAtIndexPaths:@[indexPath]];
                }
            }];
        }
    };

    return _dataSource;
}

- (HYPImagePicker *)imagePicker
{
    if (_imagePicker) return _imagePicker;

    _imagePicker = [[HYPImagePicker alloc] initForViewController:self usingCaption:@"caption"];
    _imagePicker.delegate = self;

    return _imagePicker;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.collectionView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);

    self.collectionView.backgroundColor = [UIColor HYPFormsBackground];
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
    readOnlyLabel.textColor = [UIColor HYPFormsControlsBlue];
    readOnlyLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [readOnlyView addSubview:readOnlyLabel];

    UISwitch *readOnlySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(90.0f, 5.0f, 40.0f, 40.0f)];
    readOnlySwitch.tintColor = [UIColor HYPFormsControlsBlue];
    readOnlySwitch.onTintColor = [UIColor HYPFormsControlsBlue];
    readOnlySwitch.on = YES;
    [readOnlySwitch addTarget:self action:@selector(readOnly:) forControlEvents:UIControlEventValueChanged];
    [readOnlyView addSubview:readOnlySwitch];

    UIBarButtonItem *readOnlyBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:readOnlyView];

    [self setToolbarItems:@[validateButtonItem, flexibleBarButtonItem, updateButtonItem, flexibleBarButtonItem, readOnlyBarButtonItem]];

    [self.navigationController setToolbarHidden:NO animated:YES];
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FORMField *field = [self.dataSource formFieldAtIndexPath:indexPath];
    return (field.type == FORMFieldTypeCustom && [field.typeString isEqual:@"image"]);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FORMField *field = [self.dataSource formFieldAtIndexPath:indexPath];

    if (field.type == FORMFieldTypeCustom && [field.typeString isEqual:@"image"]) {
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
                                            @"hourly_pay_premium_currency" : @10,
                                            @"start_date" : [NSNull null],
                                            @"username": @1
                                            }];
}

- (void)validateButtonAction
{
    if ([self.dataSource formFieldsAreValid]) {
        [[[UIAlertView alloc] initWithTitle:@"Everything is valid, you get a candy!"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"No, thanks"
                          otherButtonTitles:nil, nil] show];
    } else {
        [self.dataSource validateForms];
    }
}

- (void)readOnly:(UISwitch *)sender
{
    if (sender.isOn) {
        [self.dataSource disable];
    } else {
        [self.dataSource enable];
    }

    FORMTarget *target;

    if (sender.isOn) {
        target = [FORMTarget disableFieldTargetWithID:@"image"];
    } else {
        target = [FORMTarget enableFieldTargetWithID:@"image"];
    }

    [self.dataSource processTargets:@[target]];
}

@end
