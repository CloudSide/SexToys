//
//  UpdateCheck.m
//  VDiskMobile
//
//  Created by Bruce on 11-10-12.
//  Copyright 2011 Sina. All rights reserved.
//

#import "UpdateCheck.h"


@implementation UpdateCheck
@synthesize delegate = _delegate;
@synthesize errMsg = _errMsg;

@synthesize info = _info;

- (void)_alert {

	NSLog(@"%@", _info);
    [self.delegate hasNewVersion];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
													message:[_info objectForKey:@"message"] 
												   delegate:self 
										  cancelButtonTitle:@"取消" 
										  otherButtonTitles:@"现在更新", nil];
	
	[alert show];
	[alert release];
}

- (void)_hintInfo {
    
   [self.delegate noNewVersion];
}

- (void)_checkFailed {
    
    [self.delegate checkFailed:self.errMsg];
}

- (void)_updateCheck {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	ASIHTTPRequest *checkRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kUploadCheckURL]];
    //[checkRequest setNumberOfTimesToRetryOnTimeout:3];
	[checkRequest startSynchronous];
	
	NSError *error = [checkRequest error];
	
	if (!error) {
		
		NSDictionary *response = [[checkRequest responseString] JSONValue];
		
		if ([response isKindOfClass:[NSDictionary class]]) {
			
			NSString *version = [response objectForKey:@"version"];
			NSString *url = [response objectForKey:@"url"];
			NSString *message = [response objectForKey:@"message"];
			
			if (version && message && url && ([version compare:[Static infoValueForKey:@"CFBundleShortVersionString"]]== NSOrderedDescending)) {
   			
                self.info = response;
                [self performSelectorOnMainThread:@selector(_alert) withObject:nil waitUntilDone:YES];
			
            } else {
          
                [self performSelectorOnMainThread:@selector(_hintInfo) withObject:nil waitUntilDone:YES];
            }
		
        }   else {
            
            [self performSelectorOnMainThread:@selector(_hintInfo) withObject:nil waitUntilDone:YES];
        }
    
	} else {
        
      self.errMsg = [error localizedDescription];
      [self performSelectorOnMainThread:@selector(_checkFailed) withObject:nil waitUntilDone:YES];
    
    }
	
    [pool release];
}

- (void)check {
	
	[self performSelectorInBackground:@selector(_updateCheck) withObject:nil];
}

- (void)dealloc {
  
	[_info release];
    self.errMsg = nil;
	[super dealloc];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (buttonIndex == 1) {
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_info objectForKey:@"url"]]];
	}
}




@end
