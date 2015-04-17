#import "HYPDemoLoginCollectionViewController.h"
#import "FORMDataSource.h"
#import "NSJSONSerialization+ANDYJSONFile.h"
#import "FORMTextField.h"
#import "FORMLayout.h"
#import "FORMButtonFieldCell.h"

#import "UIColor+Hex.h"

@interface HYPDemoLoginCollectionViewController ()

@property (nonatomic) NSArray *JSON;
@property (nonatomic) FORMDataSource *dataSource;
@property (nonatomic) FORMLayout *layout;
@property (nonatomic) FORMField *emailTextField;
@property (nonatomic) FORMField *passwordTextField;
@property NSIndexPath *indexPathButton;

@end

@implementation HYPDemoLoginCollectionViewController

#pragma mark - Getters

- (FORMDataSource *)dataSource
{
    if (_dataSource) return _dataSource;

    _dataSource = [[FORMDataSource alloc] initWithJSON:self.JSON
                                        collectionView:self.collectionView
                                                layout:self.layout
                                                values:nil
                                              disabled:NO];

    __weak typeof(self)weakSelf = self;

    _dataSource.configureCellBlock = ^(FORMBaseFieldCell *cell, NSIndexPath *indexPath, FORMField *field) {
        cell.field = field;

        if (field.type == FORMFieldTypeButton) {
            weakSelf.indexPathButton = indexPath;
        }
    };

    _dataSource.fieldUpdatedBlock = ^(FORMBaseFieldCell *cell, FORMField *field) {
        if ([field.fieldID isEqualToString:@"email"]) {
            weakSelf.emailTextField = field;
            [weakSelf updateLoginButtonState];

        } else if ([field.fieldID isEqualToString:@"password"]) {
            weakSelf.passwordTextField = field;
            [weakSelf updateLoginButtonState];

        } else if ([field.fieldID isEqualToString:@"login"]) {
            [weakSelf showLoginSuccessAlert];
        }
    };

    return _dataSource;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    FORMLayout *layout = [FORMLayout new];
    self.JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"JSON.json"];
    self.layout = layout;

    self.collectionView.dataSource = self.dataSource;
    self.collectionView.contentInset = UIEdgeInsetsMake([UIScreen mainScreen].bounds.size.width/3, 0, 0, 0);
    self.collectionView.backgroundColor = [UIColor colorFromHex:@"F5F5F8"];
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource sizeForFieldAtIndexPath:indexPath];
}

#pragma mark - Private methods

- (void)updateLoginButtonState
{
    FORMButtonFieldCell *loginButtonCell = (FORMButtonFieldCell *)[self.collectionView cellForItemAtIndexPath:self.indexPathButton];
    loginButtonCell.disabled = ![self.dataSource isValid];
}

- (void)showLoginSuccessAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hey"
                                                                             message:@"You just logged in! Congratulations"
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *niceAction = [UIAlertAction actionWithTitle:@"Nice!"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           [alertController dismissViewControllerAnimated:YES
                                                                                               completion:nil];
                                                       }];

    [alertController addAction:niceAction];

    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

@end
