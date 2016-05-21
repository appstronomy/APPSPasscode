//
//  APPSPasscodeEntryViewController.m
//  APPSPasscode
//
//  Created by Chris Morris on 7/22/14.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import "APPSPasscodeEntryViewController.h"
#import "APPSSecurePlaceholderView.h"
#import "APPSNumericKeypadView.h"
#import "APPSPasscodeViewController.h"
#import "APPSPasscodeViewConfiguration.h"

/**
 Used to determine where we are in the process of authorizing or accepting
 a new/updated passcode.
 */
typedef NS_ENUM(NSUInteger, APPSPasscodeEntryState) {
    APPSPasscodeEntryStateEntry,
    APPSPasscodeEntryStateEntryConfirmation,
    APPSPasscodeEntryStateAuthorization,
    APPSPasscodeEntryStateDone
};

static const CGSize  kAuthorizationFailureViewShadowOffset  = {.width = 0.0, .height = -0.5};
static const CGFloat kAuthorizationFailureViewShadowOpacity = 0.5;
static const CGFloat kAuthorizationFailureViewShadowRadius  = 0.5;

static const NSTimeInterval kFlyTransitionAnimationDuration = 0.15;
static const NSTimeInterval kPasscodeResetDelay             = 0.25;


@interface APPSPasscodeEntryViewController () <APPSNumericKeypadViewDelegate>

#pragma mark IBOutlets/UI Related

/**
 There are ultimately container views on the screen, the messageContainer and
 the keypadView.  All of these other outlets are subviews of the
 messageContainer.
 */
@property (weak, nonatomic) IBOutlet UIView *messageContainer;

/**
 Sits above the instruction label
 */
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

/**
 Sits above the passcodeDigits.
 */
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;

/**
 Sits below the passcodeDigits.  This is just a standard, unadorned label.
 */
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

/**
 Sits below the passcodeDigits.  This is the white text label with the
 red background.
 */
@property (weak, nonatomic) IBOutlet UILabel *authorizationFailureLabel;

/**
 The red background view that sits behind and contains the 
 authorizationFailureLabel.  This was done in order to allow for padding
 around the label, which wouldn't work easily using just a background color
 on the label, due to the intrinsic content size of the label.  The size
 of this is constrained to the size of the label.
 */
@property (weak, nonatomic) IBOutlet UIView *authorizationFailureView;

/**
 The numeric keypad.
 */
@property (weak, nonatomic) IBOutlet APPSNumericKeypadView *keypadView;

/**
 Can't depend on the ordering of the IBOutletCollection, so we will only
 use the passcodeDigits property, and not this one.
 */
@property (strong, nonatomic) IBOutletCollection(APPSSecurePlaceholderView) NSArray *passcodeDigitsUnsorted;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToLogoConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoToInstructionLabelConstraint;

/**
 Sorted version of passcodeDigitsUnsorted.  Sorted by tag.
 */
@property (readonly, nonatomic) NSArray *passcodeDigits;

/**
 The Cancel bar button item.
 */
@property (strong, nonatomic) UIBarButtonItem *cancelButton;


/**
 The default background color. Used when applyColors has
 nil for key APPSPasscodeColorKey_rootViewBackgroundColor.
 */
@property (strong, nonatomic) UIColor *defaultBackgroundColor;


#pragma mark State Related Properties

/**
 What state is the view controller in. See the possible states in the enumeration
 for ideas of what the states can be.
 */
@property (assign, nonatomic) APPSPasscodeEntryState passcodeState;

/**
 The required length of a passcode derived from the number of elements in
 the passcodeDigits.
 */
@property (readonly, nonatomic) NSUInteger requiredPasscodeLength;

/**
 The passcode which is in progress.  The passcodeDigits reflect this passcode.
 If this is nil, it will be lazily instantiated.
 */
@property (strong, nonatomic) NSMutableString *activePasscode;

/**
 The old passcode which has successfully been authorized.  This passcode is
 used when we are updating a passcode and we first need to authorize.
 */
@property (copy, nonatomic) NSString *authorizedPasscode;

/**
 The new passcode which has been approved.  It may not have been confirmed yet
 by the user.
 */
@property (copy, nonatomic) NSString *updatedPasscode;

/**
 Tracks the number of failed authorization attempts.
 */
@property (assign, nonatomic) NSUInteger failedAuthorizationAttemptCount;

/**
 The message which should be displayed in the errorLabel. If this has a non-nil
 value, the errorLabel will be displayed.
 */
@property (copy, nonatomic) NSString *passcodeFailureMessage;

@end

@implementation APPSPasscodeEntryViewController

@synthesize passcodeDigits = _passcodeDigits;
@synthesize activePasscode = _activePasscode;



#pragma mark - Properties

/**
 Set the passcodeState based on the new passcodeMode.
 */
- (void)setPasscodeMode:(APPSPasscodeMode)passcodeMode
{
    _passcodeMode = passcodeMode;

    switch (passcodeMode) {
        case APPSPasscodeModeNew:
            self.passcodeState = APPSPasscodeEntryStateEntry;
            break;
        case APPSPasscodeModeUpdate:
        case APPSPasscodeModeAuthorize:
            self.passcodeState = APPSPasscodeEntryStateAuthorization;
            break;
    }
}


- (NSMutableString *)activePasscode
{
    if (!_activePasscode) {
        _activePasscode = [[NSMutableString alloc] init];
    }

    return _activePasscode;
}


- (NSArray *)passcodeDigits
{
    if (!_passcodeDigits) {
        _passcodeDigits = [self.passcodeDigitsUnsorted sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
            // While perhaps not the most efficient, it is the easiest, and since
            // I am sorting 4 items one time ... seems ok to me :)
            return [@(obj1.tag) compare:@(obj2.tag)];
        }];
    }

    return _passcodeDigits;
}


- (UIBarButtonItem *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                      target:self
                                                                      action:@selector(cancelTapped)];
    }

    return _cancelButton;
}


- (NSUInteger)requiredPasscodeLength
{
    return [self.passcodeDigits count];
}


- (void)setViewConfiguration:(APPSPasscodeViewConfiguration *)viewConfiguration
{
    _viewConfiguration = [viewConfiguration copy];
    
    if (self.isViewLoaded) {
        [self applyViewConfiguration];
    }
}



#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.defaultBackgroundColor = self.view.backgroundColor;

    [self setupAuthorizationFailureView];
    [self setupMessageContainer];
    [self applyViewConfiguration];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateUI];
}



#pragma mark Interface Setup

- (void)setupAuthorizationFailureView
{
    self.authorizationFailureView.layer.cornerRadius  = CGRectGetHeight(self.authorizationFailureView.bounds) / 2.0;
    self.authorizationFailureView.layer.shadowOffset  = kAuthorizationFailureViewShadowOffset;
    self.authorizationFailureView.layer.shadowOpacity = kAuthorizationFailureViewShadowOpacity;
    self.authorizationFailureView.layer.shadowRadius  = kAuthorizationFailureViewShadowRadius;
}


- (void)setupMessageContainer
{
    NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:self.messageContainer
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.topLayoutGuide
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                           constant:0.0];

    [self.view addConstraint:verticalConstraint];
}


- (void)applyViewConfiguration
{
    APPSPasscodeViewConfiguration *viewConfig = self.viewConfiguration;
    
    self.view.backgroundColor                   = viewConfig.rootViewBackgroundColor ?: self.defaultBackgroundColor;
    self.messageContainer.backgroundColor       = viewConfig.messageContainerBackgroundColor;

    self.keypadView.textColor                   = viewConfig.keypadTextColor;
    self.keypadView.backdropColor               = viewConfig.keypadBackgroundColor;
    self.keypadView.defaultColorForNumericKey   = viewConfig.keypadNumericKeyDefaultColor;
    self.keypadView.highlightColorForNumericKey = viewConfig.keypadNumericKeyHighlightColor;
    self.keypadView.deleteKeyImage              = viewConfig.deleteKeyImage;
    self.keypadView.buttonSpacing               = viewConfig ? viewConfig.buttonSpacing : CGSizeMake([APPSNumericKeypadView hairlineThickness], [APPSNumericKeypadView hairlineThickness]);
    self.keypadView.customKeyColors             = viewConfig.customKeyColors;

    self.instructionLabel.textColor             = viewConfig.instructionTextColor;
    self.errorLabel.textColor                   = viewConfig.errorTextColor;
    
    [self.passcodeDigits setValue:viewConfig.bulletColor forKey:@"foregroundColor"];
    
    self.topToLogoConstraint.constant               = viewConfig ? viewConfig.topToLogoSpacing : 15;
    self.logoToInstructionLabelConstraint.constant  = viewConfig ? viewConfig.logoToInstructionLabelSpacing : 15;
    self.logoImageView.image                        = viewConfig.logoImage;
    
    NSAssert(self.logoImageView.image != nil, @"A logo image is required for the passcode view contoller. This is specified as part of the viewConfiguration.");
    
    [self.view setNeedsDisplay];
}



#pragma mark Interface Updates

/**
 Updates the UI, but flys the old messageContainer off screen, updates it,
 and then flys it back on screen.
 */
- (void)updateUI:(BOOL)animated
{
    if (!animated) {
        [self updateUI];
        return;
    }

    [UIView animateWithDuration:kFlyTransitionAnimationDuration
                          delay:kPasscodeResetDelay
                        options:0
                     animations:^{
                         // Transition off screen to the left
                         CGPoint newCenter = self.messageContainer.center;
                         newCenter.x = CGRectGetMidX(self.view.bounds) - CGRectGetWidth(self.view.bounds);

                         self.messageContainer.center = newCenter;
                     }
                     completion:^(BOOL finished) {
                         // Move to an off screen position but on the right hand side
                         CGPoint newCenter = self.messageContainer.center;
                         newCenter.x = CGRectGetMidX(self.view.bounds) + CGRectGetWidth(self.view.bounds);

                         self.messageContainer.center = newCenter;

                         // Update the UI while we are off screen
                         [self updateUI];

                         // Transition back on screen from the right
                         [UIView animateWithDuration:kFlyTransitionAnimationDuration
                                          animations:^{
                                              CGPoint newCenter = self.messageContainer.center;

                                              newCenter.x = self.view.center.x;
                                              self.messageContainer.center = newCenter;
                                          }];
                     }];
}


/**
 Update the UI based on the all of the current state information that
 we have kept track of.
 */
- (void)updateUI
{
    [self updateTitle];
    [self updateCancelButton];
    [self updateInstructionLabel];
    [self updateErrorLabel];
    [self updatePasscodeDigitViews];
    [self updateAuthorizationFailureView];
}


- (void)updateTitle
{
    NSString *newTitle;

    if ((self.passcodeMode  == APPSPasscodeModeAuthorize) ||
        (self.passcodeState == APPSPasscodeEntryStateAuthorization)) {
        newTitle = @"Enter Passcode";
    }
    else if (self.passcodeMode == APPSPasscodeModeNew) {
        newTitle = @"Set Passcode";
    }
    else if (self.passcodeMode == APPSPasscodeModeUpdate) {
        newTitle = @"Change Passcode";
    }

    self.navigationItem.title = newTitle;
}


- (void)updateCancelButton
{
    if ([self.delegate passcodeEntryViewControllerCanCancel:self]) {
        self.navigationItem.rightBarButtonItem = self.cancelButton;
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}


- (void)updateInstructionLabel
{
    NSString *instruction;

    switch (self.passcodeState) {
        case APPSPasscodeEntryStateEntry:
            instruction = @"Enter your new app passcode";
            break;
        case APPSPasscodeEntryStateEntryConfirmation:
            instruction = @"Re-enter your new app passcode";
            break;
        case APPSPasscodeEntryStateAuthorization:
            instruction = @"Enter your app passcode";
            break;
        case APPSPasscodeEntryStateDone:
            instruction = @"Passcode accepted.";
            break;
    }

    self.instructionLabel.text = instruction;
}


- (void)updateErrorLabel
{
    self.errorLabel.text   = self.passcodeFailureMessage;
    self.errorLabel.hidden = !self.passcodeFailureMessage;
}


- (void)updatePasscodeDigitViews
{
    for (int i = 0; i < self.requiredPasscodeLength; i++) {
        [self.passcodeDigits[i] setOccupied:(i < [self.activePasscode length])];
    }
}


- (void)updateAuthorizationFailureView
{
    NSString *plural      = self.failedAuthorizationAttemptCount > 1 ? @"s" : @"";
    NSString *message     = [NSString stringWithFormat:@"%lu Failed Passcode Attempt%@",
                                (unsigned long)self.failedAuthorizationAttemptCount, plural];
    BOOL      showMessage = (self.failedAuthorizationAttemptCount > 0);
    
    self.authorizationFailureLabel.text  = message;
    self.authorizationFailureView.hidden = !showMessage;
}


/**
 This is done so we can see the final "bullet" fill in for the last passcode
 digit, and then it can be cleared.  If we don't do the delay, then we never
 see the final digit filled in except when we do an updateUI with animation.
 */
- (void)resetPasscodeAfterDelay:(BOOL)delay
{
    if (delay) {
        [self performSelector:@selector(setActivePasscode:)
                   withObject:nil
                   afterDelay:kPasscodeResetDelay];
        [self performSelector:@selector(updatePasscodeDigitViews)
                   withObject:nil
                   afterDelay:kPasscodeResetDelay];
    }
    else {
        self.activePasscode = nil;
    }
}



#pragma mark - Workflow

- (void)processPasscode
{
    if (self.activePasscode.length != self.requiredPasscodeLength) {
        return;
    }

    NSString *passcode = [self.activePasscode copy];

    switch (self.passcodeState) {
        case APPSPasscodeEntryStateAuthorization:
            [self authorizePasscode:passcode];
            break;
        case APPSPasscodeEntryStateEntry:
            [self acceptPasscodeEntry:passcode];
            break;
        case APPSPasscodeEntryStateEntryConfirmation:
            [self confirmPasscodeEntry:passcode];
            break;
        case APPSPasscodeEntryStateDone:
            break;
    }
}


/**
 The user has just finished entering their current passcode.
 */
- (void)authorizePasscode:(NSString *)passcode
{
    if (self.passcodeState != APPSPasscodeEntryStateAuthorization) {
        return;
    }

    BOOL authorizationSuccess = [self.delegate passcodeEntryViewController:self
                                                     willAuthorizePasscode:passcode];

    if (authorizationSuccess) {
        self.authorizedPasscode              = passcode;
        self.failedAuthorizationAttemptCount = 0;

        [self.delegate passcodeEntryViewController:self
                              didAuthorizePasscode:passcode];

        if (self.passcodeMode == APPSPasscodeModeAuthorize) {
            self.passcodeState = APPSPasscodeEntryStateDone;

            [self updateUI];
        }
        else {
            self.passcodeState  = APPSPasscodeEntryStateEntry;

            [self resetPasscodeAfterDelay:NO];

            [self updateUI:YES];
        }
    }
    else {
        self.failedAuthorizationAttemptCount++;

        [self updateAuthorizationFailureView];

        [self.delegate passcodeEntryViewController:self
                        didFailToAuthorizePasscode:passcode
                                failedAttemptCount:self.failedAuthorizationAttemptCount];

        [self resetPasscodeAfterDelay:YES];
    }
}


/**
 The user has just finished entering their new/updated passcode.
 */
- (void)acceptPasscodeEntry:(NSString *)passcode
{
    if (self.passcodeState != APPSPasscodeEntryStateEntry) {
        return;
    }

    NSString *errorMessage;
    BOOL      passcodeAllowed = [self.delegate passcodeEntryViewController:self
                                                    willUpdateFromPasscode:self.authorizedPasscode
                                                                toPasscode:passcode
                                                              errorMessage:&errorMessage];

    if (passcodeAllowed) {
        self.updatedPasscode        = passcode;
        self.passcodeFailureMessage = nil;
        self.passcodeState          = APPSPasscodeEntryStateEntryConfirmation;

        [self resetPasscodeAfterDelay:NO];

        [self updateUI:YES];
    }
    else {
        self.passcodeFailureMessage = errorMessage;

        [self resetPasscodeAfterDelay:YES];
        [self updateErrorLabel];
    }
}


/**
 The user has just completed the passcode confirmation screen.
 */
- (void)confirmPasscodeEntry:(NSString *)passcode
{
    if (self.passcodeState != APPSPasscodeEntryStateEntryConfirmation) {
        return;
    }

    if ([passcode isEqualToString:self.updatedPasscode]) {
        [self.delegate passcodeEntryViewController:self
                             didUpdateFromPasscode:self.authorizedPasscode
                                        toPasscode:self.updatedPasscode];

        self.passcodeState = APPSPasscodeEntryStateDone;

        [self updateUI];
    }
    else {
        self.passcodeFailureMessage = @"Passcodes did not match. Try again.";
        self.passcodeState          = APPSPasscodeEntryStateEntry;

        [self resetPasscodeAfterDelay:NO];

        [self updateUI:YES];
    }
}



#pragma mark - APPSNumericKeypadViewDelegate

/**
 Process the latest key from the keypad
 */
- (void)numericKeypadView:(APPSNumericKeypadView *)numericKeypadView
                didTapKey:(APPSNumericKeypadKey)tappedKey
{
    BOOL changeMade = NO;

    if ((tappedKey == APPSNumericKeypadKeyDelete) && ([self.activePasscode length] > 0)) {
        // Delete if we can
        [self.activePasscode deleteCharactersInRange:NSMakeRange([self.activePasscode length] - 1, 1)];
        changeMade = YES;
    }
    else if ([APPSNumericKeypadView isKeyNumeric:tappedKey] && [self.activePasscode length] < self.requiredPasscodeLength) {
        // Append if we can
        [self.activePasscode appendFormat:@"%ld", (long)tappedKey];
        changeMade = YES;
    }

    if (changeMade) {
        [self updatePasscodeDigitViews];
        [self processPasscode];
    }
}



#pragma mark - Target/Action

- (void)cancelTapped
{
    [self.delegate passcodeEntryViewControllerDidCancel:self];
}


@end
