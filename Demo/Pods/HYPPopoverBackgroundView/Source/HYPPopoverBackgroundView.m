#import "HYPPopoverBackgroundView.h"

@import QuartzCore;

static BOOL HYPPopoverBackgroundShadowEnabled = YES;
static CGFloat HYPPopoverBackgroundArrowBase = 35.0f;
static CGFloat HYPPopoverBackgroundArrowHeight = 19.0f;
static CGFloat HYPPopoverBackgroundContentInset = 9.0f;
static CGFloat HYPPopoverBackgroundCornerRadius = 8.0f;
static const CGFloat HYPPopoverBackgroundImageSize = 40.0f;
static const CGFloat HYPPopoverBackgroundBottomContentInset = 0.0f;
static const CGFloat HYPPopoverBackgroundLeftContentInset = 0.0f;
static const CGFloat HYPPopoverBackgroundRightContentInset = 0.0f;
static const CGFloat HYPPopoverBackgroundTopContentInset = 0.0f;
static UIColor *HYPPopoverBackgroundTintColor = nil;
static UIImage *HYPPopoverBackgroundBackgroundImage = nil;
static UIImage *HYPPopoverBackgroundBottomArrowImage = nil;
static UIImage *HYPPopoverBackgroundLeftArrowImage = nil;
static UIImage *HYPPopoverBackgroundRightArrowImage = nil;
static UIImage *HYPPopoverBackgroundTopArrowImage = nil;

@interface HYPPopoverBackgroundView ()

@property (nonatomic, retain) UIImageView *arrowImageView;
@property (nonatomic, retain) UIImageView *popoverBackgroundImageView;

@end

@implementation HYPPopoverBackgroundView

@synthesize arrowOffset, arrowDirection;


+ (CGFloat)arrowBase
{
    return HYPPopoverBackgroundArrowBase;
}

+ (CGFloat)arrowHeight
{
    return HYPPopoverBackgroundArrowHeight;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(HYPPopoverBackgroundTopContentInset,
                            HYPPopoverBackgroundLeftContentInset,
                            HYPPopoverBackgroundBottomContentInset,
                            HYPPopoverBackgroundRightContentInset);
}

- (void)setArrowOffset:(CGFloat)_arrowOffset
{
    arrowOffset = _arrowOffset;
    [self setNeedsLayout];
}

- (void)setArrowDirection:(UIPopoverArrowDirection)_arrowDirection
{
    arrowDirection = _arrowDirection;
    [self setNeedsLayout];
}

+ (void)setBackgroundImageCornerRadius:(CGFloat)cornerRadius
{
    HYPPopoverBackgroundCornerRadius = cornerRadius;
}

+ (void)setContentInset:(CGFloat)contentInset
{
    HYPPopoverBackgroundContentInset = contentInset;
}

+ (void)setTintColor:(UIColor *)tintColor
{
    HYPPopoverBackgroundTintColor = tintColor;
}

+ (void)setShadowEnabled:(BOOL)shadowEnabled
{
    HYPPopoverBackgroundShadowEnabled = shadowEnabled;
}

+ (void)setArrowBase:(CGFloat)arrowBase
{
    HYPPopoverBackgroundArrowBase = arrowBase;
}

+ (void)setArrowHeight:(CGFloat)arrowHeight
{
    HYPPopoverBackgroundArrowHeight = arrowHeight;
}

+ (void)setBackgroundImage:(UIImage *)background
                       top:(UIImage *)top
                     right:(UIImage *)right
                    bottom:(UIImage *)bottom
                      left:(UIImage *)left
{
    HYPPopoverBackgroundBackgroundImage = background;
    HYPPopoverBackgroundTopArrowImage = top;
    HYPPopoverBackgroundRightArrowImage = right;
    HYPPopoverBackgroundBottomArrowImage = bottom;
    HYPPopoverBackgroundLeftArrowImage = left;
}

+ (void)rebuildArrowImages
{
    [HYPPopoverBackgroundView buildArrows:HYPPopoverBackgroundTintColor];
}

+ (void)buildArrows:(UIColor *)tintColor
{
    UIBezierPath *arrowPath;

    CGSize arrowSize = CGSizeMake(HYPPopoverBackgroundArrowBase,
                                  HYPPopoverBackgroundArrowHeight);

    UIGraphicsBeginImageContextWithOptions(arrowSize, NO, 0.0f);

    arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(HYPPopoverBackgroundArrowBase/2.0f, 0.0f)];
    [arrowPath addLineToPoint:CGPointMake(HYPPopoverBackgroundArrowBase, HYPPopoverBackgroundArrowHeight)];
    [arrowPath addLineToPoint:CGPointMake(0.0f, HYPPopoverBackgroundArrowHeight)];
    [arrowPath addLineToPoint:CGPointMake(HYPPopoverBackgroundArrowBase/2.0f, 0.0f)];

    [tintColor setFill];
    [arrowPath fill];

    HYPPopoverBackgroundTopArrowImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContextWithOptions(arrowSize, NO, 0.0f);

    arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(0.0f, 0.0f)];
    [arrowPath addLineToPoint:CGPointMake(HYPPopoverBackgroundArrowBase, 0.0f)];
    [arrowPath addLineToPoint:CGPointMake(HYPPopoverBackgroundArrowBase/2.0f, HYPPopoverBackgroundArrowHeight)];
    [arrowPath addLineToPoint:CGPointMake(0.0f, 0.0f)];

    [tintColor setFill];
    [arrowPath fill];

    HYPPopoverBackgroundBottomArrowImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContextWithOptions(arrowSize, NO, 0.0f);

    arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(HYPPopoverBackgroundArrowHeight, 0.0f)];
    [arrowPath addLineToPoint:CGPointMake(HYPPopoverBackgroundArrowHeight, HYPPopoverBackgroundArrowBase)];
    [arrowPath addLineToPoint:CGPointMake(0.0f, HYPPopoverBackgroundArrowBase/2.0f)];
    [arrowPath addLineToPoint:CGPointMake(HYPPopoverBackgroundArrowHeight, 0.0f)];

    [tintColor setFill];
    [arrowPath fill];

    HYPPopoverBackgroundLeftArrowImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContextWithOptions(arrowSize, NO, 0.0f);

    arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(0.0f, 0.0f)];
    [arrowPath addLineToPoint:CGPointMake(HYPPopoverBackgroundArrowHeight, HYPPopoverBackgroundArrowBase/2.0f)];
    [arrowPath addLineToPoint:CGPointMake(0.0f, HYPPopoverBackgroundArrowBase)];
    [arrowPath addLineToPoint:CGPointMake(0.0f, 0.0f)];

    [tintColor setFill];
    [arrowPath fill];

    HYPPopoverBackgroundRightArrowImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(HYPPopoverBackgroundImageSize, HYPPopoverBackgroundImageSize),
                                           NO,
                                           0.0f);

    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, HYPPopoverBackgroundImageSize, HYPPopoverBackgroundImageSize)
                                                          cornerRadius:HYPPopoverBackgroundCornerRadius];
    [tintColor setFill];
    [borderPath fill];


    CGFloat capInset = HYPPopoverBackgroundCornerRadius * 2;
    UIEdgeInsets capInsets = UIEdgeInsetsMake(capInset,
                                              capInset,
                                              capInset,
                                              capInset);

    HYPPopoverBackgroundBackgroundImage = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets:capInsets];

    UIGraphicsEndImageContext();
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [HYPPopoverBackgroundView buildArrows:HYPPopoverBackgroundTintColor];

    _popoverBackgroundImageView = [[UIImageView alloc] initWithImage:HYPPopoverBackgroundBackgroundImage];
    [self addSubview:_popoverBackgroundImageView];

    _arrowImageView = [UIImageView new];
    [self addSubview:_arrowImageView];

    if (HYPPopoverBackgroundShadowEnabled) {
        _popoverBackgroundImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _popoverBackgroundImageView.layer.shadowOpacity = 0.3f;
        _popoverBackgroundImageView.layer.shadowRadius = 1.5f;
        _popoverBackgroundImageView.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);

        _arrowImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _arrowImageView.layer.shadowOpacity = 0.3f;
        _arrowImageView.layer.shadowRadius = 1.5f;
        _arrowImageView.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
        _arrowImageView.layer.masksToBounds = YES;
    }

    return self;
}

- (void)layoutSubviews
{
    CGFloat popoverImageOriginX = 0.0f;
    CGFloat popoverImageOriginY = 0.0f;
    CGFloat popoverImageWidth = self.bounds.size.width;
    CGFloat popoverImageHeight = self.bounds.size.height;
    CGFloat arrowImageOriginX = 0.0f;
    CGFloat arrowImageOriginY = 0.0f;
    CGFloat arrowImageWidth = HYPPopoverBackgroundArrowBase;
    CGFloat arrowImageHeight = HYPPopoverBackgroundArrowHeight;

    switch (self.arrowDirection) {
        case UIPopoverArrowDirectionUp: {
            popoverImageOriginY = HYPPopoverBackgroundArrowHeight;
            popoverImageHeight = self.bounds.size.height - HYPPopoverBackgroundArrowHeight;
            arrowImageOriginX = roundf((self.bounds.size.width - HYPPopoverBackgroundArrowBase) / 2.0f + self.arrowOffset);

            if ((arrowImageOriginX + HYPPopoverBackgroundArrowBase) > (self.bounds.size.width - HYPPopoverBackgroundCornerRadius)) {
                arrowImageOriginX -= HYPPopoverBackgroundCornerRadius;
            }

            if (arrowImageOriginX < HYPPopoverBackgroundCornerRadius) {
                arrowImageOriginX += HYPPopoverBackgroundCornerRadius;
            }

            self.arrowImageView.image = HYPPopoverBackgroundTopArrowImage;

        } break;

        case UIPopoverArrowDirectionDown: {
            popoverImageHeight = self.bounds.size.height - HYPPopoverBackgroundArrowHeight;
            arrowImageOriginX = roundf((self.bounds.size.width - HYPPopoverBackgroundArrowBase) / 2.0f + self.arrowOffset);

            if ((arrowImageOriginX + HYPPopoverBackgroundArrowBase) > (self.bounds.size.width - HYPPopoverBackgroundCornerRadius)) {
                arrowImageOriginX -= HYPPopoverBackgroundCornerRadius;
            }

            if (arrowImageOriginX < HYPPopoverBackgroundCornerRadius) {
                arrowImageOriginX += HYPPopoverBackgroundCornerRadius;
            }

            arrowImageOriginY = popoverImageHeight;

            self.arrowImageView.image = HYPPopoverBackgroundBottomArrowImage;

        } break;

        case UIPopoverArrowDirectionLeft: {

            popoverImageOriginX = HYPPopoverBackgroundArrowHeight;
            popoverImageWidth = self.bounds.size.width - HYPPopoverBackgroundArrowHeight;

            arrowImageOriginY = roundf((self.bounds.size.height - HYPPopoverBackgroundArrowBase) / 2.0f + self.arrowOffset);

            if ((arrowImageOriginY + HYPPopoverBackgroundArrowBase) > (self.bounds.size.height - HYPPopoverBackgroundCornerRadius)) {
                arrowImageOriginY -= HYPPopoverBackgroundCornerRadius;
            }

            if (arrowImageOriginY < HYPPopoverBackgroundCornerRadius) {
                arrowImageOriginY += HYPPopoverBackgroundCornerRadius;
            }

            arrowImageWidth = HYPPopoverBackgroundArrowHeight;
            arrowImageHeight = HYPPopoverBackgroundArrowBase;

            self.arrowImageView.image = HYPPopoverBackgroundLeftArrowImage;

        } break;

        case UIPopoverArrowDirectionRight: {
            popoverImageWidth = self.bounds.size.width - HYPPopoverBackgroundArrowHeight;

            arrowImageOriginX = popoverImageWidth;
            arrowImageOriginY = roundf((self.bounds.size.height - HYPPopoverBackgroundArrowBase) / 2.0f + self.arrowOffset);

            if ((arrowImageOriginY + HYPPopoverBackgroundArrowBase) > (self.bounds.size.height - HYPPopoverBackgroundCornerRadius)) {
                arrowImageOriginY -= HYPPopoverBackgroundCornerRadius;
            }

            if (arrowImageOriginY < HYPPopoverBackgroundCornerRadius) {
                arrowImageOriginY += HYPPopoverBackgroundCornerRadius;
            }

            arrowImageWidth = HYPPopoverBackgroundArrowHeight;
            arrowImageHeight = HYPPopoverBackgroundArrowBase;

            self.arrowImageView.image = HYPPopoverBackgroundRightArrowImage;

        } break;
        case UIPopoverArrowDirectionAny:
        case UIPopoverArrowDirectionUnknown:
            break;
    }

    self.popoverBackgroundImageView.frame = CGRectMake(popoverImageOriginX, popoverImageOriginY, popoverImageWidth, popoverImageHeight);
    self.arrowImageView.frame = CGRectMake(arrowImageOriginX, arrowImageOriginY, arrowImageWidth, arrowImageHeight);
}

@end
