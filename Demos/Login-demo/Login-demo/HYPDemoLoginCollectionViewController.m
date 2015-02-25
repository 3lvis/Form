#import "HYPDemoLoginCollectionViewController.h"
#import "FORMDataSource.h"

static NSString * const reuseIdentifier = @"Cell";

@interface HYPDemoLoginCollectionViewController ()

@property (nonatomic, strong) NSArray *JSON;
@property (nonatomic, strong) FORMDataSource *dataSource;
@property (nonatomic, strong) FORMCollectionViewLayout *layout;

@end

@implementation HYPDemoLoginCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.dataSource = self.dataSource;
}

#pragma mark - Data source collection view

- (FORMDataSource *)dataSource
{
    if (self.dataSource) return self.dataSource;

    self.dataSource = [[FORMDataSource alloc] initWithJSON:self.JSON
                                        collectionView:self.collectionView
                                                layout:self.layout
                                                values:nil
                                              disabled:NO];

    return self.dataSource;
}

@end
