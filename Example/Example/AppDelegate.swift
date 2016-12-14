//
//  AppDelegate.swift
//  Example
//
//  Created by Ken Grigsby on 5/21/16.
//  Copyright © 2016 Appstronomy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var passcodeService: DemoPasscodeService!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        passcodeService = DemoPasscodeService()
        passcodeService.window = window
        passcodeService.user = DemoUser()
        
        return true
    }
}

