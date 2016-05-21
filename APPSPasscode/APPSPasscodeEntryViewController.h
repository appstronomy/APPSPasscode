//
//  APPSPasscodeEntryViewController.h
//  APPSPasscode
//
//  Created by Chris Morris on 7/23/14.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "APPSPasscodeViewController.h"
#import "APPSPasscodeViewControllerDelegate.h"
#import "APPSPasscodeEntryViewControllerDelegate.h"


/**
 This class is not intended for public consumption. It is intended
 to be used by the wrapper controller, @c APPSPasscodeViewController.
 
 This class does the heavy lifting of gathering passcode information from
 the user.
 */
@interface APPSPasscodeEntryViewController : UIViewController

/**
 All communication will be done through the delegate.
 */
@property (weak, nonatomic) id<APPSPasscodeEntryViewControllerDelegate> delegate;

/**
 If this is not set, the behavior is undefined.
 */
@property (assign, nonatomic) APPSPasscodeMode passcodeMode;

/**
 The view configuration for the new view controller
 */
@property (copy, nonatomic) APPSPasscodeViewConfiguration *viewConfiguration;

@end

