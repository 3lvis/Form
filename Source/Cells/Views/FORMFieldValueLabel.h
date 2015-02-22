@import UIKit;

@protocol FORMTitleLabelDelegate;

@interface FORMFieldValueLabel : UILabel

@property (nonatomic, getter = isValid)    BOOL valid;
@property (nonatomic, getter = isActive)   BOOL active;
@property (nonatomic, weak) id <FORMTitleLabelDelegate> delegate;

@end

@protocol FORMTitleLabelDelegate <NSObject>

- (void)titleLabelPressed:(FORMFieldValueLabel *)titleLabel;

@end
