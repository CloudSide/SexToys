//
//  ContentController.m
//  DailyDeals
//
//  Created by  on 12-1-21.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "ContentController.h"
#import "AppDelegate.h"
#import "TopWebViewController.h"

#pragma mark -
#pragma mark PrivateMethods

@interface ContentController (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)cleanUp:(int)page;

@end

#pragma mark -
#pragma mark PublicMethods

@implementation ContentController

@synthesize contentList, scrollView, pageControl, viewControllers, currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.currentPage = 0;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {

    //[[AppDelegate sharedAppDelegate].navigationController setNavigationBarHidden:NO];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {

    //[[AppDelegate sharedAppDelegate].navigationController setNavigationBarHidden:YES];
    [super viewDidDisappear:animated];
}

- (void)openTaobao {

    TopWebViewController *webViewController = [[[TopWebViewController alloc] initWithURL:[NSURL URLWithString:kMyTaobaoURL]] autorelease];
    webViewController.availableActions = SVWebViewControllerAvailableActionsNone | SVWebViewControllerAvailableActionsOpenInSafari;
	[self.navigationController pushViewController:webViewController animated:YES];
    
}

- (void)loadView {
    
    
    [super loadView];
    
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];        
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"我的订单" style:UIBarButtonItemStyleBordered target:self action:@selector(openTaobao)] autorelease];
    
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    for (unsigned i = 0; i < [contentList count]; i++) {
        
		[controllers addObject:[NSNull null]];
    }
    
    self.viewControllers = controllers;
    [controllers release];
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [contentList count], scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    pageControl.numberOfPages = [contentList count];
    pageControl.currentPage = currentPage;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    
    if (currentPage > 0) {
        
        [self loadScrollViewWithPage:currentPage - 1];
        [self loadScrollViewWithPage:currentPage];
        [self loadScrollViewWithPage:currentPage + 1];
        
    } else {
    
        currentPage = 0;
        [self loadScrollViewWithPage:0];
        [self loadScrollViewWithPage:1];
    }
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:NO];
    
    //[self setHidesBottomBarWhenPushed:YES];
    
    [[AppDelegate sharedAppDelegate].navigationController setNavigationBarHidden:NO];
}

- (NSDictionary *)currentItem {

    return [contentList objectAtIndex:currentPage];
}

- (void)dealloc {
    
    [contentList release];
    [viewControllers release];
    [scrollView release];
    [pageControl release];
    
    [super dealloc];
}
/*
- (UIView *)view {
    
    return self.scrollView;
}
 */

- (void)cleanUp:(int)page {

    /*
    if (page - 2 >= 0) {
        
        [viewControllers replaceObjectAtIndex:page-2 withObject:[NSNull null]];
    }
    
    if (page + 2 < [contentList count]) {
        
        [viewControllers replaceObjectAtIndex:page+2 withObject:[NSNull null]]; 
    }*/
}

- (void)loadScrollViewWithPage:(int)page {
    
    if (page < 0)
        return;
    if (page >= [contentList count])
        return;
    
    // replace the placeholder if necessary
    DetailViewController *controller = [viewControllers objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null]) {
        
        controller = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        controller.page = page;
        controller.contentController = self;
        
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
        
    // add the controller's view to the scroll view
    if (controller.view.superview == nil) {
        
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
        
        /*
        NSDictionary *numberItem = [self.contentList objectAtIndex:page];
        controller.numberImage.image = [UIImage imageNamed:[numberItem valueForKey:ImageKey]];
        controller.numberTitle.text = [numberItem valueForKey:NameKey];
         */
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    [self cleanUp:page];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    
    int page = pageControl.currentPage;
    currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    [self cleanUp:page];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


@end
