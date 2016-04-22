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
#import "UIViewController+HYPKeyboardToolbar.h"
#import "NSJSONSerialization+ANDYJSONFile.h"
#import "UIColor+Hex.h"

@interface HYPSampleCollectionViewController () <HYPImagePickerDelegate>

@property (nonatomic) HYPImagePicker *imagePicker;

@end

@implementation HYPSampleCollectionViewController

#pragma mark - Initialization

- (instancetype)initWithJSON:(NSArray *)JSON
            andInitialValues:(NSDictionary *)initialValues {
    self = [super initWithJSON:JSON
              andInitialValues:initialValues
                      disabled:YES];
    if (!self) return nil;

    [self.collectionView registerClass:[HYPImageFormFieldCell class]
            forCellWithReuseIdentifier:HYPImageFormFieldCellIdentifier];

    return self;
}

#pragma mark - Getters

- (HYPImagePicker *)imagePicker {
    if (_imagePicker) return _imagePicker;

    _imagePicker = [[HYPImagePicker alloc] initForViewController:self
                                                    usingCaption:@"caption"];
    _imagePicker.delegate = self;

    return _imagePicker;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Form";

    self.collectionView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);

    self.collectionView.backgroundColor = [UIColor form_colorFromHex:@"DAE2EA"];

    UIBarButtonItem *printValuesButton = [[UIBarButtonItem alloc] initWithTitle:@"Show Values"
                                                                          style:UIBarButtonItemStyleDone
                                                                         target:self
                                                                         action:@selector(printValuesAction)];
    self.navigationItem.rightBarButtonItem = printValuesButton;

    [self setUpDataSource];
}

- (void)setUpDataSource {
    self.dataSource.configureCellForItemAtIndexPathBlock = ^(FORMField *field, UICollectionView *collectionView, NSIndexPath *indexPath) {
        id cell;
        BOOL isImageCell = (field.type == FORMFieldTypeCustom && [field.typeString isEqual:@"image"]);
        if (isImageCell) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:HYPImageFormFieldCellIdentifier
                                                             forIndexPath:indexPath];
        }
        return cell;
    };

    __weak typeof(self)weakSelf = self;

    self.dataSource.fieldUpdatedBlock = ^(id cell, FORMField *field) {
        NSLog(@"field updated: %@ --- %@", field.fieldID, field.value);

        BOOL shouldUpdateStartDate = ([field.fieldID isEqualToString:@"contract_type"]);

        if (shouldUpdateStartDate) {
            [weakSelf.dataSource fieldWithID:@"start_date"
                       includingHiddenFields:YES
                                  completion:^(FORMField *field, NSIndexPath *indexPath) {
                                      if (field) {
                                          field.value = [NSDate date];
                                          field.minimumDate = [NSDate date];
                                          [weakSelf.dataSource updateValuesWithDictionary:@{@"start_date" : [NSDate date]}];
                                          [weakSelf.dataSource reloadFieldsAtIndexPaths:@[indexPath]];
                                      }
                                  }];
        }
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self configureToolbar];
}

- (void)configureToolbar {
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
    readOnlyLabel.textColor = [UIColor form_colorFromHex:@"5182AF"];
    readOnlyLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [readOnlyView addSubview:readOnlyLabel];

    UISwitch *readOnlySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(90.0f, 5.0f, 40.0f, 40.0f)];
    readOnlySwitch.tintColor = [UIColor form_colorFromHex:@"5182AF"];
    readOnlySwitch.onTintColor = [UIColor form_colorFromHex:@"5182AF"];
    readOnlySwitch.on = YES;
    [readOnlySwitch addTarget:self action:@selector(readOnly:) forControlEvents:UIControlEventValueChanged];
    [readOnlyView addSubview:readOnlySwitch];

    UIBarButtonItem *readOnlyBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:readOnlyView];

    [self setToolbarItems:@[validateButtonItem, flexibleBarButtonItem, updateButtonItem, flexibleBarButtonItem, readOnlyBarButtonItem]];

    [self.navigationController setToolbarHidden:NO animated:YES];
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FORMField *field = [self.dataSource fieldAtIndexPath:indexPath];
    return (field.type == FORMFieldTypeCustom && [field.typeString isEqual:@"image"]);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FORMField *field = [self.dataSource fieldAtIndexPath:indexPath];

    if (field.type == FORMFieldTypeCustom && [field.typeString isEqual:@"image"]) {
        [self.imagePicker invokeCamera];
    }
}

#pragma mark - HYPImagePickerDelegate

- (void)imagePicker:(HYPImagePicker *)imagePicker
     didPickedImage:(UIImage *)image {
    NSLog(@"picture gotten");
}

#pragma mark - Actions

- (void)updateButtonAction {
    [self.dataSource reloadWithDictionary:@{@"first_name" : @"Hodo",
                                            @"salary_type" : @1,
                                            @"hourly_pay_level" : @1,
                                            @"hourly_pay_premium_percent" : @10,
                                            @"hourly_pay_premium_currency" : @10,
                                            @"start_date" : [NSNull null],
                                            @"username": @1}];
}

- (void)validateButtonAction {
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

- (void)printValuesAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Values"
                                                                             message:[self.dataSource.values description]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           [self dismissViewControllerAnimated:YES completion:nil];
                                                       }];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)readOnly:(UISwitch *)sender {
    FORMTarget *target;

    if (sender.isOn) {
        [self.dataSource disable];
        target = [FORMTarget hideFieldTargetWithID:@"image"];
    } else {
        [self.dataSource enable];
        target = [FORMTarget showFieldTargetWithID:@"image"];
    }

    [self.dataSource processTargets:@[target]];
}

@end
