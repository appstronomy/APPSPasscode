//
//  APPSSecurePlaceholderView.h
//  APPSPasscode
//
//  Created by Chris Morris on 7/22/14.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This view simply draws a "hyphen" if it is not occupied and then
 a "bullet" when it is occupied.  This is used as a "digit" in the
 passcode view controller.
 */
@interface APPSSecurePlaceholderView : UIView

/**
 If this is occupied, a round bullet is drawn, otherwise a hyphen is drawn.
 */
@property (nonatomic, getter=isOccupied) BOOL occupied;


/**
 The color applied to the bullets and hyphen.
 */
@property (nonatomic, strong) UIColor *foregroundColor;


@end
