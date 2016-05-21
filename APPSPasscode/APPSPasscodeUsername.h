//
//  APPSPasscodeUsername.h
//  APPSPasscode
//
//  Created by Sohail Ahmed on 2016-05-06.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This protocol defines the necessary fields to implement a password model.
 */
@protocol APPSPasscodeUsername <NSObject>


@required

/**
 A field for a unique identifier for a passcode manager.  Removes dependency on specific user models.
 
 @return Unique identifier for user to attach to password
 */
- (NSString *)username;

@end
