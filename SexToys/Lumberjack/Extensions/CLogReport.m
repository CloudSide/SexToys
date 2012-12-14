//
//  CLogReport.m
//  VDiskMobile
//
//  Created by Bruce on 12-12-4.
//
//

#import "CLogReport.h"
#import "VdiskUtil.h"

static CLogReport *kSharedLogReport = nil;

@interface CLogReport () {

    ASIFormDataRequest *_request;
    NSString *_logsDirectory;
    NSMutableArray *_logFiles;
    NSString *_reportURL;
    
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	UIBackgroundTaskIdentifier _backgroundTask;
#endif
    
}

- (void)backgroundTask;

@end



@implementation CLogReport


- (void)backgroundTask {
    
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	
	UIDevice *device = [UIDevice currentDevice];
	BOOL backgroundSupported = NO;
    
	if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
		
		backgroundSupported = device.multitaskingSupported;
	}
	
	if (backgroundSupported) {
		
		_backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler: ^ {
            
			// Synchronize the cleanup call on the main thread in case
			// the task actually finishes at around the same time.
			dispatch_async(dispatch_get_main_queue(), ^ {
				
				if (_backgroundTask != UIBackgroundTaskInvalid) {
					
					[[UIApplication sharedApplication] endBackgroundTask:_backgroundTask];
					_backgroundTask = UIBackgroundTaskInvalid;
                }
                
			});
		}];
	}
	
#endif
	
}


- (id)initWithLogsDirectory:(NSString *)logsDirectory {

    if (self = [super init]) {
        
        _logsDirectory = [logsDirectory copy];
        _reportURL = [@"https://rest.sinaapp.com/logs/report.php" retain];
        
        _logFiles = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

+ (void)setSharedLogReport:(CLogReport *)logReport {

    if (kSharedLogReport != nil) {
        
        [kSharedLogReport release], kSharedLogReport = nil;
    }
    
    kSharedLogReport = [logReport retain];
}

+ (id)sharedLogReport {

    return kSharedLogReport;
}

- (void)fire {
    
    [self backgroundTask];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:_logsDirectory] && ![_request isExecuting]) {
            
            
            long expires = time((time_t *)NULL) + 3600 * 24;
            NSString *expiresString = [NSString stringWithFormat:@"%ld", expires];
            
            /*
             NSMutableDictionary *xVdiskHeaders = [[NSMutableDictionary alloc] init];
             
             for (NSString *keyString in [[_request requestHeaders] allKeys]) {
             
             NSString *lowerKeyString = [keyString lowercaseString];
             
             if ([lowerKeyString rangeOfString:@"x-vdisk-"].location != NSNotFound) {
             
             [xVdiskHeaders setValue:[[_request requestHeaders] objectForKey:keyString] forKey:lowerKeyString];
             }
             }
             
             
             NSArray *xVdiskHeadersKeySortStrings = [[xVdiskHeaders allKeys] sortedArrayUsingSelector:@selector(compare:)];
             
             NSMutableArray *xVdiskSortedHeaders = [[NSMutableArray alloc] init];
             
             for (NSString *lowerKeyString in xVdiskHeadersKeySortStrings) {
             
             [xVdiskSortedHeaders addObject:[NSString stringWithFormat:@"%@:%@", lowerKeyString, [xVdiskHeaders objectForKey:lowerKeyString]]];
             }
             
             [xVdiskHeaders release];
             
             NSString *xVdiskHeadersString = [xVdiskSortedHeaders componentsJoinedByString:@"\n"];
             
             [xVdiskSortedHeaders release];
             */
                        
            NSURL *parsedURL = [NSURL URLWithString:_reportURL];
            
            NSString *destURI = nil;
            
            if (parsedURL.query) {
                
                destURI = [NSString stringWithFormat:@"%@?%@", [parsedURL path], parsedURL.query];
                
            } else {
                
                destURI = [NSString stringWithString:[parsedURL path]];
            }
            
            NSString *stringToSign = [NSString stringWithFormat:@"%@\n\n%@\n%@\n%@", @"POST", expiresString, @"", destURI];
            
            NSString *sign = [[[[stringToSign HMACSHA1EncodedDataWithKey:kVdiskAppsecret] base64EncodedString] substringWithRange:NSMakeRange(5, 10)] URLEncodedString];
            
            NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
            NSString *urlString = [NSString stringWithFormat:@"%@%@app_key=%@&expire=%@&ssig=%@", _reportURL, queryPrefix, kVdiskAppkey, expiresString, sign];
            
            
            [_request release], _request = nil;
            
            _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithString:urlString]]];
            _request.delegate = self;
            [_request setNumberOfTimesToRetryOnTimeout:3];
            [_request setValidatesSecureCertificate:NO];
            [_request setUseCookiePersistence:NO];
            [_request setUseSessionPersistence:NO];
            [_request setShouldRedirect:NO];
            [_request setRequestMethod:@"POST"];
            [_request setShouldAttemptPersistentConnection:YES];
            [_request setTimeOutSeconds:60];
            //[_request addRequestHeader:@"Host" value:@"content.vdisk.me"];
            
            NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:_logsDirectory error:nil];
            
            NSLog(@"%@", tempArray);
            
            [_logFiles removeAllObjects];
            
            for (NSString *fileName in tempArray) {
                
                if ([[fileName substringToIndex:1] isEqualToString:@"."]) {
                    
                    continue;
                }
                
                if ([fileName rangeOfString:@".archived.txt.gz"].location != NSNotFound || [fileName rangeOfString:@".txt.gz"].location != NSNotFound) {
                    
                    NSString *fullPath = [_logsDirectory stringByAppendingPathComponent:fileName];
                    [_logFiles addObject:fullPath];
                    [_request addFile:fullPath forKey:@"logs[]"];
                }
            }
            
            if ([_logFiles count] > 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [_request setPostValue:@"true" forKey:@"gzip"];
                    //[_request setPostValue:@"true" forKey:@"debug"];
                    
                    [_request start];
                
                });
            }
        }
        
    });

    
}

- (void)dealloc {

    [_logsDirectory release];
    
    [_request clearDelegatesAndCancel];
    [_request release];
    [_logFiles release];
    
    [_reportURL release];
    
    [super dealloc];
}

#pragma mark - ASIHTTPRequestDelegate


- (void)requestStarted:(ASIHTTPRequest *)request {

    NSLog(@"开始上传日志");
}


/*
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    
    DDLogVerbose(@"开始上传日志");
}*/

- (void)requestFinished:(ASIHTTPRequest *)request {

    //NSLog(@"%@", [request requestHeaders]);
    
    NSLog(@"%d:%@", [request responseStatusCode], [request responseStatusMessage]);
    
    NSLog(@"%@", [request responseString]);
    
    if (request.responseStatusCode / 100 == 2) {
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            for (NSString *path in _logFiles) {
                
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
            
            NSLog(@"删除完成");
            NSLog(@"%@", _logFiles);
            NSLog(@"上传完成");
        
        });
    
    } else {
    
        NSLog(@"上传日志失败");
    }
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    NSLog(@"上传日志失败");
}


@end
