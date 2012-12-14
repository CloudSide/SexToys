//
//  DetailViewController.m
//  DailyDeals
//
//  Created by Bruce Chen on 11-12-27.
//  Copyright (c) 2011年 Sina. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "ASIDownloadCache.h"
#import "SVWebViewController.h"


@implementation DetailViewController


@synthesize page = _page;
@synthesize UUID = _UUID;
@synthesize hud = _hud;
@synthesize itemData = _itemData;
@synthesize barComment = _barComment;
@synthesize barLike = _barLike;
@synthesize barShare = _barShare;
@synthesize loadRequest = _loadRequest;
@synthesize praiseRequest = _praiseRequest;
@synthesize contentController = _contentController;
@synthesize isFaved = _isFaved;

- (void)loadingStatus {
    
    /*
    UIActivityIndicatorView *uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    uiBusy.hidesWhenStopped = YES;
    [uiBusy startAnimating];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:uiBusy] autorelease];
    [uiBusy release];
     */
}

- (void)loadedStatus {
    
    [self stopLoading];
    
    /*
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(reloadData)] autorelease];
     
     */
}


- (void)reloadData {
    
    [_webView stringByEvaluatingJavaScriptFromString:@"startload();"];
}

- (void)refresh {
    
    [self reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = @"商品信息";
        self.UUID = [[NSUserDefaults standardUserDefaults] stringForKey:kUUID];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma JavascriptBridge
#pragma -

- (void)_startload:(NSDictionary *)parms {

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [self performSelectorOnMainThread:@selector(loadingStatus) withObject:nil waitUntilDone:NO];
    
    [_webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:[NSString stringWithFormat:@"load_view(%@);", [[self.contentController.contentList objectAtIndex:_page] JSONRepresentation]] waitUntilDone:NO];

    [_webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:@"loading('正在加载...');" waitUntilDone:NO];
    
    NSString *goodsUrlString = [[self.contentController.contentList objectAtIndex:_page] objectForKey:@"click_url"];
    
    self.loadRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[kApiItemURL stringByAppendingFormat:@"&url=%@", [goodsUrlString URLEncodedString]]]];
    
    [_loadRequest setDownloadCache:[ASIDownloadCache sharedCache]];
    [_loadRequest setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];//ASIAskServerIfModifiedCachePolicy
    [_loadRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [_loadRequest setAllowCompressedResponse:YES];
    [_loadRequest setShouldWaitToInflateCompressedResponses:NO];
    [_loadRequest setShouldAttemptPersistentConnection:YES];
    //[_loadRequest setNumberOfTimesToRetryOnTimeout:3];
    [_loadRequest setShouldAttemptPersistentConnection:YES];

    [_loadRequest addRequestHeader:@"User-Device" value:[NSString stringWithFormat:@"%@/guest", _UUID]];
    [_loadRequest startSynchronous];
        
    [self performSelectorOnMainThread:@selector(loadedStatus) withObject:nil waitUntilDone:NO];
    
    NSError *error = [_loadRequest error];
	
	if (!error) {
    
        if ([[[_loadRequest responseString] JSONValue] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *data = [[_loadRequest responseString] JSONValue];
            
            //NSLog(@"%@", data);
            //NSLog(@"%@", self.contentController.currentItem);
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                                
                //self.itemData = data;
                
                /*
                [_barLike setCountValue:[NSString stringWithFormat:@"%@", [item objectForKey:@"Like"]]];
                [_barComment setCountValue:[NSString stringWithFormat:@"%d", [(NSArray *)[item objectForKey:@"Reviews"] count]]];
                */
                
                //NSLog(@"%@", data);
                 
                [_webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:[NSString stringWithFormat:@"load_success(%@);", [data JSONRepresentation]] waitUntilDone:NO];
                
                return;
            }
        }
        
        
        [_webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:@"load_fail('获取数据: 服务器繁忙');" waitUntilDone:NO];
    
    } else {
            
        [_webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:@"load_fail('获取数据: 网络连接不可用');" waitUntilDone:NO];
    }
    
    [pool release];
    
}

- (void)startload:(NSDictionary *)parms {

    /*
    _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:_hud];
    _hud.delegate = self;
    _hud.labelText = @"正在加载...";
	_hud.dimBackground = YES;
    [_hud show:YES];
    [_hud showWhileExecuting:@selector(_startload:) onTarget:self withObject:parms animated:YES];
    */
    
    [self performSelectorInBackground:@selector(_startload:) withObject:nil];
}

- (void)_praise:(NSDictionary *)parms {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    //sleep(0.6);
    
    
    if (_isFaved) {
        
        NSDictionary *obj = self.contentController.currentItem;
        [[LdbHandler sharedDb] deleteObject:[@"fav_" stringByAppendingFormat:@"%@", [obj objectForKey:@"num_iid"]]];
        
        _isFaved = NO;
        [_barLike.button setImage:[UIImage imageNamed:@"ico_like_small.png"] forState:UIControlStateNormal];
        _hud.labelText = @"收藏 -1";
        
        DDLogInfo(@"%@\t%@", @"unfavorite", [obj objectForKey:@"num_iid"]);
        
    } else {
        
        NSDictionary *obj = self.contentController.currentItem;
        [[LdbHandler sharedDb] putObject:obj forKey:[@"fav_" stringByAppendingFormat:@"%@", [obj objectForKey:@"num_iid"]]];
        
        _isFaved = YES;
        [_barLike.button setImage:[UIImage imageNamed:@"ico_like_small_s.png"] forState:UIControlStateNormal];
        _hud.labelText = @"收藏 +1";
        
        DDLogInfo(@"%@\t%@", @"favorite", [obj objectForKey:@"num_iid"]);
    }
    
    
    _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    _hud.mode = MBProgressHUDModeCustomView;
    
    
    sleep(1.6);
    
    [pool release];
}

- (void)praise:(NSDictionary *)parms {

    _hud = [[MBProgressHUD alloc] initWithView:_contentController.navigationController.view];
	[_contentController.navigationController.view addSubview:_hud];
    _hud.delegate = self;
    _hud.labelText = @"正在收藏...";
	_hud.dimBackground = YES;
    [_hud show:YES];
    [_hud showWhileExecuting:@selector(_praise:) onTarget:self withObject:parms animated:YES];
}

- (void)openURL:(NSDictionary *)parms {
    

    DDLogInfo(@"%@\t%@", @"buy", [self.contentController.currentItem objectForKey:@"num_iid"]);
    
    
    SVWebViewController *webViewController = [[[SVWebViewController alloc] initWithURL:[NSURL URLWithString:[self.contentController.currentItem objectForKey:@"click_url"]]] autorelease];
    
    webViewController.availableActions = SVWebViewControllerAvailableActionsNone | SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsCopyLink;

	[_contentController.navigationController pushViewController:webViewController animated:YES];
    
    
    /*
    UINavigationController *browserNavigationController = [[UINavigationController alloc] initWithRootViewController:browserViewController];
    //[browserNavigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [browserNavigationController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:176.0/255.0 alpha:1.0]];
    
    [browserViewController release];
    [browserNavigationController setModalPresentationStyle:UIModalPresentationFormSheet];
    [_contentController presentModalViewController:browserNavigationController animated:YES];
    [browserNavigationController release];
     */
    
    
}

- (void)reviews:(NSDictionary *)parms {
    
    ReviewViewController *reviewViewController = [[ReviewViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [_contentController.navigationController pushViewController:reviewViewController animated:YES];
    
    [reviewViewController release];
}

#pragma mark - View lifecycle

- (void)loadView {

    [super loadView];
    
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, [[AppDelegate sharedAppDelegate] window].frame.size.height-40-44-20, 320, 40)];
    [toolbar setTintColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:176.0/255.0 alpha:1.0]];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0f) {} else {
    
        [toolbar setBackgroundImage:[UIImage imageNamed:@"footer_lightpink.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
    
    
    self.barComment = [[[BarItemController alloc] initWithNibName:@"BarItem" bundle:nil] autorelease];
    self.barLike = [[[BarItemController alloc] initWithNibName:@"BarItem" bundle:nil] autorelease];
    self.barShare = [[[BarItemController alloc] initWithNibName:@"BarItem" bundle:nil] autorelease];
    
    UIBarButtonItem *barItemComment = [[[UIBarButtonItem alloc] initWithCustomView:_barComment.view] autorelease];
    UIBarButtonItem *barItemLike = [[[UIBarButtonItem alloc] initWithCustomView:_barLike.view] autorelease];
    UIBarButtonItem *barItemShare = [[[UIBarButtonItem alloc] initWithCustomView:_barShare.view] autorelease];
    UIBarButtonItem  *spaceButton = [[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    [_barComment.button setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [_barLike.button setImage:[UIImage imageNamed:@"ico_like_small.png"] forState:UIControlStateNormal];
    [_barShare.button setImage:[UIImage imageNamed:@"shopping_basket.png"] forState:UIControlStateNormal];
    
    [_barComment.button addTarget:self action:@selector(reviews) forControlEvents:UIControlEventTouchUpInside];
    [_barLike.button addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
    [_barShare.button addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    _barComment.name.text = @"店铺";
    _barLike.name.text = @"收藏";
    _barShare.name.text = @"购买";
    
    [toolbar setItems:[NSArray arrayWithObjects:barItemComment, spaceButton, barItemLike, spaceButton, barItemShare, nil] animated:NO];
    
    
    [self.view addSubview:toolbar];
    [toolbar release];

}

- (void)viewDidLoad {
    
    /*
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
    */
         
    [self loadedStatus];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"www/item.html" ofType:nil];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0]];
    
    [super viewDidLoad];

    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 35.0f, 35.0f)] autorelease];
    [button setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(popNavigationItemAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = [barButtonItem autorelease];
    
    
    
    _isFaved = !![[LdbHandler sharedDb] getDictionary:[@"fav_" stringByAppendingFormat:@"%@", [self.contentController.currentItem objectForKey:@"num_iid"]]];
    
    if (_isFaved) {
        
        [_barLike.button setImage:[UIImage imageNamed:@"ico_like_small_s.png"] forState:UIControlStateNormal];
        
    } else {
    
        
        [_barLike.button setImage:[UIImage imageNamed:@"ico_like_small.png"] forState:UIControlStateNormal];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return  NO;
}

- (void)dealloc {

    
    [_loadRequest clearDelegatesAndCancel];
    [_loadRequest release];
    
    [_praiseRequest clearDelegatesAndCancel];
    [_praiseRequest release];
    
    [_UUID release];
        
    _hud.delegate = nil;
    [_hud release];
    
    [_itemData release];
    
    [_barComment release];
    [_barLike release];
    [_barShare release];
    
    [super dealloc];
}


#pragma ASIHttpRequestDelegate
#pragma -

/*

- (void)requestStarted:(ASIHTTPRequest *)request {
    
    [self loadingStatus];
    
    if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"load"]) {
        
        [_webView stringByEvaluatingJavaScriptFromString:@"loading('正在加载...');"];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    [self loadedStatus];
    
    if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"load"]) {
        
        if ([[[request responseString] JSONValue] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *data = [[request responseString] JSONValue];
            
            if ([[data objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *item = [data objectForKey:@"data"];
                [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"load_success(%@)", [item JSONRepresentation]]];
                
                NSLog(@"%@", item);
                
                return;
            }
        }
        
        [_webView stringByEvaluatingJavaScriptFromString:@"load_fail('获取数据: 服务器繁忙');"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    [self loadedStatus];
    
    if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"load"]) {
        
        [_webView stringByEvaluatingJavaScriptFromString:@"load_fail('获取数据: 网络连接不可用');"];
    }
}
 
 */

- (void)praise {
    
    [self praise:nil];
}

- (void)reviews {
    
    SVWebViewController *webViewController = [[[SVWebViewController alloc] initWithURL:[NSURL URLWithString:[self.contentController.currentItem objectForKey:@"shop_click_url"]]] autorelease];
    
    webViewController.availableActions = SVWebViewControllerAvailableActionsNone | SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsCopyLink;
    
	[_contentController.navigationController pushViewController:webViewController animated:YES];
    
    DDLogInfo(@"%@\t%@", @"shop", [self.contentController.currentItem objectForKey:@"num_iid"]);
    
    //[self reviews:nil];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    // Remove HUD from screen when the HUD was hidded
    [_hud removeFromSuperview];
	self.hud = nil;
}

@end
