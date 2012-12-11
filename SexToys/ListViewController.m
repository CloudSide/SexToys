//
//  ListViewController.m
//  DailyDeals
//
//  Created by Bruce Chen on 11-12-23.
//  Copyright (c) 2011年 Sina. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"


@implementation ListViewController

@synthesize request = _request;
@synthesize UUID = _UUID;
@synthesize listData = _listData;
@synthesize page = _page;
@synthesize loadingLock = _loadingLock;
@synthesize userinfo = _userinfo;
@synthesize cateId = _cateId;
@synthesize cateName = _cateName;
@synthesize isFav = _isFav;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

        self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
        self.UUID = [[NSUserDefaults standardUserDefaults] stringForKey:kUUID];
        _listData = [[NSMutableArray alloc] init];
        _page = 1;
        _loadingLock = NO;
        _isFav = NO;
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
    
    _page = 1;
    
    //[self requestListData];
    [_webView reload];
}

- (void)refresh {

    if (_loadingLock) {
        
        [self stopLoading];
        return;        
    }
    
    //[_webView stringByEvaluatingJavaScriptFromString:@"goTop();"];
    
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

- (void)viewWillAppear:(BOOL)animated {
    
    [[AppDelegate sharedAppDelegate].navigationController setNavigationBarHidden:YES];
    [super viewDidAppear:animated];
    
    if (_isFav) {
        
        //[self refresh];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_logo.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:176.0/255.0 alpha:1.0]];
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];

    
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    /*
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 35.0f, 35.0f)] autorelease];
    [button setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    //[button addTarget:self action:@selector(popNavigationItemAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.backBarButtonItem = [barButtonItem autorelease];
    */
    
    [self loadedStatus];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"www/index.html" ofType:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0]];
    
    if (_cateName) {
        
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        titleLabel.shadowColor = [UIColor whiteColor];
        [titleLabel setShadowOffset:CGSizeMake(0, -1)];
        titleLabel.text = _cateName;
        self.navigationItem.titleView = titleLabel;
    }
    
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
    
    [_UUID release];
    [_cateId release];
    _request.delegate = nil;
    [_request release];
    [_listData release];
    [_userinfo release];
    [_cateName release];
    
    [super dealloc];
}

- (void)requestListData {

    if (_loadingLock) {
        
        return;        
    }
    
    if (_cateId) {
        
        self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[@"http://www.worldgogo.com/xjb/cats.php" stringByAppendingFormat:@"?t=%@&pgno=%d", _cateId, _page]]];
        
    } else {
    
        self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[kApiItemsURL stringByAppendingFormat:@"?t=%@&pgno=%d", [_userinfo objectForKey:@"type"], _page]]];
    }
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"loadmore" forKey:@"action"];
    [_request setUserInfo:userInfo];
    
    
    [_request addRequestHeader:@"User-Device" value:[NSString stringWithFormat:@"%@/guest", _UUID]];
    
    _request.delegate = self;
    [_request startAsynchronous];
    
}

#pragma mark -
#pragma mark JavascriptBridge

- (void)JSLog:(NSDictionary *)parm {

    NSLog(@"JSLog: %@", parm);
}

- (void)loadmore:(NSDictionary *)parms {

    [self loadingStatus];
    
    if (_isFav) {
        
        NSArray *allKeys = [[LdbHandler sharedDb] allKeys];
        
        if (allKeys > 0) {
            
            NSMutableArray *items = [[NSMutableArray alloc] init];

            for (NSString *value in allKeys) {
                
                if ([value rangeOfString:@"fav_"].location == 0) {
                    
                    NSDictionary *item = [[LdbHandler sharedDb] getDictionary:value];
                    
                    if (item && [item isKindOfClass:[NSDictionary class]]) {
                        
                        [items addObject:item];
                    }
                }
            }
        
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"reload_fav_success(%@)", [items JSONRepresentation]]];

            self.listData = items;
            [items release];
            
            [self loadedStatus];
            _loadingLock = NO;
        }
        
    } else {
        
        [self requestListData];
    }
}

- (void)selected:(NSDictionary *)parms {

    /*
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailViewController.gid = [NSString stringWithFormat:@"%@", [parms objectForKey:@"id"]];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
     */


    ContentController *contentController = [[ContentController alloc] initWithNibName:@"ContentController" bundle:nil];
    contentController.contentList = _listData;
    contentController.currentPage = [[parms objectForKey:@"id"] integerValue];
    [[AppDelegate sharedAppDelegate].navigationController pushViewController:contentController animated:YES];
    [contentController release];

}

#pragma ASIHttpRequestDelegate
#pragma -

- (void)requestStarted:(ASIHTTPRequest *)request {
    
    [self loadingStatus];
    
    _loadingLock = NO;
    
    if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"loadmore"]) {
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"loadmore_loading('正在加载...');"];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    [self loadedStatus];
    
    _loadingLock = NO;
    
    //if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"loadmore"]) {
        
        //NSLog(@"%@", [request responseString]);
        
        if ([[[request responseString] JSONValue] isKindOfClass:[NSArray class]]) {
            
            //NSDictionary *data = [[request responseString] JSONValue];
            
            //if ([[data objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                                
                NSArray *item = (NSArray *)[[request responseString] JSONValue];
                
                if (_page == 1) {
                                    
                    [_listData removeAllObjects];
                } 
                
                [_listData addObjectsFromArray:item];
                
                //NSLog(@"%@", [item JSONRepresentation]);
                
                if (_page == 1) {
                                        
                    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"reload_success(%@)", [item JSONRepresentation]]];
                                        
                } else {
                    
                    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadmore_success(%@)", [item JSONRepresentation]]];
                }
                
                _page++;
                                
                return;
            }
        //}
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"loadmore_fail('获取列表失败: 服务器繁忙');"];
    //}
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    [self loadedStatus];
    
    _loadingLock = NO;
    
    if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"loadmore"]) {
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"loadmore_fail('获取列表失败: 网络连接不可用');"];
    }
}


@end
