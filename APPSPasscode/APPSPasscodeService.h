//
//  APPSPasscodeService.h
//  APPSPasscode
//
//  Created by Sohail Ahmed on 11/20/15.
//  Copyright (c) 2014 Appstronomy. All rights reserved.

#import <Foundation/Foundation.h>
#import "APPSPasscodePresenter.h"
#import "APPSPasscodeViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Responsible for asking the app's root view controller to present or 
 dismiss a Passcode View Controller. Listens for app lifecycle events
 such as the app becoming active or going into the background.
 
 Most apps will want to subclass this to fine tune behaviors.
 */
@interface APPSPasscodeService : NSObject
    <APPSPasscodeViewControllerDelegate,
    UIViewControllerTransitioningDelegate>

#pragma mark weak

/**
 This must be set in order for the Passcode Service to work. It is from the
 window that we'll retrieve the @c rootViewController.
 */
@property (weak, nonatomic) UIWindow *window;

/**
 This is the view controller that is currently the root view controller of your app.
 Any view controller that may find itself in this role, must implement the protocol
 @c APPSPasscodePresenter in order for this service to work with it correctly.
 
 We'll set this once you have our @c window property set.
 */
@property (weak, nonatomic, readonly) id<APPSPasscodePresenter> rootViewController;


@end

NS_ASSUME_NONNULL_END
