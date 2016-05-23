//
//  APPSPasscodeCredentialsManager.m
//  APPSPasscode
//
//  Created by Chris Morris on 7/24/14.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//
#import "APPSPasscodeCredentialsManager.h"
#import "Lockbox.h"

static NSString * const APPSPasscodeKeyName = @"_APPSPinPasscode";

@implementation APPSPasscodeCredentialsManager

+ (instancetype)sharedInstance
{
    static APPSPasscodeCredentialsManager *sharedInstance;
    static dispatch_once_t      onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = (APPSPasscodeCredentialsManager *)[[[self class] alloc] init];
    });

    return sharedInstance;
}



#pragma mark - Public Instance Methods

- (BOOL)passcodeExistsForUser:(id <APPSPasscodeUsername>)user
{
    return [self passcodeForUsername:user.username] != nil;
}

- (BOOL)authorizePasscode:(NSString *)passcode
                  forUser:(id <APPSPasscodeUsername>)user
{
    NSString *existingPasscode = [self passcodeForUsername:user.username];
    
    return existingPasscode ? [existingPasscode isEqualToString:passcode] : YES;
}

- (BOOL)allowPasscodeToChangeFrom:(NSString *)fromPasscode
                               to:(NSString *)toPasscode
                          forUser:(id <APPSPasscodeUsername>)user
                    reasonMessage:(NSString *__autoreleasing *)reasonMessage
{
    BOOL isAuthorized = [self authorizePasscode:fromPasscode
                                        forUser:user];
    
    NSString *message;
    
    if (!isAuthorized) {
        message = @"Previous passcode is invalid.";
    }
    else if ([fromPasscode isEqualToString:toPasscode]) {
        message = @"Enter a different passcode. Cannot re-use the same passcode.";
    }
    else if (![self isAllowablePasscode:toPasscode]) {
        message = @"Passcode is not allowed.";
    }
    
    if (message) {
        if (reasonMessage) {
            *reasonMessage = message;
        }
        
        return NO;
    }
    
    return YES;
}


- (BOOL)setPasscodeFrom:(NSString *)fromPasscode
                     to:(NSString *)toPasscode
                forUser:(id <APPSPasscodeUsername>)user
{
    if (![self allowPasscodeToChangeFrom:fromPasscode
                                      to:toPasscode
                                 forUser:user
                           reasonMessage:NULL]) {
        return NO;
    }
    
    [self setPasscode:toPasscode
          forUsername:user.username];
    
    return YES;
}


- (void)removePasscodeForUser:(id <APPSPasscodeUsername>)user
{
    [self setPasscode:nil forUsername:user.username];
}



#pragma mark - Passcode Management

- (NSString *)passcodeForUsername:(NSString *)username
{
    Lockbox *lockboxForPasscode = [[Lockbox alloc] init];
    return [lockboxForPasscode stringForKey:[self lookupKeyForUsername:username]];
}


- (NSString *)lookupKeyForUsername:(NSString *)username
{
    return [username stringByAppendingString:APPSPasscodeKeyName];
}


- (void)setPasscode:(NSString *)passcode
        forUsername:(NSString *)username
{
    Lockbox *lockboxForPasscode = [[Lockbox alloc] init];
    BOOL success =[lockboxForPasscode setString:passcode forKey:[self lookupKeyForUsername:username]];
    if (!success) {
        //TODO: DECIDE ON APPROPRIATE ERROR HANDLING BEHAVIOUR
        NSLog(@"%@",@"Failed to save passcode to keychain");
    }
}


/**
 nil is allowed.  This is used to reset the passcode.  Otherwise, the only
 active "test" is to make sure the length is correct.
 */
- (BOOL)isAllowablePasscode:(NSString *)passcode
{
    return !passcode || ([passcode length] == 4);
}



@end
