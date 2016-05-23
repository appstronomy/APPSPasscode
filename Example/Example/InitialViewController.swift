//
//  InitialViewController.swift
//  Example
//
//  Created by Ken Grigsby on 5/21/16.
//  Copyright © 2016 Appstronomy. All rights reserved.
//

import UIKit
import APPSPasscode

class InitialViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var styleControl: UISegmentedControl!
    
    @IBOutlet weak var clearPasscodeButton: UIButton!
    @IBOutlet weak var setPasscodeButton: UIButton!
    @IBOutlet weak var updatePasscodeButton: UIButton!
    @IBOutlet weak var authorizePasscodeButton: UIButton!
    
    
    // MARK: Properties
    
    var passcodeService: DemoPasscodeService {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            fatalError("")
        }
        return appDelegate.passcodeService
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        updatePasscodeButtons()
        
        styleControl.selectedSegmentIndex = passcodeService.passcodeStyle.rawValue
    }
    
    
    // MARK: Actions

    @IBAction func handleClearPasscodeButtonTap() {
        passcodeService.clearPasscodeForUser()
        updatePasscodeButtons()
    }
    
    @IBAction func handleSetPasscodeButtonTap() {
        passcodeService.presentPasscodeChallenge(.New)
    }
    
    @IBAction func handleUpdatePasscodeButtonTap() {
        passcodeService.presentPasscodeChallenge(.Update)
    }
    
    @IBAction func handleAuthorizePasscodeButtonTap() {
        passcodeService.presentPasscodeChallenge(.Authorize)
    }
    
    @IBAction func handleStyleControlTap(sender: UISegmentedControl) {
        if let style = DemoPasscodeService.PasscodeStyle(rawValue: sender.selectedSegmentIndex) {
            passcodeService.passcodeStyle = style
        }
    }
    
    
    // MARK: Helpers
    
    func updatePasscodeButtons() {
        let passcodeExists = passcodeService.passcodeExistsForUser()
        clearPasscodeButton.enabled = passcodeExists
        setPasscodeButton.enabled = !passcodeExists
        updatePasscodeButton.enabled = passcodeExists
        authorizePasscodeButton.enabled = passcodeExists
    }
}

extension InitialViewController: APPSPasscodePresenter {
    
    func passcodeService(passcodeService: APPSPasscodeService, didRequestPasscodeControllerPresentation passcodeViewController: APPSPasscodeViewController) -> Bool {
        presentViewController(passcodeViewController, animated: true, completion: nil)
        return true
    }
    
    func passcodeService(passcodeService: APPSPasscodeService, didRequestPasscodeControllerDismissalAnimated animated: Bool) -> Bool {
        updatePasscodeButtons()
        dismissViewControllerAnimated(true, completion: nil)
        return true
    }

}

