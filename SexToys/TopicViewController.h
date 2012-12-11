//
//  TopicViewController.h
//  SexToys
//
//  Created by Bruce on 12-12-8.
//  Copyright (c) 2012年 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BridgeViewController.h"

@interface TopicViewController : BridgeViewController


@property (nonatomic) BOOL loadingLock;
@property (nonatomic, retain) NSString *contentURL;
@property (nonatomic, assign) NSInteger flag;

- (void)openURL:(NSDictionary *)parms;

@end
