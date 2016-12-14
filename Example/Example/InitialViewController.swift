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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
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
        passcodeService.presentPasscodeChallenge(.new)
    }
    
    @IBAction func handleUpdatePasscodeButtonTap() {
        passcodeService.presentPasscodeChallenge(.update)
    }
    
    @IBAction func handleAuthorizePasscodeButtonTap() {
        passcodeService.presentPasscodeChallenge(.authorize)
    }
    
    @IBAction func handleStyleControlTap(_ sender: UISegmentedControl) {
        if let style = DemoPasscodeService.PasscodeStyle(rawValue: sender.selectedSegmentIndex) {
            passcodeService.passcodeStyle = style
        }
    }
    
    
    // MARK: Helpers
    
    func updatePasscodeButtons() {
        let passcodeExists = passcodeService.passcodeExistsForUser()
        clearPasscodeButton.isEnabled = passcodeExists
        setPasscodeButton.isEnabled = !passcodeExists
        updatePasscodeButton.isEnabled = passcodeExists
        authorizePasscodeButton.isEnabled = passcodeExists
    }
}

extension InitialViewController: APPSPasscodePresenter {
    
    func passcodeService(_ passcodeService: APPSPasscodeService, didRequestPasscodeControllerPresentation passcodeViewController: APPSPasscodeViewController) -> Bool {
        present(passcodeViewController, animated: true, completion: nil)
        return true
    }
    
    func passcodeService(_ passcodeService: APPSPasscodeService, didRequestPasscodeControllerDismissalAnimated animated: Bool) -> Bool {
        updatePasscodeButtons()
        dismiss(animated: true, completion: nil)
        return true
    }

}

