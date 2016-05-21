//
//  APPSPasscodeViewConfiguration.m
//  APPSPasscode
//
//  Created by Ken Grigsby on 12/31/15.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import "APPSPasscodeViewConfiguration.h"
#import "APPSNumericKeypadView.h"

@implementation APPSPasscodeViewConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        _buttonSpacing = CGSizeMake([APPSNumericKeypadView hairlineThickness], [APPSNumericKeypadView hairlineThickness]);
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    APPSPasscodeViewConfiguration *copy = [self.class new];
    copy.rootViewBackgroundColor         = self.rootViewBackgroundColor;
    copy.messageContainerBackgroundColor = self.messageContainerBackgroundColor;
    copy.keypadBackgroundColor           = self.keypadBackgroundColor;
    copy.keypadNumericKeyDefaultColor    = self.keypadNumericKeyDefaultColor;
    copy.keypadNumericKeyHighlightColor  = self.keypadNumericKeyHighlightColor;
    copy.keypadTextColor                 = self.keypadTextColor;
    copy.instructionTextColor            = self.instructionTextColor;
    copy.errorTextColor                  = self.errorTextColor;
    copy.deleteKeyImage                  = self.deleteKeyImage;
    copy.bulletColor                     = self.bulletColor;
    copy.buttonSpacing                   = self.buttonSpacing;
    copy.topToLogoSpacing                = self.topToLogoSpacing;
    copy.logoToInstructionLabelSpacing   = self.logoToInstructionLabelSpacing;
    copy.logoImage                       = self.logoImage;
    copy.customKeyColors                 = self.customKeyColors;

    return copy;
}
@end
