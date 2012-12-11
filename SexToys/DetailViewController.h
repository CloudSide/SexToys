//
//  DetailViewController.h
//  DailyDeals
//
//  Created by Bruce Chen on 11-12-27.
//  Copyright (c) 2011年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
//#import "BrowserViewController.h"
#import "ReviewViewController.h"
#import "BridgeViewController.h"
#import "BarItemController.h"
#import "ContentController.h"

@class ContentController;

@interface DetailViewController : BridgeViewController <MBProgressHUDDelegate>

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSDictionary *itemData;

@property (nonatomic, strong) BarItemController *barComment;
@property (nonatomic, strong) BarItemController *barLike;
@property (nonatomic, strong) BarItemController *barShare;

@property (nonatomic, strong) ASIFormDataRequest *loadRequest;
@property (nonatomic, strong) ASIFormDataRequest *praiseRequest;

@property (nonatomic, assign) ContentController *contentController;
@property (nonatomic, assign) BOOL isFaved;


- (void)praise;
- (void)reviews;

@end
