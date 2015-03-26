@import UIKit;
@import Foundation;

#import "FORMLayout.h"

@interface HYPSampleCollectionViewController : UICollectionViewController

- (instancetype)initWithJSON:(NSArray *)JSON
            andInitialValues:(NSDictionary *)initialValues;

@end
