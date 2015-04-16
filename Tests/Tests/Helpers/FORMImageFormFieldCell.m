#import "FORMImageFormFieldCell.h"

static const CGFloat FORMImageFormFieldTopMargin = 20.0f;
static const CGFloat FORMImageFormFieldHorizontalMargin = 10.0f;

static const CGFloat FORMImageFormFieldCameraY = 20.0f;
static const CGFloat FORMImageFormFieldCameraSize = 84.0f;

static const CGFloat FORMImageFormFieldLabelsX = 100.0f;
static const CGFloat FORMImageFormFieldLabelsWidth = 260.0f;

static const CGFloat FORMImageFormFieldLabelY = 25.0f;
static const CGFloat FORMImageFormFieldLabelHeight = 25.0f;

static const CGFloat FORMImageFormFieldInfoY = 50.0f;
static const CGFloat FORMImageFormFieldInfoHeight = 60.0f;

static const CGFloat FORMImageFormFieldContainerWidth = 360.0f;

@implementation FORMImageFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.contentView.layer.cornerRadius = 5.0f;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.contentView addSubview:[self container]];

    return self;
}

- (UIImageView *)cameraImageView {
    UIImage *image = [UIImage imageNamed:@"camera-icon"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f,
                                                                           FORMImageFormFieldCameraY,
                                                                           FORMImageFormFieldCameraSize,
                                                                           FORMImageFormFieldCameraSize)];
    imageView.image = image;

    return imageView;
}

- (UILabel *)label {
    CGRect labelFrame = CGRectMake(FORMImageFormFieldLabelsX, FORMImageFormFieldLabelY,
                                   FORMImageFormFieldLabelsWidth, FORMImageFormFieldLabelHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = @"Main title";

    return label;
}

- (UILabel *)info {
    CGRect infoFrame = CGRectMake(FORMImageFormFieldLabelsX, FORMImageFormFieldInfoY,
                                  FORMImageFormFieldLabelsWidth, FORMImageFormFieldInfoHeight);
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoFrame];
    infoLabel.text = @"Some info on the button";
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.numberOfLines = 0;

    return infoLabel;
}

- (UIView *)container {
    CGFloat height = CGRectGetHeight(self.frame) - FORMImageFormFieldTopMargin;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, FORMImageFormFieldContainerWidth, height)];
    [view addSubview:[self cameraImageView]];
    [view addSubview:[self label]];
    [view addSubview:[self info]];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

    CGPoint center = self.contentView.center;
    center.y -= (FORMImageFormFieldTopMargin / 2.0f);
    view.center = center;

    return view;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];

    self.contentView.frame = [self contentViewFrame];
}

- (CGRect)contentViewFrame {
    CGFloat horizontalMargin = FORMImageFormFieldHorizontalMargin;
    CGFloat verticalMargin = FORMImageFormFieldTopMargin;

    CGRect frame = self.frame;
    frame.origin.x = horizontalMargin;
    frame.origin.y = verticalMargin;
    frame.size.width = CGRectGetWidth(self.frame) - (horizontalMargin * 2);
    frame.size.height = CGRectGetHeight(self.frame) - verticalMargin;

    return frame;
}

@end
