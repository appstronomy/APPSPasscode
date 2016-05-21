//
//  APPSPasscodeEntryViewControllerDelegate.h
//  APPSPasscode
//
//  Created by Sohail Ahmed on 11/20/15.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APPSPasscodeEntryViewController;


/**
 These are all required because the only user of this class should be the
 APPSPasscodeViewController, and that class must implement all of these
 methods.  Certainly, the user facing delegate protocol by the
 APPSPasscodeViewController should include optional methods.  For details
 about the behavior of each of these methods, be sure to read the parallel
 protocol defined in APPSPasscodeViewController.
 */
@protocol APPSPasscodeEntryViewControllerDelegate <NSObject>

/**
 The delegate will indicate whether or not the "Cancel" button in the navigation
 bar will be presented.  In the case where we are authorizing to get into
 an app, the cancel option may not make any sense.
 
 @param passcodeViewController The object doing the delegating.
 
 @return YES if the "Cancel" button should be displayed, NO otherwise.
 */
- (BOOL)passcodeEntryViewControllerCanCancel:(APPSPasscodeEntryViewController *)passcodeEntryViewController;

/**
 Indicates that the user wanted to cancel their interaction with the view
 controller.  Most likely the delegate will dismiss the presented
 view controller upon receiving this message.
 
 @param passcodeEntryViewController The object doing the delegating.
 */
- (void)passcodeEntryViewControllerDidCancel:(APPSPasscodeEntryViewController *)passcodeEntryViewController;

/**
 The delegate will indicate whether or not the user's passcode entry was a match
 with the current passcode on file by returning YES or NO.
 
 @param passcodeEntryViewController The object doing the delegating.
 @param passcode The passcode that the user entered.
 
 @return YES to indicate that the passcode entered is a match.  NO otherwise.
 */
- (BOOL)passcodeEntryViewController:(APPSPasscodeEntryViewController *)passcodeEntryViewController
              willAuthorizePasscode:(NSString *)passcode;

/**
 The user entered an authorized passcode.  The delegate may wish to dismiss
 the view controller after this.
 
 @param passcodeEntryViewController The object doing the delegating.
 @param passcode The passcode that the user entered that was authorized.
 */
- (void)passcodeEntryViewController:(APPSPasscodeEntryViewController *)passcodeEntryViewController
               didAuthorizePasscode:(NSString *)passcode;

/**
 If the presenting controller wishes to only allow a certain number of failed
 authorization attempts, this method can be used to dismiss the view controller
 when the threshold has been met.
 
 @param passcodeEntryViewController The object doing the delegating.
 @param passcode The passcode that the user entered that was rejected.
 @param failedAttemptCount The number of times the user has failed to enter an
 authorized passcode.
 */
- (void)passcodeEntryViewController:(APPSPasscodeEntryViewController *)passcodeEntryViewController
         didFailToAuthorizePasscode:(NSString *)passcode
                 failedAttemptCount:(NSUInteger)failedAttemptCount;

/**
 This delegate can accept/reject passcodes using this method.  This might be of
 interest here in order to disallow the new passcode to match the previous
 passcode.  Additionally, could disallow passcodes like "1111" or "1234" for
 example.  If the delegate returns NO, it is expected that the errorMessage
 out-param will contain the message which should be presented to the user.
 
 @param passcodeEntryViewController The object doing the delegating.
 @param fromPasscode The user's original passcode which has already been authorized,
 or nil if the user is setting up a passcode for the first time.
 @param toPasscode The user's proposed new passcode, which the delegate can choose
 to accept/reject by returning YES/NO.
 @param errorMessage An out-param that must be set by the delegate if NO is returned.
 
 @return YES or NO, depending on whether the delegate wants to approve or reject
 the new passcode.  If NO is returned, the errorMessage param must be
 set to a non-nil value.
 */
- (BOOL)passcodeEntryViewController:(APPSPasscodeEntryViewController *)passcodeEntryViewController
             willUpdateFromPasscode:(NSString *)fromPasscode
                         toPasscode:(NSString *)toPasscode
                       errorMessage:(NSString *__autoreleasing *)errorMessage;

/**
 Upon successfully creating a new passcode, or updating an existing passcode, the
 delegate will send this message.  At a minimum, the delegate should dismiss the
 presented view controller from this method.  But, most likely, the delegate
 will also want to capture the user's newly created/updated passcode.
 
 @param passcodeEntryViewController The object doing the delegating.
 @param fromPasscode The user's original passcode which has already been authorized,
 or nil if the user is setting up a passcode for the first time.
 @param toPasscode The user's new/updated passcode.  This should be captured
 by the delegate.
 */
- (void)passcodeEntryViewController:(APPSPasscodeEntryViewController *)passcodeEntryViewController
              didUpdateFromPasscode:(NSString *)fromPasscode
                         toPasscode:(NSString *)toPasscode;

@end