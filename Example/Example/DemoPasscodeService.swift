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
        case `default`
        case custom
    }
    
    var passcodeStyle = PasscodeStyle.default
    var user: DemoUser?
    
    
    func presentPasscodeChallenge(_ mode: APPSPasscodeMode) {
        var configuration: APPSPasscodeViewConfiguration?
        
        if passcodeStyle == .custom {
            configuration = APPSPasscodeViewConfiguration()
            configuration!.topToLogoSpacing = 30
            configuration!.logoToInstructionLabelSpacing = 30
            
            configuration!.rootViewBackgroundColor = UIColor.lightGray
            configuration!.messageContainerBackgroundColor = UIColor.lightGray
            configuration!.keypadBackgroundColor = UIColor.lightGray
            
            configuration!.keypadBackgroundColor = UIColor.gray
            configuration!.keypadNumericKeyDefaultColor = UIColor.gray
            configuration!.keypadNumericKeyHighlightColor = UIColor.darkGray
            configuration!.keypadTextColor = UIColor.white
            configuration!.bulletColor = UIColor.darkGray
        }
        
        let passcodeController = APPSPasscodeViewController()
        passcodeController.viewConfiguration = configuration
        passcodeController.delegate = self
        passcodeController.passcodeMode = mode
        
        // On the iPad present the view as 320x480
        if UIDevice.current.userInterfaceIdiom == .pad {
            passcodeController.modalPresentationStyle = .custom
            passcodeController.transitioningDelegate = self
        }

        rootViewController?.passcodeService(self, didRequestPasscodeControllerPresentation: passcodeController)
    }

    
    func passcodeExistsForUser() -> Bool {
        guard let user = user else { return false }
        return APPSPasscodeCredentialsManager.sharedInstance().passcodeExists(forUser: user)
    }
    
    func clearPasscodeForUser() {
        guard let user = user else { return }
        APPSPasscodeCredentialsManager.sharedInstance().removePasscode(forUser: user)
    }
    
    
    // MARK: APPSPasscodeViewControllerDelegate
    
    override func passcodeViewControllerCanCancel(_ passcodeViewController: APPSPasscodeViewController) -> Bool {
        return true
    }

    override func passcodeViewControllerDidCancel(_ passcodeViewController: APPSPasscodeViewController) {
        rootViewController?.passcodeService(self, didRequestPasscodeControllerDismissalAnimated: true)
    }
    
    
    override func passcodeViewController(_ passcodeViewController: APPSPasscodeViewController, didUpdateFromPasscode fromPasscode: String?, toPasscode: String) {
        
        if let user = user {
            APPSPasscodeCredentialsManager.sharedInstance().setPasscodeFrom(fromPasscode, to: toPasscode, forUser: user)
        }
        
        rootViewController?.passcodeService(self, didRequestPasscodeControllerDismissalAnimated: true)
    }
    
    
    // Update/Authorizing
    
    override func passcodeViewController(_ passcodeViewController: APPSPasscodeViewController, willAuthorizePasscode passcode: String) -> Bool {
        guard let user = user else { return false }
        return APPSPasscodeCredentialsManager.sharedInstance().authorizePasscode(passcode, forUser: user)
    }

    override func passcodeViewController(_ passcodeViewController: APPSPasscodeViewController, didFailToAuthorizePasscode passcode: String, failedAttemptCount: UInt) {
        NSLog("Failed to authorize %d times", failedAttemptCount)
    }
    
    override func passcodeViewController(_ passcodeViewController: APPSPasscodeViewController, didAuthorizePasscode passcode: String) {
        if passcodeViewController.passcodeMode == .authorize {
            rootViewController?.passcodeService(self, didRequestPasscodeControllerDismissalAnimated: true)
        }
    }
    

}
