//
//  PSViewController.h
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"
#import "PSCollectionView.h"

@interface PSViewController : UIViewController <PSCollectionViewDelegate, PSCollectionViewDataSource, UIScrollViewDelegate, ASIHTTPRequestDelegate> {

    BOOL _isDragging;
    BOOL _isLoading;
    BOOL _isLastPage;
    UILabel *_loadingLabel;
}

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

@property (nonatomic) unsigned int page;
@property (nonatomic, retain) NSString *cateId;
@property (nonatomic, retain) NSString *cateName;
@property (nonatomic, assign) BOOL isFav;
@property (nonatomic, retain) NSDictionary *userinfo;


- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
- (void)reloadData;


@end
