//
//  ReviewViewController.h
//  DailyDeals
//
//  Created by Bruce Chen on 11-12-28.
//  Copyright (c) 2011年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"

@interface ReviewViewController : UITableViewController <UITextViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UITextView *textContainer;

@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) MBProgressHUD *hud;

@end
