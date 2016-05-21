//
//  APPSPasscodeViewControllerDelegate.h
//  APPSPasscode
//
//  Created by Sohail Ahmed on 11/20/15.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APPSPasscodeViewController;


/**
 An @c APPSPascodeViewController communicates to the interested party via this
 delegate protocol. There are no required methods, but certainly in order
 for this to offer any utility, some subset of the optional methods must
 be implemented in order for anything useful to transpire.
 
 The following is a list of the expectations of the delegate based on the
 @c APPSPasscodeMode set.
 
 === APPSPasscodeModeNew ===
 -didCancel:
 Dismiss the modal view controller.
 
 -willUpdateFromPasscode:to:errorMessage:
 This may be implemented if the user wants to allow/disallow certain
 passcodes.
 
 -didUpdateFromPasscode:to:
 This must be implemented to, at a minimum, dismiss the passcode
 view controller. More than likely, the delegate will want to do
 something with the new passcode, such as store it somewhere secure.
 
 
 === APPSPasscodeModeUpdate ===
 didCancel:
 Dismiss the modal view controller.
 
 -willAuthorizePasscode:
 This must be implemented in order to authorize the old passcode before
 the user is allowed to change to the new passcode.
 
 -didFailToAuthorizePasscode:failedAttemptCount:
 This may be desirable to implement if after a certain number of
 attempts the passcode view controller should be dimissed.
 
 -willUpdateFromPasscode:to:errorMessage:
 This may be implemented if the user wants to allow/disallow certain
 passcodes. This might be of interest here in order to disallow
 the new passcode from matching the previous passcode.
 
 -didUpdateFromPasscode:to:
 This must be implemented to, at a minimum, dismiss the passcode
 view controller. More than likely, the delegate will want to do
 something with the new passcode, such as store it somewhere secure.

 
 === APPSPasscodeModeAuthorize ===
 -willAuthorizePasscode:
 This must be implemented in order to authorize the user's passcode. It
 is completely up to the delegate to determine if there is a match.
 
 -didAuthorizePasscode:
 This must be implemented. Not only will this indicate that the
 passcode was successfully authorized, but additionally, this is the
 hook where the presenting view controller should dismiss this
 passcode view controller.
 
 -didFailToAuthorizePasscode:failedAttemptCount:
 This may be desirable to implement if after a certain number of
 attempts the passcode view controller should be dimissed, perhaps
 followed by a lockout period to frustrate brute-force attacks.
 */
@protocol APPSPasscodeViewControllerDelegate <NSObject>

@optional

/**
 The delegate will indicate whether or not the "Cancel" button in the navigation
 bar will be presented.  
 
 In the case where we are authorizing to get into an app, the cancel option may 
 not make any sense. This method will only be called in the case that the
 passcodeViewControllerDidCancel: method is implemented by the delegate.  
 
 If that method is not implemented, the button will not be displayed.  
 If that method is implemented, then this method will be
 consulted to indicate whether or not the button should be displayed.  
 If this method is not implemented then @c YES is the assumed response.
 
 @param passcodeViewController The object doing the delegating.
 
 @return YES if the "Cancel" button should be displayed, NO otherwise. 
         YES is the default value.
 */
- (BOOL)passcodeViewControllerCanCancel:(APPSPasscodeViewController *)passcodeViewController;


/**
 Indicates that the user wanted to cancel their interaction with the view
 controller.  
 
 It is expected that the delegate will dismiss the presented view controller
 upon receiving this message. If this method is not implemented
 by the delegate, then the "Cancel" button will not be presented. If this
 method is implemented, then whether or not to display the "Cancel" button
 will be determined by the passcodeViewControllerCanCancel: delegate method.
 
 @param passcodeViewController  The object doing the delegating.
 */
- (void)passcodeViewControllerDidCancel:(APPSPasscodeViewController *)passcodeViewController;


/**
 The delegate will indicate whether or not the user's passcode entry was a match
 with the current passcode on file by returning YES or NO. The logic for this method 
 must be implemented by the delegate if any authorization is involved.
 
 Although we have the phrase "willAuthorize" in our signature, know that we can
 indicate a failed authorization attempt when we return NO from this method.
 
 @param passcodeViewController The object doing the delegating.
 @param passcode The passcode that the user entered.
 
 @return YES to indicate that the passcode entered is a match. NO otherwise.
 */
- (BOOL)passcodeViewController:(APPSPasscodeViewController *)passcodeViewController
         willAuthorizePasscode:(NSString *)passcode;


/**
 The user entered an authorized passcode. If all that is being done is
 authorization, this method is required to be implemented so that the
 view controller can be dimissed at this point.
 
 That is, this is the hook that you should use to dismiss the passcode 
 view controller, returning the user to regular interacation with your app.
 
 @param passcodeViewController  The object doing the delegating.
 @param passcode                The passcode that the user entered that was authorized.
 */
- (void)passcodeViewController:(APPSPasscodeViewController *)passcodeViewController
          didAuthorizePasscode:(NSString *)passcode;


/**
 This method may be desirable to be implemented if the presenting controller
 wishes to only allow a certain number of failed authorization attempts.  
 
 If that is the case, the delegate should dismiss the view controller upon reaching the limit.
 Of course, the point of having a hard limit means that you'll inhibit or lockout the user in
 some fashion, beyond just dismissed the passcode view controller.
 
 @param passcodeViewController  The object doing the delegating.
 @param passcode                The passcode that the user entered that was rejected.
 @param failedAttemptCount      The number of times the user has failed to enter an
                                authorized passcode.
 */
- (void)passcodeViewController:(APPSPasscodeViewController *)passcodeViewController
    didFailToAuthorizePasscode:(NSString *)passcode
            failedAttemptCount:(NSUInteger)failedAttemptCount;


/**
 This may be implemented if the delegate wants to allow/disallow certain
 passcodes. This might be of interest here in order to disallow
 the new passcode from matching the previous passcode.  
 
 Additionally, you could disallow passcodes like "1111" or "1234", for example.  
 If the delegate returns NO, it is expected that the errorMessage outparam will 
 contain a message that can be presented to the user.
 
 @param passcodeViewController  The object doing the delegating.
 @param fromPasscode            The user's original passcode which has already been authorized,
                                or nil if the user is setting up a passcode for the first time.
 @param toPasscode              The user's proposed new passcode, which the delegate can choose
                                to accept/reject by returning YES/NO.
 @param errorMessage            An outparam that must be set by the delegate if NO is returned.
 
 @return    YES or NO, depending on whether the delegate wants to approve or reject
            the new passcode. If NO is returned, the errorMessage param must be
            set to a non-nil value.
 */
- (BOOL)passcodeViewController:(APPSPasscodeViewController *)passcodeViewController
        willUpdateFromPasscode:(NSString *)fromPasscode
                    toPasscode:(NSString *)toPasscode
                  errorMessage:(NSString *__autoreleasing *)errorMessage;


/**
 Upon successfully creating a new passcode, or updating an existing passcode, the
 delegate will send this message. This method is required for all modes except
 @c APPSPasscodeModeAuthorization.  
 
 At a minimum, the delegate should dimiss the presented view controller from this method.  
 Most likely, the delegate will also want to capture the user's newly created/updated passcode
 in some form of secure storage.
 
 @param passcodeViewController  The object doing the delegating.
 @param fromPasscode            The user's original passcode which has already been authorized,
                                or nil if the user is setting up a passcode for the first time.
 @param toPasscode              The user's new/updated passcode. This should be captured
                                by the delegate.
 */
- (void)passcodeViewController:(APPSPasscodeViewController *)passcodeViewController
         didUpdateFromPasscode:(NSString *)fromPasscode
                    toPasscode:(NSString *)toPasscode;

@end