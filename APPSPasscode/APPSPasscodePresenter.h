//
//  APPSPasscodePresenter.h
//  APPSPasscode
//
//  Created by Sohail Ahmed on 11/19/15.
//  Copyright (c) 2014 Appstronomy. All rights reserved.

#import <Foundation/Foundation.h>

@class APPSPasscodeViewController;
@class APPSPasscodeService;

/**
 This protocol is for any view controller to implement that may be responsible for being
 asked to present the Passcode View Controller. 
 
 Classes that normally instruct such view controllers to present the Passcode View Controller,
 can first check if there is a view controller already being presented modally, and even register
 a callback for when such are dismissed.
 */
@protocol APPSPasscodePresenter <NSObject>

@required

- (BOOL)passcodeService:(APPSPasscodeService *)passcodeService
        didRequestPasscodeControllerPresentation:(APPSPasscodeViewController *)passcodeViewController;

- (BOOL)passcodeService:(APPSPasscodeService *)passcodeService
        didRequestPasscodeControllerDismissalAnimated:(BOOL)animated;

@end
