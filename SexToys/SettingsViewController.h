//
//  SettingsViewController.h
//  SexToys
//
//  Created by Bruce on 12-12-10.
//  Copyright (c) 2012年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UpdateCheck.h"

@interface SettingsViewController : UITableViewController <MBProgressHUDDelegate, UpdateCheckDelegate> {

    UIActivityIndicatorView *_indicatorView;
    UpdateCheck   *_updateCheck;
}


@property (nonatomic, retain) MBProgressHUD *hud;

@end
