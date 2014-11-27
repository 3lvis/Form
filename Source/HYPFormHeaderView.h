@import UIKit;

static const CGFloat HYPFormHeaderContentMargin = 10.0f;
static const CGFloat HYPFormTitleMargin = 20.0f;
static const CGFloat HYPFormHeaderHeight = 55.0f;

static NSString * const HYPFormHeaderReuseIdentifier = @"HYPFormHeaderReuseIdentifier";

@protocol HYPFormHeaderViewDelegate;

@interface HYPFormHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic) NSInteger section;

@property (nonatomic, weak) id <HYPFormHeaderViewDelegate> delegate;

@end

@protocol HYPFormHeaderViewDelegate <NSObject>

- (void)formHeaderViewWasPressed:(HYPFormHeaderView *)headerView;

@end
