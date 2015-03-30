#import "HYPSampleCollectionViewController.h"

#import "FORMDataSource.h"
#import "FORMPostalCodeManager.h"
#import "FORMFieldValue.h"
#import "HYPImagePicker.h"
#import "HYPImageFormFieldCell.h"
#import "FORMData.h"
#import "FORMTextFieldCell.h"
#import "FORMDefaultStyle.h"

#import "NSObject+HYPTesting.h"
#import "UIColor+Hex.h"
#import "UIViewController+HYPKeyboardToolbar.h"

@interface HYPSampleCollectionViewController () <HYPImagePickerDelegate>

@property (nonatomic) FORMDataSource *dataSource;
@property (nonatomic, copy) NSDictionary *initialValues;
@property (nonatomic) HYPImagePicker *imagePicker;
@property (nonatomic) FORMLayout *layout;
@property (nonatomic, copy) NSArray *JSON;

@end

@implementation HYPSampleCollectionViewController

#pragma mark - Deallocation

- (void)dealloc
{
    [self hyp_removeKeyboardToolbarObservers];
}

#pragma mark - Initialization

- (instancetype)initWithJSON:(NSArray *)JSON andInitialValues:(NSDictionary *)initialValues
{
    FORMLayout *layout = [[FORMLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (!self) return nil;

    _JSON = JSON;
    self.layout = layout;
    self.initialValues = initialValues;

    [self.collectionView registerClass:[HYPImageFormFieldCell class]
            forCellWithReuseIdentifier:HYPImageFormFieldCellIdentifier];

    if ([NSObject isUnitTesting]) {
        [self.collectionView numberOfSections];
    }

    [self hyp_addKeyboardToolbarObservers];

    return self;
}

#pragma mark - Getters

- (FORMDataSource *)dataSource
{
    if (_dataSource) return _dataSource;

    _dataSource = [[FORMDataSource alloc] initWithJSON:self.JSON
                                        collectionView:self.collectionView
                                                layout:self.layout
                                                values:self.initialValues
                                              disabled:YES];

    _dataSource.configureCellForItemAtIndexPathBlock = ^(FORMField *field, UICollectionView *collectionView, NSIndexPath *indexPath) {
        id cell;
        BOOL isImageCell = (field.type == FORMFieldTypeCustom && [field.typeString isEqual:@"image"]);
        if (isImageCell) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:HYPImageFormFieldCellIdentifier
                                                             forIndexPath:indexPath];
        }
        return cell;
    };

    __weak typeof(self)weakSelf = self;

    _dataSource.fieldUpdatedBlock = ^(id cell, FORMField *field) {
        NSLog(@"field updated: %@ --- %@", field.fieldID, field.value);

        BOOL shouldUpdateStartDate = ([field.fieldID isEqualToString:@"contract_type"]);

        if (shouldUpdateStartDate) {
            [weakSelf.dataSource fieldWithID:@"start_date"
                       includingHiddenFields:YES
                                  completion:^(FORMField *field, NSIndexPath *indexPath) {
                                      if (field) {
                                          field.value = [NSDate date];
                                          field.minimumDate = [NSDate date];
                                          [weakSelf.dataSource reloadFieldsAtIndexPaths:@[indexPath]];
                                      }
                                  }];
        }
    };

    return _dataSource;
}

- (HYPImagePicker *)imagePicker
{
    if (_imagePicker) return _imagePicker;

    _imagePicker = [[HYPImagePicker alloc] initForViewController:self
                                                    usingCaption:@"caption"];
    _imagePicker.delegate = self;

    return _imagePicker;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.collectionView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);

    self.collectionView.backgroundColor = [UIColor colorFromHex:@"DAE2EA"];

    self.collectionView.dataSource = self.dataSource;
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
    readOnlyLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [readOnlyView addSubview:readOnlyLabel];

    UISwitch *readOnlySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(90.0f, 5.0f, 40.0f, 40.0f)];
    readOnlySwitch.tintColor = [UIColor colorFromHex:@"5182AF"];
    readOnlySwitch.onTintColor = [UIColor colorFromHex:@"5182AF"];
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
    FORMField *field = [self.dataSource fieldAtIndexPath:indexPath];
    return (field.type == FORMFieldTypeCustom && [field.typeString isEqual:@"image"]);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FORMField *field = [self.dataSource fieldAtIndexPath:indexPath];

    if (field.type == FORMFieldTypeCustom && [field.typeString isEqual:@"image"]) {
        [self.imagePicker invokeCamera];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource sizeForFieldAtIndexPath:indexPath];
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

- (void)imagePicker:(HYPImagePicker *)imagePicker
     didPickedImage:(UIImage *)image
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
    if ([self.dataSource isValid]) {
        [[[UIAlertView alloc] initWithTitle:@"Everything is valid, you get a candy!"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"No, thanks"
                          otherButtonTitles:nil, nil] show];
    } else {
        [self.dataSource validate];
    }
}

- (void)readOnly:(UISwitch *)sender
{
    FORMTarget *target;

    if (sender.isOn) {
        [self.dataSource disable];
        target = [FORMTarget disableFieldTargetWithID:@"image"];
    } else {
        [self.dataSource enable];
        target = [FORMTarget enableFieldTargetWithID:@"image"];
    }

    [self.dataSource processTargets:@[target]];
}

@end
