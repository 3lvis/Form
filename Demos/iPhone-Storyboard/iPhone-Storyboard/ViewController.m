#import "ViewController.h"
#import "NSJSONSerialization+ANDYJSONFile.h"

@interface ViewController ()
@property(nonatomic, strong) FORMDataSource *sourceData;
@end

@implementation ViewController

- (FORMDataSource *)dataSource {
  if (_sourceData) return _sourceData;

  FORMLayout *layout = [FORMLayout new];

  NSArray *JSON = [NSJSONSerialization JSONObjectWithContentsOfFile:@"CreateEvent.json"];
  _sourceData = [[FORMDataSource alloc] initWithJSON: JSON
                                      collectionView:self.collectionView
                                              layout:layout
                                              values:nil
                                            disabled:NO];

  self.collectionView.collectionViewLayout = layout;
  __weak typeof(self)weakSelf = self;

  _sourceData.configureCellBlock = ^(FORMBaseFieldCell *cell, NSIndexPath *indexPath, FORMField *field) {
    cell.field = field;

  };

  _sourceData.fieldUpdatedBlock = ^(FORMBaseFieldCell *cell, FORMField *field) {

  };

  return _sourceData;
}
@end
