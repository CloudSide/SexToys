//
//  ListViewController.h
//  DailyDeals
//
//  Created by Bruce Chen on 11-12-23.
//  Copyright (c) 2011年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "ContentController.h"
#import "BridgeViewController.h"

@interface ListViewController : BridgeViewController <ASIHTTPRequestDelegate>

@property (nonatomic, strong) ASIFormDataRequest *request;
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic) unsigned int page;
@property (nonatomic) BOOL loadingLock;
@property (nonatomic, retain) NSDictionary *userinfo;
@property (nonatomic, retain) NSString *cateId;
@property (nonatomic, retain) NSString *cateName;
@property (nonatomic, assign) BOOL isFav;


#pragma mark -
#pragma mark JavascriptBridge

- (void)JSLog:(NSDictionary *)parm;
- (void)loadmore:(NSDictionary *)parm;
- (void)selected:(NSDictionary *)parms;
- (void)requestListData;

@end
