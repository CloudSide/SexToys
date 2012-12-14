//
//  AppDelegate.m
//  SexToys
//
//  Created by Bruce on 12-12-2.
//  Copyright (c) 2012年 Bruce. All rights reserved.
//

#import "AppDelegate.h"
#import "MainSlideViewController.h"
#import <objc/runtime.h>
#import "MainViewController.h"
#import "LockerViewController.h"
#import "Static.h"
#import "MobClick.h"


int ddLogLevel;


@implementation AppDelegate

@synthesize navigationController = _navigationController;
@synthesize verifyPassed = _verifyPassed;
@synthesize hasPasscode = _hasPasscode;
@synthesize isLocked = _isLocked;

- (void)dealloc {
    
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [MobClick startWithAppkey:kUMENGAPPKEY];
    
    
    
#ifdef DEBUG
    ddLogLevel = LOG_LEVEL_VERBOSE;
#else
    ddLogLevel = LOG_LEVEL_INFO;
#endif
    
    VdiskLogFormatter *formatter = [[[VdiskLogFormatter alloc] init] autorelease];
    
#ifdef DEBUG
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
#endif
    
    CompressingLogFileManager *logFileManager = [[[CompressingLogFileManager alloc] init] autorelease];
    DDFileLogger *fileLogger = [[[DDFileLogger alloc] initWithLogFileManager:logFileManager] autorelease];
    [fileLogger setLogFormatter:formatter];
    
    fileLogger.maximumFileSize  = 1024 * 1024;
	fileLogger.rollingFrequency =   60 * 60 * 4;
	fileLogger.logFileManager.maximumNumberOfLogFiles = 5;
    
    [DDLog addLogger:fileLogger];
    
    CLogReport *logReport = [[[CLogReport alloc] initWithLogsDirectory:[logFileManager logsDirectory]] autorelease];
    [CLogReport setSharedLogReport:logReport];
    
    
    DDLogInfo(@"%@\t%@", @"app_launched", @"-");
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    MainViewController *mainViewController = [[[MainViewController alloc] init] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:mainViewController] autorelease];
    [_navigationController setNavigationBarHidden:YES];
    [_navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_logo.png"] forBarMetrics:UIBarMetricsDefault];
    [_navigationController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:176.0/255.0 alpha:1.0]];
    mainViewController.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];

    
    self.window.rootViewController = _navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if ([Static getPasscode]) {
        
        self.hasPasscode = YES;
        self.verifyPassed = NO;
        self.isLocked = YES;
        
        LockerViewController *locker = [[LockerViewController alloc] initWithStyle:kPasscodeStyleVerifyLogin];
        locker.delegate = self;
        UINavigationController *lockerNavController = [[[UINavigationController alloc] initWithRootViewController:locker] autorelease];
        [_navigationController presentModalViewController:lockerNavController animated:YES];
        [locker release];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


void SwapMethodImplementations(Class cls, SEL left_sel, SEL right_sel) {
    
    Method leftMethod = class_getInstanceMethod(cls, left_sel);
    Method rightMethod = class_getInstanceMethod(cls, right_sel);
    method_exchangeImplementations(leftMethod, rightMethod);
}

+ (void)initialize {
    if (self == [AppDelegate class]) {
#ifdef __IPHONE_6_0
        SwapMethodImplementations([UIViewController class], @selector(supportedInterfaceOrientations), @selector(sp_supportedInterfaceOrientations));
        SwapMethodImplementations([UIViewController class], @selector(shouldAutorotate), @selector(sp_shouldAutorotate));
#endif
    }
}

#pragma mark -

+ (AppDelegate *)sharedAppDelegate {
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


@end
