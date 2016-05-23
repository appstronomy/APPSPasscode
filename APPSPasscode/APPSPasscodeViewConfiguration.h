//
//  APPSPasscodeViewConfiguration.h
//  APPSPasscode
//
//  Created by Ken Grigsby on 12/31/15.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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

@property (nullable, nonatomic, strong) UIColor *rootViewBackgroundColor;

@property (nullable, nonatomic, strong) UIColor *messageContainerBackgroundColor;

@property (nullable, nonatomic, strong) UIColor *keypadBackgroundColor;

@property (nullable, nonatomic, strong) UIColor *keypadNumericKeyDefaultColor;

@property (nullable, nonatomic, strong) UIColor *keypadNumericKeyHighlightColor;

@property (nullable, nonatomic, strong) UIColor *keypadTextColor;

@property (nullable, nonatomic, strong) UIColor *instructionTextColor;

@property (nullable, nonatomic, strong) UIColor *errorTextColor;

@property (nullable, nonatomic, strong) UIColor *bulletColor;

@property (nullable, nonatomic, strong) UIImage *deleteKeyImage;

@property (nullable, nonatomic, strong) UIImage *logoImage;

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
@property (nullable, nonatomic, copy) NSDictionary<NSNumber*, UIColor*> *customKeyColors;

@end

NS_ASSUME_NONNULL_END

