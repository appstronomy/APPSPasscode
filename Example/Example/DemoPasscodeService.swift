//
//  DemoPasscodeService.swift
//  Example
//
//  Created by Ken Grigsby on 5/23/16.
//  Copyright © 2016 Appstronomy. All rights reserved.
//

import APPSPasscode

class DemoPasscodeService: APPSPasscodeService {

    enum PasscodeStyle: Int {
        case Default
        case Custom
    }
    
    var passcodeStyle = PasscodeStyle.Default
    var user: DemoUser?
    
    
    func presentPasscodeChallenge(mode: APPSPasscodeMode) {
        var configuration: APPSPasscodeViewConfiguration?
        
        if passcodeStyle == .Custom {
            configuration = APPSPasscodeViewConfiguration()
            configuration!.topToLogoSpacing = 30
            configuration!.logoToInstructionLabelSpacing = 30
            
            configuration!.rootViewBackgroundColor = UIColor.lightGrayColor()
            configuration!.messageContainerBackgroundColor = UIColor.lightGrayColor()
            configuration!.keypadBackgroundColor = UIColor.lightGrayColor()
            
            configuration!.keypadBackgroundColor = UIColor.grayColor()
            configuration!.keypadNumericKeyDefaultColor = UIColor.grayColor()
            configuration!.keypadNumericKeyHighlightColor = UIColor.darkGrayColor()
            configuration!.keypadTextColor = UIColor.whiteColor()
            configuration!.bulletColor = UIColor.darkGrayColor()
        }
        
        let passcodeController = APPSPasscodeViewController()
        passcodeController.viewConfiguration = configuration
        passcodeController.delegate = self
        passcodeController.passcodeMode = mode
        
        // On the iPad present the view as 320x480
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            passcodeController.modalPresentationStyle = .Custom
            passcodeController.transitioningDelegate = self
        }

        rootViewController?.passcodeService(self, didRequestPasscodeControllerPresentation: passcodeController)
    }

    
    func passcodeExistsForUser() -> Bool {
        guard let user = user else { return false }
        return APPSPasscodeCredentialsManager.sharedInstance().passcodeExistsForUser(user)
    }
    
    func clearPasscodeForUser() {
        guard let user = user else { return }
        APPSPasscodeCredentialsManager.sharedInstance().removePasscodeForUser(user)
    }
    
    
    // MARK: APPSPasscodeViewControllerDelegate
    
    override func passcodeViewControllerCanCancel(passcodeViewController: APPSPasscodeViewController) -> Bool {
        return true
    }

    override func passcodeViewControllerDidCancel(passcodeViewController: APPSPasscodeViewController) {
        rootViewController?.passcodeService(self, didRequestPasscodeControllerDismissalAnimated: true)
    }
    
    
    override func passcodeViewController(passcodeViewController: APPSPasscodeViewController, didUpdateFromPasscode fromPasscode: String?, toPasscode: String) {
        
        if let user = user {
            APPSPasscodeCredentialsManager.sharedInstance().setPasscodeFrom(fromPasscode, to: toPasscode, forUser: user)
        }
        
        rootViewController?.passcodeService(self, didRequestPasscodeControllerDismissalAnimated: true)
    }
    
    
    // Update/Authorizing
    
    override func passcodeViewController(passcodeViewController: APPSPasscodeViewController, willAuthorizePasscode passcode: String) -> Bool {
        guard let user = user else { return false }
        return APPSPasscodeCredentialsManager.sharedInstance().authorizePasscode(passcode, forUser: user)
    }

    override func passcodeViewController(passcodeViewController: APPSPasscodeViewController, didFailToAuthorizePasscode passcode: String, failedAttemptCount: UInt) {
        NSLog("Failed to authorize %d times", failedAttemptCount)
    }
    
    override func passcodeViewController(passcodeViewController: APPSPasscodeViewController, didAuthorizePasscode passcode: String) {
        if passcodeViewController.passcodeMode == .Authorize {
            rootViewController?.passcodeService(self, didRequestPasscodeControllerDismissalAnimated: true)
        }
    }
    

}
