//
//  APPSPasscodeEnums.h
//  APPSPasscode
//
//  Created by Ken Grigsby on 12/31/15.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#ifndef APPSPasscodeEnums_h
#define APPSPasscodeEnums_h

/**
 These are used to identify the keys on the keypad.  The "digit" values
 have a numeric value that corresponds to the name.
 */
typedef NS_ENUM(NSInteger, APPSNumericKeypadKey) {
    APPSNumericKeypadKeyInvalid = NSIntegerMin,
    APPSNumericKeypadKeyZero    = 0,
    APPSNumericKeypadKeyOne,
    APPSNumericKeypadKeyTwo,
    APPSNumericKeypadKeyThree,
    APPSNumericKeypadKeyFour,
    APPSNumericKeypadKeyFive,
    APPSNumericKeypadKeySix,
    APPSNumericKeypadKeySeven,
    APPSNumericKeypadKeyEight,
    APPSNumericKeypadKeyNine,
    APPSNumericKeypadKeyExtra,
    APPSNumericKeypadKeyDelete
};


#endif /* APPSPasscodeEnums_h */
