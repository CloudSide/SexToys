//
//  BrowserViewController.m
//  DailyDeals
//
//  Created by Bruce Chen on 11-12-28.
//  Copyright (c) 2011年 Sina. All rights reserved.
//

#import "BrowserViewController.h"

@implementation BrowserViewController

- (void)pop {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}

- (id)init {
	
	if (self = [super init]) {
		
		[_toolbar setBarStyle:UIBarStyleBlackTranslucent];
	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	
    [super viewWillAppear:animated];
    
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	[_toolbar setBarStyle:UIBarStyleBlackOpaque];
	[self.navigationController setToolbarHidden:YES];
	
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:176.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    /*
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0f) {
        
        
    } else {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar1.png"] forBarMetrics:UIBarMetricsDefault];
    }
     */
}

- (void)viewDidLoad {
    
    _toolbar.tintColor = nil;
	[_toolbar setBarStyle:UIBarStyleBlackOpaque];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"完成" 
                                                                               style:UIBarButtonItemStyleBordered 
                                                                              target:self 
                                                                              action:@selector(pop)] autorelease];
    [super viewDidLoad];
}




@end
