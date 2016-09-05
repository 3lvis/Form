#import "FORMSpacerFieldCell.h"
@import Hex;

@interface FORMSpacerFieldCell ()

@end

@implementation FORMSpacerFieldCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.headingLabel.hidden = YES;

    return self;
}

#pragma mark - FORMBaseFormFieldCell

- (void)updateWithField:(FORMField *)field {
    [super updateWithField:field];

    self.headingLabel.hidden = YES;
}

@end
