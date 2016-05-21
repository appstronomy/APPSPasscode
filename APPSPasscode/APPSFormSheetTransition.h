//
//  APPSFormSheetTransition.h
//  APPSPasscode
//
//  Created by Chris Morris on 7/22/14.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import <UIKIt/UIKIt.h>

@interface APPSFormSheetTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter=isPresenting) BOOL presenting;

@end