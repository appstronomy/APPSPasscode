//
//  APPSPasscodeViewConfiguration.h
//  APPSPasscode
//
//  Created by Ken Grigsby on 12/31/15.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 An instance of @c APPSPasscodeViewConfiguration is used to hold visual
 and behavioral settings for the passcode keypad.
 
 Default colours exist if you don't set anything with this object
 for consumption by the passcode controller.
 
 The final key color is determined by the following chart:

 Normal state
 Numeric Key  = root + keypadBackground + default
 Delete Key   = root + keypadBackground
 Bottom Left  = root + keypadBackground

 Highlight state
 Numeric Key  = root + keypadBackground + highlight
 Delete Key   = root + keypadBackground + default
*/

@interface APPSPasscodeViewConfiguration : NSObject <NSCopying>

@property (nonatomic, strong) UIColor *rootViewBackgroundColor;

@property (nonatomic, strong) UIColor *messageContainerBackgroundColor;

@property (nonatomic, strong) UIColor *keypadBackgroundColor;

@property (nonatomic, strong) UIColor *keypadNumericKeyDefaultColor;

@property (nonatomic, strong) UIColor *keypadNumericKeyHighlightColor;

@property (nonatomic, strong) UIColor *keypadTextColor;

@property (nonatomic, strong) UIColor *instructionTextColor;

@property (nonatomic, strong) UIColor *errorTextColor;

@property (nonatomic, strong) UIColor *bulletColor;

@property (nonatomic, strong) UIImage *deleteKeyImage;

@property (nonatomic, strong) UIImage *logoImage;

@property (nonatomic) CGFloat topToLogoSpacing;

@property (nonatomic) CGFloat logoToInstructionLabelSpacing;

/**
 Spacing between buttons. Defaults to hairline thickness.
 */
@property (nonatomic) CGSize buttonSpacing;


/**
 Overrides keypadNumericKeyDefaultColor for specific keypad buttons.
 The keys are of type @c APPSNumericKeypadKey from @c APPSPasscodeEnums.h.
 Any keys not specified will use keypadNumericKeyDefaultColor.
 */
@property (nonatomic, copy) NSDictionary<NSNumber*, UIColor*> *customKeyColors;

@end

