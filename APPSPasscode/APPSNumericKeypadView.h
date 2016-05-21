//
//  APPSNumericKeypadView.h
//  APPSPasscode
//
//  Created by Chris Morris on 7/22/14.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPSPasscodeEnums.h"

@protocol APPSNumericKeypadViewDelegate;


/**
 This view currently only supports 320 x 216.
 
 This was done because the goal was to replicate the existing decimal keypad.
 Unfortunately, that keypad did not divide the available space equally, but
 instead had some custom dimensions. For example, the middle column is wider
 than the left/right columns.
 */
IB_DESIGNABLE
@interface APPSNumericKeypadView : UIView

/**
 Returns the thickness in points of a single pixel line. Useful
 for drawing separator lines.
 
 @return The thickness in points of a single pixel line.
 */
+ (CGFloat)hairlineThickness;

/**
 All communication regarding keys tapped will be sent via the delegate
 protocol.
 */
@property (weak, nonatomic) IBOutlet id<APPSNumericKeypadViewDelegate> delegate;

/**
 Exposes the last key that was tapped successfully.
 */
@property (readonly, nonatomic) APPSNumericKeypadKey lastKey;

/**
 Simple helper to determine if the key is a numeric key.
 */
+ (BOOL)isKeyNumeric:(APPSNumericKeypadKey)key;

/**
 Button background color
 */
@property (strong, nonatomic) UIColor *defaultColorForNumericKey;

/**
 Button color when pressed
 */
@property (strong, nonatomic) UIColor *highlightColorForNumericKey;

/**
 View background color
 */
@property (strong, nonatomic) UIColor *backdropColor;

/**
 Button text color
 */
@property (strong, nonatomic) UIColor *textColor;


/**
 Image for delete key
 */
@property (strong, nonatomic) UIImage *deleteKeyImage;


/**
 Spacing between buttons. Defaults to hairline thickness.
 */
@property (nonatomic) CGSize buttonSpacing;

/**
 Overrides keypadNumericKeyDefaultColor for specific keypad buttons.
 The keys are of type APPSNumericKeypadKey from APPSPasscodeEnums.h.
 Any keys not specified will use keypadNumericKeyDefaultColor.
 */
@property (nonatomic, copy) NSDictionary<NSNumber*, UIColor*> *customKeyColors;


@end


/**
 Notifies the delegate when a key is tapped.
 */
@protocol APPSNumericKeypadViewDelegate <NSObject>

/**
 A key has been tapped.  The key will not be APPSNumericKeypadKeyInvalid.
 
 @param numericKeypadView The view doing the delegating.
 @param tappedKey The key that was tapped.
 */
- (void)numericKeypadView:(APPSNumericKeypadView *)numericKeypadView
                didTapKey:(APPSNumericKeypadKey)tappedKey;

@end
