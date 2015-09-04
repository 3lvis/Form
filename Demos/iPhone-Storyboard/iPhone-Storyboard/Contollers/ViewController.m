#import "ViewController.h"
#import "NSJSONSerialization+ANDYJSONFile.h"

@interface ViewController ()
@property(nonatomic, strong) FORMDataSource *customDataSource;
@end

@implementation ViewController

- (FORMDataSource *)dataSource {
    if (_customDataSource) return _customDataSource;

    FORMLayout *layout = [FORMLayout new];
    self.collectionView.collectionViewLayout = layout;

    NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"Form.json"];
    _customDataSource = [[FORMDataSource alloc] initWithJSON: JSON
                                              collectionView:self.collectionView
                                                      layout:layout
                                                      values:nil
                                                    disabled:NO];

    _customDataSource.configureCellBlock = ^(FORMBaseFieldCell *cell,
                                             NSIndexPath *indexPath,
                                             FORMField *field) {
        cell.field = field;

    };

    return _customDataSource;
}

@end
