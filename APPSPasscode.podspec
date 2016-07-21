
Pod::Spec.new do |s|

  s.name         = "APPSPasscode"
  s.version      = "0.1.2"
  s.summary      = "A reusable passcode subsystem for iOS apps."
  s.description  = <<-DESC
    A reusable passcode subsystem for iOS apps. This is used as a passcode foundation by Appstronomy for our own internal and client projects. We wanted to share our solution to a common need.

    Originally built in Objective-C, this framework will also work well in your Swift based apps, as demonstrated by our example Swift app bundled with this repo. The example app shows you how you might use the APPSPasscode framework, including how to customize it.
    DESC


  s.homepage     = "https://github.com/appstronomy/APPSPasscode"
  s.license	= { :type => 'MIT' }
  s.author             = "Chris Morris, Ken Grigsby, Sohail Ahmed"
  s.social_media_url   = "http://twitter.com/appstronomy"

  s.platform     = :ios, "9.3"
  s.requires_arc = true

  s.framework     = "UIKit"
  s.source        = { :git => "https://github.com/appstronomy/APPSPasscode.git", :tag => s.version.to_s }
  s.source_files  = "APPSPasscode/**/*.[hm]"

  s.public_header_files = "APPSPasscode/APPSPasscodeCredentialsManager.h",
    "APPSPasscode/APPSPasscodeService.h",
    "APPSPasscode/APPSPasscodeViewConfiguration.h",
    "APPSPasscode/APPSFormSheetTransition.h",
    "APPSPasscode/APPSPasscodePresenter.h",
    "APPSPasscode/APPSPasscodeViewController.h",
    "APPSPasscode/APPSPasscodeViewControllerDelegate.h",
    "APPSPasscode/APPSPasscodeUsername.h",
    "APPSPasscode/APPSPasscodeEnums.h",
    "APPSPasscode/APPSPasscode.h"

  s.resource = "APPSPasscode/Resources/*"

end
