@import UIKit;

#import "FORMDataSource.h"

@interface FORMViewController : UICollectionViewController

@property (nonatomic, readonly) FORMDataSource *dataSource;

- (instancetype)initWithJSON:(id)JSON
            andInitialValues:(NSDictionary *)initialValues
                    disabled:(BOOL)disabled;

@end
