//
//  APPSPasscodeService.m
//  APPSPasscode
//
//  Created by Sohail Ahmed on 11/20/15.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "APPSPasscodeService.h"
#import "APPSFormSheetTransition.h"


@implementation APPSPasscodeService

#pragma mark - Property Overrides

- (UIViewController<APPSPasscodePresenter> * )rootViewController;
{
    NSAssert(self.window, @"A window has not yet been set on the '%@' class.", [self description]);
    NSAssert([self.window.rootViewController conformsToProtocol:@protocol(APPSPasscodePresenter)],
               @"The current rootViewController class '%@' does not conform to the APPSPasscodePresenter protocol.",
               [self.window.rootViewController description]);
    
    UIViewController<APPSPasscodePresenter> *rootViewController;
    
    rootViewController = (UIViewController<APPSPasscodePresenter> *)self.window.rootViewController;
    
    return rootViewController;
}



#pragma mark - APPSPasscodeViewControllerDelegate

- (BOOL)passcodeViewController:(APPSPasscodeViewController *)passcodeViewController
         willAuthorizePasscode:(NSString *)passcode
{
    NSAssert(NO, @"You must implement -passcodeViewController:willAuthorizePasscode: "
                  "in a subclass to return YES or NO based on the passcode provided.");
    return NO;
}


- (void)passcodeViewController:(APPSPasscodeViewController *)passcodeViewController
    didFailToAuthorizePasscode:(NSString *)passcode
            failedAttemptCount:(NSUInteger)failedAttemptCount
{
    // NOTE: The current gameplan is to not do anything if the MAX tries is reached.
    // You may wish to implement this method in your subclass in order to do something
    // concrete, such as lock the user out of the app for a time, or wipe data.
}


- (void)passcodeViewController:(APPSPasscodeViewController *)passcodeViewController
          didAuthorizePasscode:(NSString *)passcode
{
    NSAssert(NO,   @"You must implement this method in a subclass, presumably to dismiss "
                    "the presented passcode view controller.");
}



#pragma mark - Protocol: UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    APPSFormSheetTransition *transition = [[APPSFormSheetTransition alloc] init];
    transition.presenting = YES;
    return transition;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    APPSFormSheetTransition *transition = [[APPSFormSheetTransition alloc] init];
    transition.presenting = NO;
    return transition;
}


- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source
{
    // You may use a different presentation controller by overriding this delegate method in your
    // own APPSPasscodeService subclass.
    return [[UIPresentationController alloc] initWithPresentedViewController:presented
                                                    presentingViewController:presenting];
}


@end
