@import UIKit;

#import "FORMFieldHeadingLabel.h"

#import "FORMTextField.h"
#import "FORMFieldHeadingLabel.h"

#import "FORMField.h"

static const CGFloat FORMFieldCellMarginTop = 30.0f;
static const CGFloat FORMFieldCellMarginBottom = 10.0f;

static const NSInteger FORMFieldCellMargin = 10.0f;
static const NSInteger FORMFieldCellItemSmallHeight = 1.0f;
static const NSInteger FORMFieldCellItemHeight = 85.0f;

static const CGFloat FORMTextFieldCellMarginX = 10.0f;

static const CGFloat FORMFieldCellBorderWidth = 1.0f;
static const CGFloat FORMFieldCellCornerRadius = 5.0f;
static const CGFloat FORMFieldCellLeftMargin = 10.0f;

@protocol FORMBaseFieldCellDelegate;

@interface FORMBaseFieldCell : UICollectionViewCell

@property (nonatomic, strong) FORMFieldHeadingLabel *headingLabel;

@property (nonatomic, strong) FORMField *field;
@property (nonatomic, getter = isDisabled) BOOL disabled;

@property (nonatomic, weak) id <FORMBaseFieldCellDelegate> delegate;

- (void)updateFieldWithDisabled:(BOOL)disabled;
- (void)updateWithField:(FORMField *)field;
- (void)validate;

@end

@protocol FORMBaseFieldCellDelegate <NSObject>

- (void)fieldCell:(UICollectionViewCell *)fieldCell updatedWithField:(FORMField *)field;
- (void)fieldCell:(UICollectionViewCell *)fieldCell processTargets:(NSArray *)targets;

@end
