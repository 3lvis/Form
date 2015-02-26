#import "HYPDemoLoginCollectionViewController.h"
#import "FORMDataSource.h"
#import "HYPPostalCodeManager.h"
#import "FORMFieldValue.h"
#import "FORMData.h"
#import "FORMTextFieldCell.h"
#import "NSJSONSerialization+ANDYJSONFile.h"
#import "UIColor+HYPFormsColors.h"
#import "FORMTextField.h"
#import "FORMLayout.h"
#import "FORMButtonFieldCell.h"

@interface HYPDemoLoginCollectionViewController () <HYPTextFieldDelegate>

@property (nonatomic, strong) NSArray *JSON;
@property (nonatomic, strong) FORMDataSource *dataSource;
@property (nonatomic, strong) FORMLayout *layout;
@property (nonatomic) FORMField *emailTextField;
@property (nonatomic) FORMField *passwordTextField;
@property (nonatomic) FORMField *buttonCell;

@end

@implementation HYPDemoLoginCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    FORMLayout *layout = [FORMLayout new];

    self.JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"JSON.json"];
    self.layout = layout;

    self.collectionView.dataSource = self.dataSource;
    self.collectionView.contentInset = UIEdgeInsetsMake([UIScreen mainScreen].bounds.size.width/3, 0, 0, 0);
    self.collectionView.backgroundColor = [UIColor HYPFormsLightGray];
}

#pragma mark - Data source collection view

- (FORMDataSource *)dataSource
{
    if (_dataSource) return _dataSource;

    _dataSource = [[FORMDataSource alloc] initWithJSON:self.JSON
                                        collectionView:self.collectionView
                                                layout:self.layout
                                                values:nil
                                              disabled:NO];

    __weak typeof(self)weakSelf = self;

    _dataSource.configureFieldUpdatedBlock = ^(id cell, FORMField *field) {
        if ([field.title isEqualToString:@"Email"]) {
            weakSelf.emailTextField = field;
        } else if ([field.title isEqualToString:@"Password"]) {
            weakSelf.passwordTextField = field;
        } else if ([field.typeString isEqualToString:@"button"] && weakSelf.emailTextField.valid && weakSelf.passwordTextField.valid) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hey" message:@"You just logged in! Congratulations" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertActionNice = [UIAlertAction actionWithTitle:@"NICE" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];

            [alertController addAction:alertActionNice];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hey" message:@"You need to enter correct values. The password should be at least 6 characters long" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertActionNice = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];

            [alertController addAction:alertActionNice];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
    };

    return _dataSource;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource sizeForItemAtIndexPath:indexPath];
}

@end
