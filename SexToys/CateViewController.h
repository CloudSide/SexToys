//
//  ListViewController.h
//  DailyDeals
//
//  Created by Bruce Chen on 11-12-23.
//  Copyright (c) 2011年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "BridgeViewController.h"

@interface CateViewController : BridgeViewController <ASIHTTPRequestDelegate>

@property (nonatomic, strong) ASIFormDataRequest *request;
@property (nonatomic) BOOL loadingLock;
@property (nonatomic, retain) NSDictionary *userinfo;
@property (nonatomic, assign) BOOL updateCache;


#pragma mark -
#pragma mark JavascriptBridge

- (void)JSLog:(NSDictionary *)parm;
- (void)loadCate:(NSDictionary *)parm;
- (void)selected:(NSDictionary *)parms;
- (void)requestListData;

@end
