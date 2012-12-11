//
//  TopicViewController.m
//  SexToys
//
//  Created by Bruce on 12-12-8.
//  Copyright (c) 2012年 Bruce. All rights reserved.
//

#import "TopicViewController.h"

@implementation TopicViewController

@synthesize loadingLock = _loadingLock;
@synthesize contentURL = _contentURL;
@synthesize flag = _flag;

- (void)dealloc {

    [_contentURL release];
    [super dealloc];
}

- (void)reloadData {
    
    [_webView reload];
}

- (void)refresh {
    
    if (_loadingLock) {
        
        [self stopLoading];
        return;
    }
    
    [self reloadData];
}

- (void)loadingStatus {
    
    UIActivityIndicatorView *uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    uiBusy.hidesWhenStopped = YES;
    [uiBusy startAnimating];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:uiBusy] autorelease];
    [uiBusy release];
    _loadingLock = YES;

}

- (void)loadedStatus {
    
    [self stopLoading];
    self.navigationItem.rightBarButtonItem = nil;
    _loadingLock = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    [self loadedStatus];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [self loadedStatus];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self loadingStatus];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
        _loadingLock = NO;
        _contentURL = nil;
        _flag = 0;
        
    }
    
    return self;
}

- (void)openURL:(NSDictionary *)parms {

    TopicViewController *viewController = [[[TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil] autorelease];
    viewController.contentURL = [parms objectForKey:@"url"];
    viewController.flag = _flag + 1;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)backAndRefresh:(NSDictionary *)parms {
    
    for (TopicViewController *controller in [self.navigationController viewControllers]) {
        
        if (controller.flag == _flag - 1) {
            
            [controller refresh];
            break;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)back:(NSDictionary *)parms {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToRoot:(NSDictionary *)parms {

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)refresh:(NSDictionary *)parms {
    
    [self refresh];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_logo.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:176.0/255.0 alpha:1.0]];
    
    
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"htp://worldgogo.com/xjb/forum.htmlt" ofType:nil];
    
    if (_contentURL == nil) {
        
        self.contentURL = @"http://worldgogo.com/xjb/topic.php";
        
    } else {
    
        self.contentURL = [_contentURL stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_contentURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0]];
    
}

@end
