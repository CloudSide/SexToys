//
//  AppDelegate.h
//  SexToys
//
//  Created by Bruce on 12-12-2.
//  Copyright (c) 2012年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockerViewController.h"

#define kImageViewDefaultTag        2031
#define kUMENGAPPKEY                @"50c31f9f5270156bcc00010c"

@interface AppDelegate : UIResponder <UIApplicationDelegate, LockerViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic) BOOL verifyPassed;
@property (nonatomic) BOOL hasPasscode;
@property (nonatomic) BOOL isLocked;

+ (AppDelegate *)sharedAppDelegate;

@end
