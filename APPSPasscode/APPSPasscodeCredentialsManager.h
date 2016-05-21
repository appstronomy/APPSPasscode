//
//  APPSPasscodeCredentialsManager.h
//  APPSPasscode
//
//  Created by Chris Morris on 7/24/14.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSPasscodeUsername.h"

@class ICPDClinician;



extern const NSUInteger ICPDPasscodeManagerFailedAuthorizationAttemptMax;

/**
 This class is intended to manage the storage, retrieval, and authorization of
 user passcodes in a secure fashion.
 
 NOTE: This should be updated to be more secure, or at least deliberate in
 how it stores passcodes.  This has been established as more of a stub
 implementation for the time being.
 */
@interface APPSPasscodeCredentialsManager : NSObject

@property (strong, nonatomic) void(^clearPasswordBlock)(void);


#pragma mark - Instantiation

+ (instancetype)sharedInstance;

#pragma mark - Public Instance Methods

- (BOOL)passcodeExistsForUser:(id <APPSPasscodeUsername>)user;

- (BOOL)authorizePasscode:(NSString *)passcode
                  forUser:(id <APPSPasscodeUsername>)user;

- (BOOL)allowPasscodeToChangeFrom:(NSString *)fromPasscode
                               to:(NSString *)toPasscode
                          forUser:(id <APPSPasscodeUsername>)user
                    reasonMessage:(NSString *__autoreleasing *)reasonMessage;

- (BOOL)setPasscodeFrom:(NSString *)fromPasscode
                     to:(NSString *)toPasscode
                forUser:(id <APPSPasscodeUsername>)user;

- (void)removePasscodeForUser:(id <APPSPasscodeUsername>)user;



#pragma mark - Passcode Management

- (NSString *)passcodeForUsername:(NSString *)username;
- (NSString *)lookupKeyForUsername:(NSString *)username;


- (void)setPasscode:(NSString *)passcode
        forUsername:(NSString *)username;

- (BOOL)isAllowablePasscode:(NSString *)passcode;



@end
