#import "HYPSampleCollectionViewController.h"

#import "HYPFormsCollectionViewDataSource.h"
#import "HYPPostalCodeManager.h"
#import "HYPFieldValue.h"
#import "HYPImagePicker.h"
#import "HYPImageFormFieldCell.h"
#import "HYPFormsManager.h"

#import "UIColor+ANDYHex.h"
#import "NSJSONSerialization+ANDYJSONFile.h"

@interface HYPSampleCollectionViewController () <HYPImagePickerDelegate,
HYPFormsCollectionViewDataSourceDataSource, HYPFormsLayoutDataSource>

@property (nonatomic, strong) HYPFormsCollectionViewDataSource *dataSource;
@property (nonatomic, copy) NSDictionary *initialValues;
@property (nonatomic, strong) HYPImagePicker *imagePicker;
@property (nonatomic, strong) HYPFormsManager *formsManager;

@end

@implementation HYPSampleCollectionViewController

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andLayout:(HYPFormsLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (!self) return nil;

    NSMutableDictionary *initialValues = [dictionary mutableCopy];
    if ([dictionary valueForKey:@"postal_code"] && ![dictionary valueForKey:@"city"]) {
        NSString *postalCode = [initialValues valueForKey:@"postal_code"];
        HYPPostalCodeManager *postalCodeManager = [HYPPostalCodeManager sharedManager];
        NSString *city = [postalCodeManager cityForPostalCode:postalCode];
        if (city) [initialValues setValue:city forKey:@"city"];
    }

    _initialValues = initialValues;

    layout.dataSource = self;

    return self;
}

#pragma mark - Getters

- (HYPFormsManager *)formsManager
{
    if (_formsManager) return _formsManager;

    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"forms.json"];

    _formsManager = [[HYPFormsManager alloc] initWithJSON:JSON
                                            initialValues:self.initialValues
                                         disabledFieldIDs:@[@"first_name", @"last_name"]
                                                 disabled:YES];

    return _formsManager;
}

- (HYPFormsCollectionViewDataSource *)dataSource
{
    if (_dataSource) return _dataSource;

    _dataSource = [[HYPFormsCollectionViewDataSource alloc] initWithCollectionView:self.collectionView andFormsManager:self.formsManager];

    _dataSource.dataSource = self;

    __weak typeof(self)weakSelf = self;

    _dataSource.configureFieldUpdatedBlock = ^(id cell, HYPFormField *field) {
        NSLog(@"field updated: %@ --- %@", field.fieldID, field.fieldValue);

        if ([field.fieldID isEqualToString:@"postal_code"]) {
            NSString *postalCode = field.fieldValue;
            HYPPostalCodeManager *postalCodeManager = [HYPPostalCodeManager sharedManager];
            NSString *city = [postalCodeManager cityForPostalCode:postalCode];

            HYPFormField *cityField = [HYPFormField fieldWithID:@"city" inForms:weakSelf.formsManager.forms withIndexPath:YES];
            if (cityField) {
                cityField.fieldValue = city;
                [weakSelf.collectionView reloadItemsAtIndexPaths:@[cityField.indexPath]];
            }
        }

        BOOL shouldUpdateFixedEntryDate = ([field.fieldID isEqualToString:@"fixed_pay_level"] ||
                                           [field.fieldID isEqualToString:@"fixed_pay_premium_percent"] ||
                                           [field.fieldID isEqualToString:@"fixed_pay_premium_currency"] ||
                                           [field.fieldID isEqualToString:@"hours_per_week"]);

        if (shouldUpdateFixedEntryDate) {
            HYPFormField *fixedPayEntryDateField = [HYPFormField fieldWithID:@"fixed_pay_entry_date"
                                                                     inForms:weakSelf.formsManager.forms
                                                               withIndexPath:YES];

            if (fixedPayEntryDateField) {
                fixedPayEntryDateField.fieldValue = [NSDate date];
                fixedPayEntryDateField.minimumDate = [NSDate date];
                [weakSelf.dataSource reloadItemsAtIndexPaths:@[fixedPayEntryDateField.indexPath]];
            }
        }
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

    [self.collectionView registerClass:[HYPImageFormFieldCell class]
            forCellWithReuseIdentifier:HYPImageFormFieldCellIdentifier];
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
    readOnlySwitch.on = YES;
    [readOnlySwitch addTarget:self action:@selector(readOnly:) forControlEvents:UIControlEventValueChanged];
    [readOnlyView addSubview:readOnlySwitch];

    UIBarButtonItem *readOnlyBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:readOnlyView];

    [self setToolbarItems:@[validateButtonItem, flexibleBarButtonItem, updateButtonItem, flexibleBarButtonItem, readOnlyBarButtonItem]];

    [self.navigationController setToolbarHidden:NO animated:YES];

    HYPFormTarget *target = [HYPFormTarget new];
    target.targetID = @"collective_agreement";
    target.typeString = @"field";
    target.actionTypeString = @"hide";

    [self.dataSource processTargets:@[target, [HYPFormTarget hideFieldTargetWithID:@"image"]]];
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
                                            @"start_date" : [NSNull null]
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
    [self.dataSource disable:sender.isOn];

    HYPFormTarget *target = [HYPFormTarget new];
    target.targetID = @"image";
    target.typeString = @"field";

    if (sender.isOn) {
        target.actionTypeString = @"hide";
    } else {
        target.actionTypeString = @"show";
    }

    [self.dataSource processTargets:@[target]];
}

#pragma mark - HYPFormsCollectionViewDataSourceDataSource

- (UICollectionViewCell *)formsCollectionDataSource:(HYPFormsCollectionViewDataSource *)formsCollectionDataSource
                                       cellForField:(HYPFormField *)field atIndexPath:(NSIndexPath *)indexPath
{
    HYPImageFormFieldCell *cell;

    BOOL isImageCell = (field.type == HYPFormFieldTypeCustom && [field.typeString isEqual:@"image"]);
    if (isImageCell) {
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:HYPImageFormFieldCellIdentifier
                                                              forIndexPath:indexPath];
    }

    return cell;
}

#pragma mark - HYPFormsLayoutDataSource

- (NSArray *)forms
{
    return self.formsManager.forms;
}

- (NSArray *)collapsedForms
{
    return self.dataSource.collapsedForms;
}

@end
