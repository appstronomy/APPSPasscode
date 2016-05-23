//
//  DemoUser.swift
//  Example
//
//  Created by Ken Grigsby on 5/23/16.
//  Copyright © 2016 Appstronomy. All rights reserved.
//

import APPSPasscode

class DemoUser: NSObject, APPSPasscodeUsername {

    func username() -> String {
        return "DemoUser"
    }
}
