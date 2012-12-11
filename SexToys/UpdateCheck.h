//
//  UpdateCheck.h
//  VDiskMobile
//
//  Created by Bruce on 11-10-12.
//  Copyright 2011 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@protocol UpdateCheckDelegate <NSObject>
- (void)noNewVersion;
- (void)hasNewVersion;
- (void)checkFailed:(NSString *)errMsg;
@end

@interface UpdateCheck : NSObject <UIAlertViewDelegate> {

	  NSDictionary *_info;
    id<UpdateCheckDelegate>            _delegate;  
    NSString     *_errMsg;
}

- (void)check;

@property (nonatomic, retain) NSDictionary *info;
@property (nonatomic, assign) id<UpdateCheckDelegate> delegate;
@property (nonatomic, retain) NSString *errMsg;
@end
