//
//  APPSFormSheetTransition.m
//  APPSPasscode
//
//  Created by Chris Morris on 7/22/14.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import "APPSFormSheetTransition.h"

static const CGFloat kFormSheetTransitionPresentedViewCornerRadius = 10.0;
static const CGSize  kFormSheetTransitionPresentedViewSize         = {.width = 320, .height = 480};
static const NSTimeInterval kFormSheetTransitionAnimationDuration  = 0.5;


@interface APPSFormSheetTransition ()
@end


@implementation APPSFormSheetTransition

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kFormSheetTransitionAnimationDuration;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresenting) {
        [self animatePresentation:transitionContext];
    }
    else {
        [self animateDismissal:transitionContext];
    }
}



#pragma mark Helpers

- (void)animatePresentation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *presentedController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView           *containerView = [transitionContext containerView];

    CGRect newFrame  = {.origin = CGPointZero, .size = kFormSheetTransitionPresentedViewSize};
    
    // Setup the presented view controller's view. The starting position is off-screen, below
    // the bottom of the screen.
    presentedController.view.layer.cornerRadius  = kFormSheetTransitionPresentedViewCornerRadius;
    presentedController.view.layer.masksToBounds = YES;
    presentedController.view.frame               = newFrame;
    presentedController.view.center              = CGPointMake(CGRectGetMidX(containerView.bounds),
                                                               CGRectGetMaxY(containerView.bounds) + CGRectGetMidY(containerView.bounds));
    presentedController.view.autoresizingMask    = UIViewAutoresizingNone;
    
    // Add the presented controller's view as a subview of the transitioning container's view:
    [containerView addSubview:presentedController.view];

    // We'll fade in the presented view controller. As such, we start with it not visible:
    presentedController.view.alpha = 0.0;

    // Animate in the presented view controller, fading it to visible as we slide it up and into view.
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         presentedController.view.alpha = 1.0;
                         presentedController.view.center = CGPointMake(CGRectGetMidX(containerView.bounds),
                                                                       CGRectGetMidY(containerView.bounds));
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

	
- (void)animateDismissal:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *presentedController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView           *containerView = [transitionContext containerView];

    // Fade the view controller's and the background out
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         presentedController.view.center = CGPointMake(CGRectGetMidX(containerView.bounds),
                                                               CGRectGetMaxY(containerView.bounds) + CGRectGetMidY(containerView.bounds));
                     }
                     completion:^(BOOL finished) {
                         [presentedController.view removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

@end
