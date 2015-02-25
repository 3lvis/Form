#import "HYPDemoLoginCollectionViewController.h"
#import "FORMDataSource.h"
#import "HYPPostalCodeManager.h"
#import "FORMFieldValue.h"
#import "FORMData.h"
#import "FORMTextFieldCell.h"
#import "NSJSONSerialization+ANDYJSONFile.h"
#import "UIColor+HYPFormsColors.h"

@interface HYPDemoLoginCollectionViewController ()

@property (nonatomic, strong) NSArray *JSON;
@property (nonatomic, strong) FORMDataSource *dataSource;
@property (nonatomic, strong) FORMCollectionViewLayout *layout;

@end

@implementation HYPDemoLoginCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    FORMCollectionViewLayout *layout = [FORMCollectionViewLayout new];

    self.JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"JSON.json"];
    self.layout = layout;

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.dataSource = self.dataSource;

    self.collectionView.contentInset = UIEdgeInsetsMake([UIScreen mainScreen].bounds.size.width/3, 0, 0, 0);
    self.collectionView.backgroundColor = [UIColor HYPFormsDarkGray];
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

    _dataSource.configureCellForIndexPath = ^(FORMField *field, UICollectionView *collectionView, NSIndexPath *indexPath) {
        id cell;
        return cell;
    };

    return _dataSource;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource sizeForItemAtIndexPath:indexPath];
}

@end
