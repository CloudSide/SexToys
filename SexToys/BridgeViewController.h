//
//  PullRefreshController.h
//  DailyDeals
//
//  Created by Bruce Chen on 12-1-12.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BridgeViewController : UIViewController <UIScrollViewDelegate, UIWebViewDelegate> {

    UIWebView *_webView;
    UIScrollView *_scrollView;
    id<UIScrollViewDelegate> _originalScrollViewDelegate;
    
    
    
    
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
}

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) id<UIScrollViewDelegate> originalScrollViewDelegate;




@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;



@end
