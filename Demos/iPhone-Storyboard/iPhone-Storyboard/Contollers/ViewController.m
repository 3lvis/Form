#import "ViewController.h"
#import "NSJSONSerialization+ANDYJSONFile.h"

@implementation ViewController

@synthesize dataSource = _dataSource;

- (FORMDataSource *)dataSource {
    if (_dataSource) return _dataSource;

    FORMLayout *layout = [FORMLayout new];
    self.collectionView.collectionViewLayout = layout;

    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"Form.json"];
    _dataSource = [[FORMDataSource alloc] initWithJSON: JSON
                                              collectionView:self.collectionView
                                                      layout:layout
                                                      values:nil
                                                    disabled:NO];

    _dataSource.configureCellBlock = ^(FORMBaseFieldCell *cell,
                                             NSIndexPath *indexPath,
                                             FORMField *field) {
        cell.field = field;

    };

    return _dataSource;
}

@end
