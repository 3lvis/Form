@import UIKit;

@protocol FORMTitleLabelDelegate;

@interface FORMFieldValueLabel : UILabel

@property (nonatomic, getter = isValid)    BOOL valid;
@property (nonatomic, getter = isActive)   BOOL active;
@property (nonatomic, weak) id <FORMTitleLabelDelegate> delegate;

- (void)setCustomFont:(UIFont *)font  UI_APPEARANCE_SELECTOR;
- (void)setBorderWidth:(CGFloat)borderWidth UI_APPEARANCE_SELECTOR;
- (void)setBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setCornerRadius:(CGFloat)cornerRadius UI_APPEARANCE_SELECTOR;

- (void)setActiveBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setActiveBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setInactiveBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setInactiveBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;

- (void)setEnabledBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setEnabledBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setEnabledTextColor:(UIColor *)textColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledTextColor:(UIColor *)textColor UI_APPEARANCE_SELECTOR;

- (void)setValidBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setValidBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setInvalidBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setInvalidBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;

@end

@protocol FORMTitleLabelDelegate <NSObject>

- (void)titleLabelPressed:(FORMFieldValueLabel *)titleLabel;

@end
