//
//  APPSPasscodeViewController.m
//  APPSPasscode
//
//  Created by Chris Morris on 7/22/14.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import "APPSPasscodeViewController.h"
#import "APPSPasscodeEntryViewController.h"
#import "APPSPasscodeViewConfiguration.h"

static const CGSize  kFormSheetTransitionPresentedViewSize = {.width = 320, .height = 480};

@interface APPSPasscodeViewController () <UIViewControllerTransitioningDelegate, APPSPasscodeEntryViewControllerDelegate>

/**
 The child view controller whose view is added as a subview to self.view.
 */
@property (strong, nonatomic) UINavigationController *childNavigationController;

/**
 The rootViewController of the childNavigationController.  This is the one
 that does all of the heavy lifting.
 */
@property (strong, nonatomic) APPSPasscodeEntryViewController *passcodeEntryViewController;

@end

/**
 This view controller is really just a container view controller around
 a navigation controller which has at its root, an APPSPasscodeEntryViewCountroller.
 */
@implementation APPSPasscodeViewController


#pragma mark - Initialization

/**
 If created via alloc/init.
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        [self setupTransition];
    }

    return self;
}

/**
 If created out of a nib.
 */
- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setupTransition];
}

/**
 Setup the iPad specific transition.  The iPhone will just use the
 default full screen transition.
 */
- (void)setupTransition
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        self.preferredContentSize = kFormSheetTransitionPresentedViewSize;
    }
}



#pragma mark - Lifecycle

/**
 Sets up the view controller hierarchy.  We wait until viewDidLoad in order
 to do this so that we can delay as long as possible.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];

    NSBundle *bundle = [NSBundle bundleForClass:APPSPasscodeEntryViewController.class];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass(APPSPasscodeEntryViewController.class) bundle:bundle];
    
    self.childNavigationController = [storyboard instantiateInitialViewController];
    self.passcodeEntryViewController =  (APPSPasscodeEntryViewController *)self.childNavigationController.topViewController;
    self.passcodeEntryViewController.viewConfiguration = self.viewConfiguration;

    
    // Add the child VC dance
    [self addChildViewController:self.childNavigationController];

    self.childNavigationController.view.frame = self.view.bounds;
    [self.view addSubview:self.childNavigationController.view];

    [self.childNavigationController didMoveToParentViewController:self];


    self.passcodeEntryViewController.delegate     = self;
    self.passcodeEntryViewController.passcodeMode = self.passcodeMode;
}



#pragma mark - Properties

/**
 Be sure to set the mode on our passcodeEntryVC if it has already
 been instantiated.
 */
- (void)setPasscodeMode:(APPSPasscodeMode)passcodeMode
{
    _passcodeMode = passcodeMode;

    self.passcodeEntryViewController.passcodeMode = passcodeMode;
}


- (void)setViewConfiguration:(APPSPasscodeViewConfiguration *)viewConfiguration
{
    _viewConfiguration = [viewConfiguration copy];
    
    if (self.isViewLoaded) {
        // Pass colors onto passcodeEntryViewController to
        // do the real work.
        self.passcodeEntryViewController.viewConfiguration = viewConfiguration;
    }
}



#pragma mark - APPSPasscodeEntryViewControllerDelegate

/*
 For the most part, the delegate methods will just defer to their
 APPSPasscodeViewControllerDelegate counterparts.  They will all check first
 to see if the delegate responds to the selector.
 */

- (BOOL)passcodeEntryViewControllerCanCancel:(APPSPasscodeEntryViewController *)passcodeEntryViewController
{
    if (![self.delegate respondsToSelector:@selector(passcodeViewControllerDidCancel:)]) {
        return NO;
    }

    if ([self.delegate respondsToSelector:@selector(passcodeViewControllerCanCancel:)]) {
        return [self.delegate passcodeViewControllerCanCancel:self];
    }

    return YES;
}

- (void)passcodeEntryViewControllerDidCancel:(APPSPasscodeEntryViewController *)passcodeEntryViewController
{
    if ([self.delegate respondsToSelector:@selector(passcodeViewControllerDidCancel:)]) {
        [self.delegate passcodeViewControllerDidCancel:self];
    }
}

- (BOOL)passcodeEntryViewController:(APPSPasscodeEntryViewController *)passcodeEntryViewController
              willAuthorizePasscode:(NSString *)passcode
{
    if ([self.delegate respondsToSelector:@selector(passcodeViewController:willAuthorizePasscode:)]) {
        return [self.delegate passcodeViewController:self
                               willAuthorizePasscode:passcode];
    }

    // If the delegate does not implement this method, we will just assume the
    // passcode is authorized ... although this is most likely an error.
    return YES;
}

- (void)passcodeEntryViewController:(APPSPasscodeEntryViewController *)passcodeEntryViewController
               didAuthorizePasscode:(NSString *)passcode
{
    if ([self.delegate respondsToSelector:@selector(passcodeViewController:didAuthorizePasscode:)]) {
        [self.delegate passcodeViewController:self
                         didAuthorizePasscode:passcode];
    }
}

- (void)passcodeEntryViewController:(APPSPasscodeEntryViewController *)passcodeEntryViewController
         didFailToAuthorizePasscode:(NSString *)passcode
                 failedAttemptCount:(NSUInteger)failedAttemptCount
{
    if ([self.delegate respondsToSelector:@selector(passcodeViewController:didFailToAuthorizePasscode:failedAttemptCount:)]) {
        [self.delegate passcodeViewController:self
                   didFailToAuthorizePasscode:passcode
                           failedAttemptCount:failedAttemptCount];
    }
}

- (BOOL)passcodeEntryViewController:(APPSPasscodeEntryViewController *)passcodeEntryViewController
             willUpdateFromPasscode:(NSString *)fromPasscode
                         toPasscode:(NSString *)toPasscode
                       errorMessage:(NSString *__autoreleasing *)errorMessage
{
    if ([self.delegate respondsToSelector:@selector(passcodeViewController:willUpdateFromPasscode:toPasscode:errorMessage:)]) {
        return [self.delegate passcodeViewController:self
                              willUpdateFromPasscode:fromPasscode
                                          toPasscode:toPasscode
                                        errorMessage:errorMessage];
    }

    return YES;
}

- (void)passcodeEntryViewController:(APPSPasscodeEntryViewController *)passcodeEntryViewController
              didUpdateFromPasscode:(NSString *)fromPasscode
                         toPasscode:(NSString *)toPasscode
{
    if ([self.delegate respondsToSelector:@selector(passcodeViewController:didUpdateFromPasscode:toPasscode:)]) {
        [self.delegate passcodeViewController:self
                        didUpdateFromPasscode:fromPasscode
                                   toPasscode:toPasscode];
    }
}

@end
