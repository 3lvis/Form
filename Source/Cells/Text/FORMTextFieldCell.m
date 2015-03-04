#import "FORMTextFieldCell.h"

#import "FORMSubtitleView.h"

static const CGFloat FORMSubtitleViewMinimumWidth = 90.0f;
static const CGFloat FORMSubtitleViewHeight = 44.0f;
static const NSInteger FORMSubtitleNumberOfLines = 4;

@interface FORMTextFieldCell () <FORMTextFieldDelegate>

@property (nonatomic, strong) FORMTextField *textField;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) FORMSubtitleView *subtitleView;

@end

@implementation FORMTextFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.textField];

    if ([self respondsToSelector:@selector(resignFirstResponder)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignFirstResponder) name:FORMResignFirstResponderNotification object:nil];
    }

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapAction)];
    [self addGestureRecognizer:tapGestureRecognizer];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FORMResignFirstResponderNotification object:nil];
}

#pragma mark - Getters

- (FORMTextField *)textField
{
    if (_textField) return _textField;

    _textField = [[FORMTextField alloc] initWithFrame:[self textFieldFrame]];
    _textField.textFieldDelegate = self;

    return _textField;
}

- (CGRect)labelFrameUsingString:(NSString *)string
{
    NSArray *components = [string componentsSeparatedByString:@"\n"];

    CGFloat width;

    if (components.count > 1) {
        NSString *longestLine;
        for (NSString *line in components) {
            if (longestLine) {
                if (line.length > longestLine.length) {
                    longestLine = line;
                }
            } else {
                longestLine = line;
            }
        }
        width = 8.0f * longestLine.length;
    } else {
        width = 8.0f * string.length;
    }

    if (width < FORMSubtitleViewMinimumWidth) width = FORMSubtitleViewMinimumWidth;

    CGFloat height = FORMSubtitleViewHeight;
    height += 11.0f * components.count;

    return CGRectMake(0, 0, width, height);
}

- (CGRect)subtitleViewFrame
{
    CGRect frame = [self labelFrameUsingString:self.field.subtitle];

    frame.size.height += [FORMSubtitleView arrowHeight];
    frame.origin.x = self.textField.frame.origin.x;
    frame.origin.y = self.textField.frame.origin.y;

    frame.origin.x += self.textField.frame.size.width / 2 - frame.size.width / 2;

    if ([self.field.sectionPosition isEqualToNumber:@0]) {
        self.subtitleView.arrowDirection = UIPopoverArrowDirectionUp;
        frame.origin.y += self.textField.frame.size.height / 2;
    } else {
        self.subtitleView.arrowDirection = UIPopoverArrowDirectionDown;
        frame.origin.y -= self.textField.frame.size.height / 2;
        frame.origin.y -= frame.size.height;
    }

    frame.origin.y += [FORMSubtitleView arrowHeight];

    return frame;
}

- (FORMSubtitleView *)subtitleView
{
    if (_subtitleView) return _subtitleView;

    [FORMSubtitleView setTintColor:[UIColor colorWithRed:0.992 green:0.918 blue:0.329 alpha:1]];
    _subtitleView = [FORMSubtitleView new];
    [_subtitleView addSubview:self.subtitleLabel];

    return _subtitleView;
}

- (CGRect)subtitleLabelFrame
{
    CGRect frame = [self labelFrameUsingString:self.field.subtitle];

    if (self.subtitleView.arrowDirection == UIPopoverArrowDirectionUp) {
        frame.origin.y += [FORMSubtitleView arrowHeight];
    }

    return frame;
}

- (UILabel *)subtitleLabel
{
    if (_subtitleLabel) return _subtitleLabel;

    _subtitleLabel = [[UILabel alloc] initWithFrame:[self labelFrameUsingString:@""]];

    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _subtitleLabel.numberOfLines = FORMSubtitleNumberOfLines;

    return _subtitleLabel;
}

#pragma mark - Private headers

- (BOOL)resignFirstResponder
{
    [self.textField resignFirstResponder];

    [self.subtitleView removeFromSuperview];

    return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    [self.textField becomeFirstResponder];

    return [super becomeFirstResponder];
}

#pragma mark - FORMBaseFormFieldCell

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.textField.enabled = !disabled;
}

- (void)updateWithField:(FORMField *)field
{
    [super updateWithField:field];

    self.textField.hidden          = (field.sectionSeparator);
    self.textField.inputValidator  = [self.field inputValidator];
    self.textField.formatter       = [self.field formatter];
    self.textField.typeString      = field.typeString;
    self.textField.enabled         = !field.disabled;
    self.textField.valid           = field.valid;
    self.textField.rawText         = [self rawTextForField:field];
}

- (void)validate
{
    BOOL validation = ([self.field validate] == FORMValidationResultTypePassed);
    [self.textField setValid:validation];
}

#pragma mark - Private methods

- (NSString *)rawTextForField:(FORMField *)field
{
    if (field.fieldValue && field.type == FORMFieldTypeFloat) {

        NSNumber *value = field.fieldValue;

        if ([field.fieldValue isKindOfClass:[NSString class]]) {
            NSMutableString *fieldValue = [field.fieldValue mutableCopy];
            [fieldValue replaceOccurrencesOfString:@","
                                        withString:@"."
                                           options:NSCaseInsensitiveSearch
                                             range:NSMakeRange(0, [fieldValue length])];
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
            value = [formatter numberFromString:fieldValue];
        }

        return [NSString stringWithFormat:@"%.2f", [value doubleValue]];
    }

    return field.fieldValue;
}

#pragma mark - Actions

- (void)cellTapAction
{
    BOOL shouldDisplaySubtitle = (self.field.type == FORMFieldTypeText && self.field.subtitle);
    if (shouldDisplaySubtitle) {
        [self showSubtitle];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:FORMResignFirstResponderNotification object:nil];
    }
}

- (void)focusAction
{
    [self.textField becomeFirstResponder];
}

- (void)clearAction
{
    self.field.fieldValue = nil;
    [self updateWithField:self.field];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textField.frame = [self textFieldFrame];
}

- (CGRect)textFieldFrame
{
    CGFloat marginX = FORMTextFieldCellMarginX;
    CGFloat marginTop = FORMFieldCellMarginTop;
    CGFloat marginBotton = FORMFieldCellMarginBottom;

    CGFloat width  = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = CGRectGetHeight(self.frame) - marginTop - marginBotton;
    CGRect  frame  = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

- (void)showSubtitle
{
    if (self.field.subtitle) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FORMResignFirstResponderNotification object:nil];

        [self.contentView addSubview:self.subtitleView];
        self.subtitleView.frame = [self subtitleViewFrame];
        self.subtitleLabel.frame = [self subtitleLabelFrame];
        [self.superview bringSubviewToFront:self];

        CGRect subtitleViewFrame = self.subtitleView.frame;

        if (self.subtitleView.frame.origin.x < 0) {
            self.subtitleView.arrowOffset = subtitleViewFrame.origin.x;
            subtitleViewFrame.origin.x = 0;
        }

        CGFloat windowWidth = self.window.frame.size.width;
        BOOL isOutOfBounds = ((subtitleViewFrame.size.width + self.frame.origin.x) > windowWidth);
        if (isOutOfBounds) {
            subtitleViewFrame.origin.x = windowWidth;
            subtitleViewFrame.origin.x -= subtitleViewFrame.size.width;
            subtitleViewFrame.origin.x -= self.frame.origin.x;

            self.subtitleView.arrowOffset = subtitleViewFrame.size.width / 2;
            self.subtitleView.arrowOffset -= self.textField.frame.size.width / 2;
            self.subtitleView.arrowOffset -= 39.0f;
        }

        self.subtitleView.frame = subtitleViewFrame;

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.field.subtitle];
        NSMutableParagraphStyle *paragrahStyle = [NSMutableParagraphStyle new];
        paragrahStyle.alignment = NSTextAlignmentCenter;
        paragrahStyle.lineSpacing = 8;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, self.field.subtitle.length)];

        self.subtitleLabel.attributedText = attributedString;
    }
}

#pragma mark - FORMTextFieldDelegate

- (void)textFormFieldDidBeginEditing:(FORMTextField *)textField
{
    [self showSubtitle];
}

- (void)textFormFieldDidEndEditing:(FORMTextField *)textField
{
    [self validate];

    if (!self.textField.valid) {
        [self.textField setValid:[self.field validate]];
    }

    [self.subtitleView removeFromSuperview];
}

- (void)textFormField:(FORMTextField *)textField didUpdateWithText:(NSString *)text
{
    self.field.fieldValue = text;
    [self validate];

    if (!self.textField.valid) {
        [self.textField setValid:[self.field validate]];
    }

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

#pragma mark - Styling

- (void)setSubtitleLabelFont:(UIFont *)subtitleLabelFont
{
    self.subtitleLabel.font = subtitleLabelFont;
}

- (void)setSubtitleLabelTextColor:(UIColor *)subtitleLabelTextColor
{
    self.subtitleLabel.textColor = subtitleLabelTextColor;
}

@end
