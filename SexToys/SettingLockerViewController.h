//
//  SettingLockerViewController.h
//  VDiskMobile
//
//  Created by gaopeng on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockerViewController.h"

@interface SettingLockerViewController : UITableViewController <LockerViewDelegate>

@property (nonatomic, assign) BOOL verifyPassed;
@property (nonatomic, strong) UISwitch *switchView;

@end
