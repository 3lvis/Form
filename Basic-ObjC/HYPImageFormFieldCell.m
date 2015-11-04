#import "HYPImageFormFieldCell.h"

@import Hex;

static const CGFloat HYPImageFormFieldTopMargin = 20.0f;
static const CGFloat HYPImageFormFieldHorizontalMargin = 10.0f;

static const CGFloat HYPImageFormFieldCameraY = 20.0f;
static const CGFloat HYPImageFormFieldCameraSize = 84.0f;

static const CGFloat HYPImageFormFieldLabelsX = 100.0f;
static const CGFloat HYPImageFormFieldLabelsWidth = 260.0f;

static const CGFloat HYPImageFormFieldLabelY = 25.0f;
static const CGFloat HYPImageFormFieldLabelHeight = 25.0f;

static const CGFloat HYPImageFormFieldInfoY = 50.0f;
static const CGFloat HYPImageFormFieldInfoHeight = 60.0f;

static const CGFloat HYPImageFormFieldContainerWidth = 360.0f;

@implementation HYPImageFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.contentView.backgroundColor = [[UIColor alloc] initWithHex:@"F5F5F8"];

    self.contentView.layer.cornerRadius = 5.0f;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.contentView addSubview:[self container]];

    return self;
}

- (UIImageView *)cameraImageView {
    UIImage *image = [UIImage imageNamed:@"camera-icon"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f,
                                                                           HYPImageFormFieldCameraY,
                                                                           HYPImageFormFieldCameraSize,
                                                                           HYPImageFormFieldCameraSize)];
    imageView.image = image;

    return imageView;
}

- (UILabel *)label {
    CGRect labelFrame = CGRectMake(HYPImageFormFieldLabelsX, HYPImageFormFieldLabelY,
                                   HYPImageFormFieldLabelsWidth, HYPImageFormFieldLabelHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont fontWithName:@"DIN-Medium" size:20.0];
    label.textColor = [[UIColor alloc] initWithHex:@"28649C"];
    label.text = NSLocalizedString(@"Main Title", nil);

    return label;
}

- (UILabel *)info {
    CGRect infoFrame = CGRectMake(HYPImageFormFieldLabelsX, HYPImageFormFieldInfoY,
                                  HYPImageFormFieldLabelsWidth, HYPImageFormFieldInfoHeight);
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoFrame];
    infoLabel.font = [UIFont fontWithName:@"DIN-Regular" size:14.0];
    infoLabel.textColor = [[UIColor alloc] initWithHex:@"28649C"];
    infoLabel.text = NSLocalizedString(@"Some info on the button", nil);
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.numberOfLines = 0;

    return infoLabel;
}

- (UIView *)container {
    CGFloat height = CGRectGetHeight(self.frame) - HYPImageFormFieldTopMargin;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, HYPImageFormFieldContainerWidth, height)];
    [view addSubview:[self cameraImageView]];
    [view addSubview:[self label]];
    [view addSubview:[self info]];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

    CGPoint center = self.contentView.center;
    center.y -= (HYPImageFormFieldTopMargin / 2.0f);
    view.center = center;

    return view;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];

    self.contentView.frame = [self contentViewFrame];
}

- (CGRect)contentViewFrame {
    CGFloat horizontalMargin = HYPImageFormFieldHorizontalMargin;
    CGFloat verticalMargin = HYPImageFormFieldTopMargin;

    CGRect frame = self.frame;
    frame.origin.x = horizontalMargin;
    frame.origin.y = verticalMargin;
    frame.size.width = CGRectGetWidth(self.frame) - (horizontalMargin * 2);
    frame.size.height = CGRectGetHeight(self.frame) - verticalMargin;

    return frame;
}

@end
