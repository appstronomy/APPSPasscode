# APPSPasscode

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=5743719adb87810100cb593c&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/5743719adb87810100cb593c/build/latest)

# Introduction
A reusable passcode subsystem for iOS apps. 

## Default and Custom Styles
You can change the visual appearance of the passcode (lines, colors, images) as suits the needs of your app. While the default style mimics Apple's own native iOS passcode control, we don't recommend you ship using that default style. It's only an example to provide you with a familiar starting point.

We learned the hard way that your app can be rejected for presenting a passcode control that is too close to Apple's own.

Consequently, we built a generic way to style the passcode component. This way, it can take on the look of the host app it is serving. And passing App Review is also a worthy goal! :)

In the Example app in this repo, you'll see the default style and a custom style.

### Configuring Styles

To configure a visual style to your liking, you'll create an instance of `APPSPasscodeViewConfiguration` and set this to be the `viewConfiguration` on the `APPSPasscodeViewController`.

Here's an example from the bundled Example app, in Swift. It is taken from the `DemoPasscodeService.swift`:

```swift
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

```


# Installation and Usage

## For Your App

The easiest way to use APPSPasscode in your app is to add it as a [Carthage](https://github.com/Carthage/Carthage) dependency.

Add the following entry to your app project's `Cartfile`:

```
github "appstronomy/APPSPasscode"
```


## Xcode: Workspace and Project Files

If you open up the `APPSPasscode.xcodeproj` project file, you'll see just the APPSPasscode framework.

If instead, you open up the `APPSPasscode.xcworkspace` workspace file, you'll see the APPSPasscode framework *and* an Example app that demonstrates how you might use it.


## Dependencies
The APPSPasscode framework has an embedded dependency on the [Lockbox](https://github.com/granoff/Lockbox) utility class. As such, you do not have to worry about carthage or cocoapod dependencies of this framework when you pull it into your projects.

That said, you can ignore that default dependency and choose to use another tool or mechanism to store a user's passcode.

# Credits
The original passcode subsystem was built for [Appstronomy](http://appstronomy.com) by [Chris Morris](http://www.chrismorris.net/Site/Home.html) in 2014.

Later enhancements were made by [Ken Grigsby](https://github.com/kgrigsby59) and [Sohail Ahmed](http://sohail.io). UI/UX guidance was provided by [Salman Sajid](http://www.sajid.com) throughout integration in client projects.