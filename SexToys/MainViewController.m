//
//  MasterViewController.m
//  VDiskMobile
//
//  Created by Bruce on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "CateViewController.h"
#import "TopicViewController.h"
#import "ListViewController.h"
#import "PSViewController.h"
#import "SettingsViewController.h"

@interface MainViewController () {
    

}

@end

@implementation MainViewController

@synthesize navigationController1 = _navigationController1;
@synthesize navigationController2 = _navigationController2;
@synthesize navigationController3 = _navigationController3;
@synthesize navigationController4 = _navigationController4;
@synthesize navigationController5 = _navigationController5;


- (void)setTheControllers {

    self.viewControllers = [NSArray arrayWithObjects:self.navigationController1, self.navigationController2, self.navigationController3, self.navigationController4, self.navigationController5, nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
            
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
        
        self.delegate = self;
        
    }
    
    return self;
}



							
- (void)dealloc {
    
    [_navigationController1 release];
    [_navigationController2 release];
    [_navigationController3 release];
    [_navigationController4 release];
    [_navigationController5 release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {

    
    if (_navigationController1 == nil || _navigationController2 == nil || _navigationController3 == nil || _navigationController4 == nil || _navigationController5 == nil) {
        
        [self setTheControllers];
    }
    
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setTheControllers];
}


- (UINavigationController *)navigationController1 {

    if (_navigationController1 == nil) {
        
        _navigationController1 = [[MainSlideViewController alloc] initWithNibName:@"SlideViewController" bundle:nil];
        _navigationController1.delegate = _navigationController1;
        _navigationController1.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"热门" image:[UIImage imageNamed:@"hot.png"] tag:1] autorelease];
        
    }
    
    return (UINavigationController *)_navigationController1;
}

- (UINavigationController *)navigationController2 {
    

    if (_navigationController2 == nil) {
        
        CateViewController *viewController = [[[CateViewController alloc] initWithNibName:@"CateViewController" bundle:nil] autorelease];
        viewController.title = @"分类";
        _navigationController2 = [[UINavigationController alloc] initWithRootViewController:viewController];
        _navigationController2.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"分类" image:[UIImage imageNamed:@"thumbs.png"] tag:2] autorelease];
    }
    
    return _navigationController2;

}

- (UINavigationController *)navigationController3 {
    

    if (_navigationController3 == nil) {
        
        TopicViewController *viewController = [[[TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil] autorelease];
        viewController.title = @"交流";
        _navigationController3 = [[UINavigationController alloc] initWithRootViewController:viewController];
        _navigationController3.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"交流" image:[UIImage imageNamed:@"ico_comments.png"] tag:3] autorelease];
    }
    
    return _navigationController3;

}

- (UINavigationController *)navigationController4 {
    
    if (_navigationController4 == nil) {
        
        PSViewController *viewController = [[[PSViewController alloc] initWithNibName:@"PSViewController_iPhone" bundle:nil] autorelease];
        viewController.isFav = YES;
        viewController.title = @"收藏";
        _navigationController4 = [[UINavigationController alloc] initWithRootViewController:viewController];
        _navigationController4.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"收藏" image:[UIImage imageNamed:@"ico_like_big.png"] tag:4] autorelease];
    }
    
    return _navigationController4;

}

- (UINavigationController *)navigationController5 {
    
    
    if (_navigationController5 == nil) {
        
        SettingsViewController *viewController = [[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil] autorelease];
        viewController.title = @"设置";
        _navigationController5 = [[UINavigationController alloc] initWithRootViewController:viewController];
        _navigationController5.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"setting.png"] tag:5] autorelease];
    }
    

    return _navigationController5;

}


- (void)viewDidUnload {
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    } else {
    
        return YES;
    }
}

#pragma mark - UITabBarControllerDelegate

/*
 * This method is for umeng
 * 
 */

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if (viewController == _navigationController1) {

        
    } else if (viewController == _navigationController2) {


    } else if (viewController == _navigationController3) {

        
    } else if (viewController == _navigationController4) {

        
    } else if (viewController == _navigationController5) {

    }
}

- (void)makeTabBarHidden:(BOOL)hide {
    
	[self makeTabBarHidden:hide animated:YES];
}

- (void)makeTabBarHidden:(BOOL)hide animated:(BOOL)animated {
    
    if ([self.view.subviews count] < 2)
		return;
    
	UIView *contentView;
    
    if (animated) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
    }
    
	if ([[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
		contentView = [self.view.subviews objectAtIndex:1];
	else
		contentView = [self.view.subviews objectAtIndex:0];
    
	if (hide) {
        
		contentView.frame = self.view.bounds;
        
    } else {
		contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.y,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height - self.tabBar.frame.size.height);
	}
    
	self.tabBar.hidden = hide;
    if (animated) {
            
        [UIView commitAnimations];
    }
}

@end
