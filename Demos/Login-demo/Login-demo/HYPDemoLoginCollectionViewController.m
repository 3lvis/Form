#import "HYPDemoLoginCollectionViewController.h"
#import "FORMDataSource.h"
#import "NSJSONSerialization+ANDYJSONFile.h"
#import "FORMTextField.h"
#import "FORMLayout.h"
#import "FORMButtonFieldCell.h"

#import "UIColor+Hex.h"

@interface HYPDemoLoginCollectionViewController () <FORMBaseFieldCellDelegate>

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

    _dataSource.configureCellForItemAtIndexPathBlock = ^(FORMField *field, UICollectionView *collectionView, NSIndexPath *indexPath) {
        FORMBaseFieldCell *cell;
        if ([field.typeString isEqualToString:@"button"]) {
            weakSelf.indexPathButton = indexPath;
        }
        return cell;
    };

    _dataSource.fieldUpdatedBlock = ^(FORMBaseFieldCell *cell, FORMField *field) {
        cell.delegate = weakSelf;
        if ([field.title isEqualToString:@"Email"]) {
            weakSelf.emailTextField = field;
        } else if ([field.title isEqualToString:@"Password"]) {
            weakSelf.passwordTextField = field;
        } else {
            [weakSelf checkButtonPressedWithField:field];
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource sizeForFieldAtIndexPath:indexPath];
}

#pragma mark - FORMBaseFieldCellDelegate

- (void)fieldCell:(UICollectionViewCell *)fieldCell updatedWithField:(FORMField *)field
{
    if (self.emailTextField.valid && self.passwordTextField.valid) {
        FORMButtonFieldCell *cell = (FORMButtonFieldCell *)[self.collectionView cellForItemAtIndexPath:self.indexPathButton];
        cell.disabled = NO;
    }

    if ([field.typeString isEqualToString:@"button"]) {
        [self checkButtonPressedWithField:field];
    }
}

- (void)fieldCell:(UICollectionViewCell *)fieldCell processTargets:(NSArray *)targets { }

#pragma mark - Private methods

- (void)checkButtonPressedWithField:(FORMField *)field
{
    if ([field.typeString isEqualToString:@"button"] && self.emailTextField.valid && self.passwordTextField.valid) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hey" message:@"You just logged in! Congratulations" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionNice = [UIAlertAction actionWithTitle:@"NICE" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];

        [alertController addAction:alertActionNice];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


@end
