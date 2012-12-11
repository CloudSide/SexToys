//
//  PullRefreshController.m
//  DailyDeals
//
//  Created by Bruce Chen on 12-1-12.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "BridgeViewController.h"
#import <QuartzCore/QuartzCore.h>

#define REFRESH_HEADER_HEIGHT 52.0f

@implementation BridgeViewController


@synthesize webView = _webView;
@synthesize scrollView = _scrollView;
@synthesize originalScrollViewDelegate = _originalScrollViewDelegate;
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;


- (void)startLoading {
    
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _scrollView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    _scrollView.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

- (void)addPullToRefreshHeader {
    
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:14.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    refreshLabel.textColor = [UIColor darkGrayColor];
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 22) / 2,
                                    (REFRESH_HEADER_HEIGHT - 22) / 2,
                                    22, 22);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    UIImageView *refreshArrowBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_loading.png"]];
    refreshArrowBg.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 30) / 2, (REFRESH_HEADER_HEIGHT - 30) / 2, 30, 30);
    
    [refreshHeaderView addSubview:refreshArrowBg];
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [_scrollView addSubview:refreshHeaderView];
    
    [refreshArrowBg release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    
        textPull = [[NSString alloc] initWithString:@"下拉更新数据"];
        textRelease = [[NSString alloc] initWithString:@"松开即可更新"];
        textLoading = [[NSString alloc] initWithString:@"正在更新数据 ..."];
    }
    
    return self;
}

- (void)dealloc {
    
    self.scrollView.delegate = nil;
    self.originalScrollViewDelegate = nil;
    
    self.scrollView = nil;

    
    [_webView stopLoading];
    _webView.delegate = nil;
    [_webView release];
    
    [refreshHeaderView release];
    [refreshLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    [textPull release];
    [textRelease release];
    [textLoading release];
    
        
    [super dealloc];
}

- (void)loadView {

    [super loadView];
    
    //_webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    _webView.delegate = self;
    [Static hideGradientBackground:_webView];
    [_webView setDataDetectorTypes:UIDataDetectorTypeNone];
    _webView.backgroundColor = [UIColor clearColor];    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0f) {
        
        for (UIView *subView in _webView.subviews) {
            
            if ([subView isKindOfClass:[UIScrollView class]]) {
                
                self.scrollView = (UIScrollView *)subView;
                self.originalScrollViewDelegate = [(UIScrollView *)subView delegate];
                _scrollView.delegate = self;
            }
        }
        
    } else {
        
        self.scrollView = _webView.scrollView;
        self.originalScrollViewDelegate = _webView.scrollView.delegate;
        _scrollView.delegate = self;
    }
    
    //self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_user.png"]];
    
    //[self.view addSubview:_webView];
}

- (void)viewDidLoad {
    
    [self addPullToRefreshHeader];
    
    [super viewDidLoad];
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    //NSLog(@"%@", NSStringFromSelector(_cmd));
    /*
    if ([_originalScrollViewDelegate respondsToSelector:_cmd]) {
        
        [_originalScrollViewDelegate scrollViewWillBeginDragging:scrollView];
    }*/
    
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //NSLog(@"%@", NSStringFromSelector(_cmd));
    /*
    if ([_originalScrollViewDelegate respondsToSelector:_cmd]) {
        
        [_originalScrollViewDelegate scrollViewDidScroll:scrollView];
    }
    */
    
    if (isLoading) {
        
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            scrollView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    //NSLog(@"%@", NSStringFromSelector(_cmd));
    
    /*
    if ([_originalScrollViewDelegate respondsToSelector:_cmd]) {
        
        [_originalScrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
     */
    
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

#pragma mark -

/*

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    //NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([_originalScrollViewDelegate respondsToSelector:_cmd]) {
        
        [_originalScrollViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    
    //NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([_originalScrollViewDelegate respondsToSelector:_cmd]) {
        
        return [_originalScrollViewDelegate scrollViewShouldScrollToTop:scrollView];
    }
    
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
    //NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([_originalScrollViewDelegate respondsToSelector:_cmd]) {
        
        [_originalScrollViewDelegate scrollViewDidScrollToTop:scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {

    //NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([_originalScrollViewDelegate respondsToSelector:_cmd]) {
        
        [_originalScrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    //NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([_originalScrollViewDelegate respondsToSelector:_cmd]) {
        
        [_originalScrollViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    //NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([_originalScrollViewDelegate respondsToSelector:_cmd]) {
        
        return [_originalScrollViewDelegate viewForZoomingInScrollView:scrollView];
    }
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {

    //NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([_originalScrollViewDelegate respondsToSelector:_cmd]) {
        
        [_originalScrollViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {

    //NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([_originalScrollViewDelegate respondsToSelector:_cmd]) {
        
        [_originalScrollViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {

    //NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([_originalScrollViewDelegate respondsToSelector:_cmd]) {
        
        [_originalScrollViewDelegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    //NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([_originalScrollViewDelegate respondsToSelector:_cmd]) {
        
        [_originalScrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}
 */

#pragma mark -
#pragma mark UIWebViewDelegate


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"%@", [request URL]);
    
    if ([[[request URL] scheme] isEqualToString:@"native"]) {
        
        NSString *path = [[[request URL] path] stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
        NSString *query = [[request URL] query];
        
        NSMutableDictionary *parms = [NSMutableDictionary dictionary];
        
        for (NSString *item in [query componentsSeparatedByString:@"&"]) {
            
            NSArray *kv = [item componentsSeparatedByString:@"="];
            [parms setValue:[(NSString *)[kv objectAtIndex:1] stringByDecodingURLFormat] forKey:[kv objectAtIndex:0]];
        }
        
        
        SEL action = NSSelectorFromString([path stringByAppendingString:@":"]);
        
        if ([self respondsToSelector:action]) {
            
            [self performSelector:action withObject:parms];
            
            return NO;
        }
        
    }
    
    return YES;
}

/*
 
 - (void)webViewDidStartLoad:(UIWebView *)webView {
 
 
 }
 
 - (void)webViewDidFinishLoad:(UIWebView *)webView {
 
 
 }
 */



@end
