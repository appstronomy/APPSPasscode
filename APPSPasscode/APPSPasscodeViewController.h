//
//  APPSPasscodeViewController.h
//  APPSPasscode
//
//  Created by Chris Morris on 7/22/14.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "APPSPasscodeViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Different modes for the passcode view controller.  The mode will determine
 how the view controller functions.
 */
typedef NS_ENUM(NSUInteger, APPSPasscodeMode) {
    APPSPasscodeModeNew,
    APPSPasscodeModeUpdate,
    APPSPasscodeModeAuthorize
};


/**
 This view controller will present an interactive passcode view.  It can
 setup a new passcode, change an existing passcode, or authorize a user.  It is
 critical to note that this view controller does nothing with regards to
 persisting any passcodes.  All of the persistence and even authorization is
 left up to the delegate.  Consider this view controller to be dumb, delegating
 to the delegate if there is anything interesting to consider.

 This view controller should be presented modally.  It will be presented
 appropriately for the iPhone and iPad.  The modalPresentationStyle should
 not be modified, as it is used internally to present appropriately. (NOTE: This
 could be enforced if we wanted to ... not sure if it adds value.)
 
 The goal of this view controller is to mimic the behavior offered by the 
 passcode screens inside of iOS.  Unfortunately, we do not have access to those
 screens.
 
 After presenting this view controller, all interaction with it should be done
 via the delegate methods.
 
 This class is the only class that should be used by the public.  The other
 classes included along with this one are used by this class, but should not
 be used by others.
 
 
 Current Limitations:

 - Only portrait mode is currently supported.
 - The dimensions when presented on iPad are fixed at 320 x 480. (This is
   currently the same as the system one ... but if different devices come out
   where this value should be changed, that work would need to be done.)
 - The keypad is drawn with the size of 320 x 216 expected.  If there is a size
   larger than this, it will scale up, but the text does not scale.  A smaller
   size will not scale well since the text size is fixed.  (This is part of the
   work that would need to be done to support landscape.)  The 320 x 216 size
   is the size for an inputView in iOS today.
 - If a larger screen iPhone were to come out, it "should" scale up to the
   larger size in a reasonable fashion, but it will not look the same as the
   system keypad.
 - There may be some slight color, timing and alignment issues that could be
   fine tuned, but in general, it is a pretty close replica of the system
   dialog.

 */

@class APPSPasscodeViewConfiguration;



@interface APPSPasscodeViewController : UIViewController

/**
 This must be set before presenting the view controller.  This is the way
 the view controller will communicate what is happening to the presenting
 view controller.
 */
@property (weak, nonatomic) id<APPSPasscodeViewControllerDelegate> delegate;

/**
 This must be set to one of the valid modes.  This determines how the
 view controller will behave.
 */
@property (assign, nonatomic) APPSPasscodeMode passcodeMode;

/**
 The view configuration for the new view controller
 */
@property (nullable, copy, nonatomic) APPSPasscodeViewConfiguration *viewConfiguration;


@end

NS_ASSUME_NONNULL_END

