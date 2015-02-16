#import "HYPSampleCollectionViewController.h"

#import "HYPFormsCollectionViewDataSource.h"
#import "HYPPostalCodeManager.h"
#import "HYPFieldValue.h"
#import "HYPImagePicker.h"
#import "HYPImageFormFieldCell.h"
#import "HYPFormsManager.h"
#import "HYPTextFormFieldCell.h"

#import "UIColor+ANDYHex.h"
#import "NSJSONSerialization+ANDYJSONFile.h"
#import "UIColor+HYPFormsColors.h"
#import "NSObject+HYPTesting.h"

@interface HYPSampleCollectionViewController () <HYPImagePickerDelegate>

@property (nonatomic, strong) HYPFormsCollectionViewDataSource *dataSource;
@property (nonatomic, copy) NSDictionary *initialValues;
@property (nonatomic, strong) HYPImagePicker *imagePicker;
@property (nonatomic, strong) HYPFormsManager *formsManager;
@property (nonatomic, strong) HYPFormsLayout *layout;

@end

@implementation HYPSampleCollectionViewController

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    HYPFormsLayout *layout = [[HYPFormsLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (!self) return nil;

    self.layout = layout;
    self.initialValues = dictionary;

    [self.collectionView registerClass:[HYPImageFormFieldCell class]
            forCellWithReuseIdentifier:HYPImageFormFieldCellIdentifier];

    self.collectionView.dataSource = self.dataSource;

    if ([NSObject isUnitTesting]) {
        [self.collectionView numberOfSections];
    }

    return self;
}

#pragma mark - Getters

- (HYPFormsManager *)formsManager
{
    if (_formsManager) return _formsManager;

    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];

    _formsManager = [[HYPFormsManager alloc] initWithJSON:JSON
                                            initialValues:self.initialValues
                                         disabledFieldIDs:@[@"display_name"]
                                                 disabled:YES];

    return _formsManager;
}

- (HYPFormsCollectionViewDataSource *)dataSource
{
    if (_dataSource) return _dataSource;

    _dataSource = [[HYPFormsCollectionViewDataSource alloc] initWithCollectionView:self.collectionView
                                                                            layout:self.layout
                                                                   andFormsManager:self.formsManager];

    _dataSource.configureCellForIndexPath = ^(HYPFormField *field, UICollectionView *collectionView, NSIndexPath *indexPath) {
        BOOL isImageCell = (field.type == HYPFormFieldTypeCustom && [field.typeString isEqual:@"image"]);
        id cell;
        if (isImageCell) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:HYPImageFormFieldCellIdentifier
                                                             forIndexPath:indexPath];
        }
        return cell;
    };

    __weak typeof(self)weakSelf = self;

    _dataSource.configureFieldUpdatedBlock = ^(id cell, HYPFormField *field) {
        NSLog(@"field updated: %@ --- %@", field.fieldID, field.fieldValue);

        BOOL shouldUpdateStartDate = ([field.fieldID isEqualToString:@"contract_type"]);

        if (shouldUpdateStartDate) {
            [weakSelf.formsManager fieldWithID:@"start_date" includingHiddenFields:YES completion:^(HYPFormField *field, NSIndexPath *indexPath) {
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
    HYPFormField *field = [self.dataSource formFieldAtIndexPath:indexPath];
    return (field.type == HYPFormFieldTypeCustom && [field.typeString isEqual:@"image"]);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYPFormField *field = [self.dataSource formFieldAtIndexPath:indexPath];

    if (field.type == HYPFormFieldTypeCustom && [field.typeString isEqual:@"image"]) {
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

    HYPFormTarget *target;

    if (sender.isOn) {
        target = [HYPFormTarget disableFieldTargetWithID:@"image"];
    } else {
        target = [HYPFormTarget enableFieldTargetWithID:@"image"];
    }

    [self.dataSource processTargets:@[target]];
}

@end
