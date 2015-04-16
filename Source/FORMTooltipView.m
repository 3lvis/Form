#import "FORMTooltipView.h"

static BOOL FORMPopoverBackgroundShadowEnabled = YES;
static CGFloat FORMPopoverBackgroundArrowBase = 35.0f;
static CGFloat FORMPopoverBackgroundArrowHeight = 19.0f;
static CGFloat FORMPopoverBackgroundContentInset = 4.5f;
static CGFloat FORMPopoverBackgroundCornerRadius = 8.0f;
static const CGFloat FORMPopoverBackgroundImageSize = 40.0f;
static const CGFloat FORMPopoverBackgroundBottomContentInset = 0.0f;
static const CGFloat FORMPopoverBackgroundLeftContentInset = 0.0f;
static const CGFloat FORMPopoverBackgroundRightContentInset = 0.0f;
static const CGFloat FORMPopoverBackgroundTopContentInset = 0.0f;
static UIColor *FORMPopoverBackgroundTintColor = nil;
static UIImage *FORMPopoverBackgroundBackgroundImage = nil;
static UIImage *FORMPopoverBackgroundBottomArrowImage = nil;
static UIImage *FORMPopoverBackgroundLeftArrowImage = nil;
static UIImage *FORMPopoverBackgroundRightArrowImage = nil;
static UIImage *FORMPopoverBackgroundTopArrowImage = nil;

@interface FORMTooltipView ()

@property (nonatomic, retain) UIImageView *arrowImageView;
@property (nonatomic, retain) UIImageView *popoverBackgroundImageView;

@end

@implementation FORMTooltipView

@synthesize arrowOffset, arrowDirection;


+ (CGFloat)arrowBase {
    return FORMPopoverBackgroundArrowBase;
}

+ (CGFloat)arrowHeight {
    return FORMPopoverBackgroundArrowHeight;
}

+ (UIEdgeInsets)contentViewInsets {
    return UIEdgeInsetsMake(FORMPopoverBackgroundTopContentInset,
                            FORMPopoverBackgroundLeftContentInset,
                            FORMPopoverBackgroundBottomContentInset,
                            FORMPopoverBackgroundRightContentInset);
}

- (void)setArrowOffset:(CGFloat)_arrowOffset {
    arrowOffset = _arrowOffset;
    [self setNeedsLayout];
}

- (void)setArrowDirection:(UIPopoverArrowDirection)_arrowDirection {
    arrowDirection = _arrowDirection;
    [self setNeedsLayout];
}

+ (void)setBackgroundImageCornerRadius:(CGFloat)cornerRadius {
    FORMPopoverBackgroundCornerRadius = cornerRadius;
}

+ (void)setContentInset:(CGFloat)contentInset {
    FORMPopoverBackgroundContentInset = contentInset;
}

+ (void)setTintColor:(UIColor *)tintColor {
    FORMPopoverBackgroundTintColor = tintColor;
}

+ (void)setShadowEnabled:(BOOL)shadowEnabled {
    FORMPopoverBackgroundShadowEnabled = shadowEnabled;
}

+ (void)setArrowBase:(CGFloat)arrowBase {
    FORMPopoverBackgroundArrowBase = arrowBase;
}

+ (void)setArrowHeight:(CGFloat)arrowHeight {
    FORMPopoverBackgroundArrowHeight = arrowHeight;
}

+ (void)setBackgroundImage:(UIImage *)background
                       top:(UIImage *)top
                     right:(UIImage *)right
                    bottom:(UIImage *)bottom
                      left:(UIImage *)left {
    FORMPopoverBackgroundBackgroundImage = background;
    FORMPopoverBackgroundTopArrowImage = top;
    FORMPopoverBackgroundRightArrowImage = right;
    FORMPopoverBackgroundBottomArrowImage = bottom;
    FORMPopoverBackgroundLeftArrowImage = left;
}

+ (void)rebuildArrowImages {
    [FORMTooltipView buildArrows:FORMPopoverBackgroundTintColor];
}

+ (void)buildArrows:(UIColor *)tintColor {
    UIBezierPath *arrowPath;

    CGSize arrowSize = CGSizeMake(FORMPopoverBackgroundArrowBase,
                                  FORMPopoverBackgroundArrowHeight);

    UIGraphicsBeginImageContextWithOptions(arrowSize, NO, 0.0f);

    arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(FORMPopoverBackgroundArrowBase/2.0f, 0.0f)];
    [arrowPath addLineToPoint:CGPointMake(FORMPopoverBackgroundArrowBase, FORMPopoverBackgroundArrowHeight)];
    [arrowPath addLineToPoint:CGPointMake(0.0f, FORMPopoverBackgroundArrowHeight)];
    [arrowPath addLineToPoint:CGPointMake(FORMPopoverBackgroundArrowBase/2.0f, 0.0f)];

    [tintColor setFill];
    [arrowPath fill];

    FORMPopoverBackgroundTopArrowImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContextWithOptions(arrowSize, NO, 0.0f);

    arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(0.0f, 0.0f)];
    [arrowPath addLineToPoint:CGPointMake(FORMPopoverBackgroundArrowBase, 0.0f)];
    [arrowPath addLineToPoint:CGPointMake(FORMPopoverBackgroundArrowBase/2.0f, FORMPopoverBackgroundArrowHeight)];
    [arrowPath addLineToPoint:CGPointMake(0.0f, 0.0f)];

    [tintColor setFill];
    [arrowPath fill];

    FORMPopoverBackgroundBottomArrowImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContextWithOptions(arrowSize, NO, 0.0f);

    arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(FORMPopoverBackgroundArrowHeight, 0.0f)];
    [arrowPath addLineToPoint:CGPointMake(FORMPopoverBackgroundArrowHeight, FORMPopoverBackgroundArrowBase)];
    [arrowPath addLineToPoint:CGPointMake(0.0f, FORMPopoverBackgroundArrowBase/2.0f)];
    [arrowPath addLineToPoint:CGPointMake(FORMPopoverBackgroundArrowHeight, 0.0f)];

    [tintColor setFill];
    [arrowPath fill];

    FORMPopoverBackgroundLeftArrowImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContextWithOptions(arrowSize, NO, 0.0f);

    arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(0.0f, 0.0f)];
    [arrowPath addLineToPoint:CGPointMake(FORMPopoverBackgroundArrowHeight, FORMPopoverBackgroundArrowBase/2.0f)];
    [arrowPath addLineToPoint:CGPointMake(0.0f, FORMPopoverBackgroundArrowBase)];
    [arrowPath addLineToPoint:CGPointMake(0.0f, 0.0f)];

    [tintColor setFill];
    [arrowPath fill];

    FORMPopoverBackgroundRightArrowImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(FORMPopoverBackgroundImageSize, FORMPopoverBackgroundImageSize),
                                           NO,
                                           0.0f);

    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, FORMPopoverBackgroundImageSize, FORMPopoverBackgroundImageSize)
                                                          cornerRadius:FORMPopoverBackgroundCornerRadius];
    [tintColor setFill];
    [borderPath fill];


    CGFloat capInset = FORMPopoverBackgroundCornerRadius * 2;
    UIEdgeInsets capInsets = UIEdgeInsetsMake(capInset,
                                              capInset,
                                              capInset,
                                              capInset);

    FORMPopoverBackgroundBackgroundImage = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets:capInsets];

    UIGraphicsEndImageContext();
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [FORMTooltipView buildArrows:FORMPopoverBackgroundTintColor];

    _popoverBackgroundImageView = [[UIImageView alloc] initWithImage:FORMPopoverBackgroundBackgroundImage];
    [self addSubview:_popoverBackgroundImageView];

    _arrowImageView = [UIImageView new];
    [self addSubview:_arrowImageView];

    if (FORMPopoverBackgroundShadowEnabled) {
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

#pragma mark - Layout

- (void)layoutSubviews {
    CGFloat popoverImageOriginX = 0.0f;
    CGFloat popoverImageOriginY = 0.0f;
    CGFloat popoverImageWidth = self.bounds.size.width;
    CGFloat popoverImageHeight = self.bounds.size.height;
    CGFloat arrowImageOriginX = 0.0f;
    CGFloat arrowImageOriginY = 0.0f;
    CGFloat arrowImageWidth = FORMPopoverBackgroundArrowBase;
    CGFloat arrowImageHeight = FORMPopoverBackgroundArrowHeight;

    switch (self.arrowDirection) {
        case UIPopoverArrowDirectionUp: {
            popoverImageOriginY = FORMPopoverBackgroundArrowHeight;
            popoverImageHeight = self.bounds.size.height - FORMPopoverBackgroundArrowHeight;
            arrowImageOriginX = roundf((self.bounds.size.width - FORMPopoverBackgroundArrowBase) / 2.0f + self.arrowOffset);

            if ((arrowImageOriginX + FORMPopoverBackgroundArrowBase) > (self.bounds.size.width - FORMPopoverBackgroundCornerRadius)) {
                arrowImageOriginX -= FORMPopoverBackgroundCornerRadius;
            }

            if (arrowImageOriginX < FORMPopoverBackgroundCornerRadius) {
                arrowImageOriginX += FORMPopoverBackgroundCornerRadius;
            }

            self.arrowImageView.image = FORMPopoverBackgroundTopArrowImage;

        } break;

        case UIPopoverArrowDirectionDown: {
            popoverImageHeight = self.bounds.size.height - FORMPopoverBackgroundArrowHeight;
            arrowImageOriginX = roundf((self.bounds.size.width - FORMPopoverBackgroundArrowBase) / 2.0f + self.arrowOffset);

            if ((arrowImageOriginX + FORMPopoverBackgroundArrowBase) > (self.bounds.size.width - FORMPopoverBackgroundCornerRadius)) {
                arrowImageOriginX -= FORMPopoverBackgroundCornerRadius;
            }

            if (arrowImageOriginX < FORMPopoverBackgroundCornerRadius) {
                arrowImageOriginX += FORMPopoverBackgroundCornerRadius;
            }

            arrowImageOriginY = popoverImageHeight;

            self.arrowImageView.image = FORMPopoverBackgroundBottomArrowImage;

        } break;

        case UIPopoverArrowDirectionLeft: {

            popoverImageOriginX = FORMPopoverBackgroundArrowHeight;
            popoverImageWidth = self.bounds.size.width - FORMPopoverBackgroundArrowHeight;

            arrowImageOriginY = roundf((self.bounds.size.height - FORMPopoverBackgroundArrowBase) / 2.0f + self.arrowOffset);

            if ((arrowImageOriginY + FORMPopoverBackgroundArrowBase) > (self.bounds.size.height - FORMPopoverBackgroundCornerRadius)) {
                arrowImageOriginY -= FORMPopoverBackgroundCornerRadius;
            }

            if (arrowImageOriginY < FORMPopoverBackgroundCornerRadius) {
                arrowImageOriginY += FORMPopoverBackgroundCornerRadius;
            }

            arrowImageWidth = FORMPopoverBackgroundArrowHeight;
            arrowImageHeight = FORMPopoverBackgroundArrowBase;

            self.arrowImageView.image = FORMPopoverBackgroundLeftArrowImage;

        } break;

        case UIPopoverArrowDirectionRight: {
            popoverImageWidth = self.bounds.size.width - FORMPopoverBackgroundArrowHeight;

            arrowImageOriginX = popoverImageWidth;
            arrowImageOriginY = roundf((self.bounds.size.height - FORMPopoverBackgroundArrowBase) / 2.0f + self.arrowOffset);

            if ((arrowImageOriginY + FORMPopoverBackgroundArrowBase) > (self.bounds.size.height - FORMPopoverBackgroundCornerRadius)) {
                arrowImageOriginY -= FORMPopoverBackgroundCornerRadius;
            }

            if (arrowImageOriginY < FORMPopoverBackgroundCornerRadius) {
                arrowImageOriginY += FORMPopoverBackgroundCornerRadius;
            }

            arrowImageWidth = FORMPopoverBackgroundArrowHeight;
            arrowImageHeight = FORMPopoverBackgroundArrowBase;

            self.arrowImageView.image = FORMPopoverBackgroundRightArrowImage;

        } break;
        case UIPopoverArrowDirectionAny:
        case UIPopoverArrowDirectionUnknown:
            break;
    }

    self.popoverBackgroundImageView.frame = CGRectMake(popoverImageOriginX, popoverImageOriginY, popoverImageWidth, popoverImageHeight);
    self.arrowImageView.frame = CGRectMake(arrowImageOriginX, arrowImageOriginY, arrowImageWidth, arrowImageHeight);
}

@end

