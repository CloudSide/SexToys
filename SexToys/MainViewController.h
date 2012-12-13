//
//  MasterViewController.h
//  VDiskMobile
//
//  Created by Bruce on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSlideViewController.h"
#import "UpdateCheck.h"


@interface MainViewController : UITabBarController <UITabBarControllerDelegate> {
    
}


@property (strong, nonatomic) MainSlideViewController *navigationController1;
@property (strong, nonatomic) UINavigationController *navigationController2;
@property (strong, nonatomic) UINavigationController *navigationController3;
@property (strong, nonatomic) UINavigationController *navigationController4;
@property (strong, nonatomic) UINavigationController *navigationController5;

@property (strong, nonatomic) UpdateCheck *updateCheck;


- (void)makeTabBarHidden:(BOOL)hide;
- (void)makeTabBarHidden:(BOOL)hide animated:(BOOL)animated;


@end
