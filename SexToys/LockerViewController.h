//
//  LockerViewController.h
//  MyTestProject
//
//  Created by gaopeng on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kPasscodePanelCount        3

#define kPasscodePanelX            0.0 
#define kPasscodePanelY            60.0
#define kPasscodePanelWidth        320.0
#define kPasscodePanelHeight       60.0

#define kPasscodeEntryWidth        60.0
#define kPasscodeEntryHeight       60.0

#define kPasscodePanelTitleTag     10
#define kPasscodePanelSummaryTag   11

#define kPasscodeFakeTextField     12
#define kPasscodeReloginAlert      13

#define kPasscodePanel             300

typedef enum {
    
    kPasscodeStyleSet = 0,
    kPasscodeStyleVerify,
    kPasscodeStyleReset,
    kPasscodeStyleVerifyClose,
    kPasscodeStyleVerifyLogin,
    
}kPasscodeStyle;

@protocol LockerViewDelegate;

@interface LockerViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    
    BOOL _fisrtflag;
    kPasscodeStyle _style;
    BOOL _resetVerifyPassed;
    int _errorTime;
    int _maxErrorTime;
    BOOL _errorFlag;
}

@property (nonatomic, strong) NSString *passcode;
@property (nonatomic, strong) id<LockerViewDelegate> delegate;
@property (nonatomic, assign) kPasscodeStyle style;
@property (nonatomic, assign) BOOL errorFlag;

- (id)initWithStyle:(kPasscodeStyle)style;
- (void)handlePasscode:(NSString *)passcode withView:(UIView *)currentPanel;

@end




@protocol LockerViewDelegate <NSObject>

@optional

- (void)lockerVerifyPassed:(LockerViewController *)lockerViewController;

- (void)lockerSetSuccess:(LockerViewController *)lockerViewController;

- (void)lockerResetSuccess:(LockerViewController *)lockerViewController;

- (void)lockerCancel:(LockerViewController *)lockerViewController;

@end
