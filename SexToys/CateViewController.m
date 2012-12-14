//
//  ListViewController.m
//  DailyDeals
//
//  Created by Bruce Chen on 11-12-23.
//  Copyright (c) 2011年 Sina. All rights reserved.
//

#import "CateViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "ListViewController.h"
#import "PSViewController.h"
#import "ASIDownloadCache.h"


@implementation CateViewController

@synthesize request = _request;
@synthesize loadingLock = _loadingLock;
@synthesize userinfo = _userinfo;
@synthesize updateCache = _updateCache;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

        self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
        _loadingLock = NO;
        _updateCache = NO;
        
    }
    
    return self;
}

/*
- (void)didReceiveMemoryWarning {
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
 */

#pragma mart -

- (void)reloadData {
    
    [_webView reload];
}

- (void)refresh {

    if (_loadingLock) {
        
        [self stopLoading];
        return;        
    }
    
    _updateCache = YES;
    
    [self reloadData];
}

- (void)loadingStatus {

    UIActivityIndicatorView *uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    uiBusy.hidesWhenStopped = YES;
    [uiBusy startAnimating];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:uiBusy] autorelease];
    [uiBusy release];
}

- (void)loadedStatus {
        
    
    [self stopLoading];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(refresh)] autorelease];
}



#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_logo.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:176.0/255.0 alpha:1.0]];
    
    [self loadedStatus];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"www/cate.html" ofType:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0]];
    
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return NO;
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
        
    _request.delegate = nil;
    [_request release];
    [_userinfo release];
    
    [super dealloc];
}

- (void)requestListData {

    if (_loadingLock) {
        
        return;        
    }
    
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kApiCatesURL]];
    
    [_request setDownloadCache:[ASIDownloadCache sharedCache]];
    [_request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];//ASIAskServerIfModifiedCachePolicy
    [_request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [_request setAllowCompressedResponse:YES];
    [_request setShouldWaitToInflateCompressedResponses:NO];
    [_request setShouldAttemptPersistentConnection:YES];
    //[_request setNumberOfTimesToRetryOnTimeout:3];
    [_request setShouldAttemptPersistentConnection:YES];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"loadCate" forKey:@"action"];
    
    [_request setUserInfo:userInfo];
        
    _request.delegate = self;
    [_request startAsynchronous];
    
}

#pragma mark -
#pragma mark JavascriptBridge

- (void)JSLog:(NSDictionary *)parm {

    NSLog(@"JSLog: %@", parm);
}

- (void)loadCate:(NSDictionary *)parms {

    if (_updateCache) {
        
        [self requestListData];
        
    } else {
    
        if ([[LdbHandler sharedDb] getDictionary:@"cate_list_data"]) {
        
            NSDictionary *cateInfo = [[LdbHandler sharedDb] getDictionary:@"cate_list_data"];
            
            if ([cateInfo isKindOfClass:[NSDictionary class]] && [[cateInfo objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                
                //NSArray *item = (NSArray *)[[[LdbHandler sharedDb] getDictionary:@"cate_list_data"] objectForKey:@"data"];
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"load_success(%@)", [cateInfo JSONRepresentation]]];
            
            } else {
            
                [self requestListData];
            }
            
        } else {
        
           [self requestListData]; 
        }
    }
    
}

- (void)selected:(NSDictionary *)parms {
    
    PSViewController *listViewController = [[[PSViewController alloc] initWithNibName:@"PSViewController_iPhone" bundle:nil] autorelease];
    listViewController.cateId = [parms objectForKey:@"cate_id"];
    [self.navigationController pushViewController:listViewController animated:YES];
    
    DDLogInfo(@"%@\t%@", @"category", [parms objectForKey:@"cate_id"]);
    
    
/*
    ListViewController *listViewController = [[[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil] autorelease];
    listViewController.cateId = [parms objectForKey:@"cate_id"];
    [self.navigationController pushViewController:listViewController animated:YES];
 */
    
}

#pragma ASIHttpRequestDelegate
#pragma -

- (void)requestStarted:(ASIHTTPRequest *)request {
    
    [self loadingStatus];
    
    _loadingLock = NO;
    
    if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"loadCate"]) {
        
       // [self.webView stringByEvaluatingJavaScriptFromString:@"loadmore_loading('正在加载...');"];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    [self loadedStatus];
    
    _loadingLock = NO;
    
    if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"loadCate"]) {
        
        //NSLog(@"%@", [request responseString]);
        
        if ([[[[request responseString] JSONValue] objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            
            NSArray *item = (NSArray *)[[[request responseString] JSONValue] objectForKey:@"data"];
            
            if ([item isKindOfClass:[NSArray class]]) {
                
                [[LdbHandler sharedDb] putObject:[[request responseString] JSONValue] forKey:@"cate_list_data"];
            }
            
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"load_success(%@)", [request responseString]]];
            
            return;
        }
     
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"load_fail('获取列表失败: 服务器繁忙');"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    [self loadedStatus];
    
    _loadingLock = NO;
    
    if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"loadCate"]) {
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"load_fail('获取列表失败: 网络连接不可用');"];
    }
}


@end
