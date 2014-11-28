@import UIKit;

@protocol HYPTitleLabelDelegate;

@interface HYPFieldValueLabel : UILabel

@property (nonatomic, getter = isValid)    BOOL valid;
@property (nonatomic, getter = isActive)   BOOL active;
@property (nonatomic, weak) id <HYPTitleLabelDelegate> delegate;

@end

@protocol HYPTitleLabelDelegate <NSObject>

- (void)titleLabelPressed:(HYPFieldValueLabel *)titleLabel;

@end
