//
//  PSViewController.m
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSViewController.h"
#import "PSBroView.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "ContentController.h"
#import "AppDelegate.h"
#import "ASIDownloadCache.h"



/**
 This is an example of a controller that uses PSCollectionView
 */

/**
 Detect iPad
 */
static BOOL isDeviceIPad() {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES; 
    }
    
#endif
    
    return NO;
}

#define REFRESH_HEADER_HEIGHT 52.0f

@interface PSViewController ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) PSCollectionView *collectionView;
@property (nonatomic, strong) ASIHTTPRequest *request;

@end

@implementation PSViewController

@synthesize
items = _items,
collectionView = _collectionView,
refreshHeaderView = _refreshHeaderView,
refreshLabel = _refreshLabel,
refreshArrow = _refreshArrow,
refreshSpinner = _refreshSpinner,
textPull = _textPull,
textRelease = _textRelease,
textLoading = _textLoading,
page = _page,
cateId = _cateId,
cateName = _cateName,
isFav = _isFav,
userinfo = _userinfo,
request = _request;

- (void)loadingStatus {
    
    UIActivityIndicatorView *uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    uiBusy.hidesWhenStopped = YES;
    [uiBusy startAnimating];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:uiBusy] autorelease];
    [uiBusy release];
}

- (void)loadedStatus {
    
        
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																							target:self
																							action:@selector(reloadData)] autorelease];
}


- (void)startLoading {
    
    _isLoading = YES;
    
    [self loadingStatus];
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _collectionView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    _refreshLabel.text = self.textLoading;
    _refreshArrow.hidden = YES;
    [_refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    
    [self.collectionView.footerView setHidden:NO];
    _loadingLabel.text = @"正在加载...";
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    
    _isLoading = NO;
    
    [self loadedStatus];
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    _collectionView.contentInset = UIEdgeInsetsZero;
    [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
    
    if (_isLastPage) {
        
        [self.collectionView.footerView setHidden:NO];
        _loadingLabel.text = @"已经最后一页了";
        
    } else {
    
        [self.collectionView.footerView setHidden:YES];
    }
    
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    // Reset the header
    _refreshLabel.text = self.textPull;
    _refreshArrow.hidden = NO;
    [_refreshSpinner stopAnimating];
}

- (void)reloadData {
    
    if (!_isLoading) {
        
        _page = 1;
        _isLastPage = NO;
        [self startLoading];
        //[_collectionView setContentOffset:CGPointZero animated:YES];
    }    
}

- (void)refresh {
    
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    
    [self loadDataSource];
}

- (void)addPullToRefreshHeader {
    
    _refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    _refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    _refreshLabel.backgroundColor = [UIColor clearColor];
    _refreshLabel.font = [UIFont boldSystemFontOfSize:14.0];
    _refreshLabel.textAlignment = UITextAlignmentCenter;
    _refreshLabel.textColor = [UIColor darkGrayColor];
    
    _refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    _refreshArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 22) / 2,
                                    (REFRESH_HEADER_HEIGHT - 22) / 2,
                                    22, 22);
    
    _refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    _refreshSpinner.hidesWhenStopped = YES;
    
    UIImageView *refreshArrowBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_loading.png"]];
    refreshArrowBg.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 30) / 2, (REFRESH_HEADER_HEIGHT - 30) / 2, 30, 30);
    
    [_refreshHeaderView addSubview:refreshArrowBg];
    [_refreshHeaderView addSubview:_refreshLabel];
    [_refreshHeaderView addSubview:_refreshArrow];
    [_refreshHeaderView addSubview:_refreshSpinner];
    [_collectionView addSubview:_refreshHeaderView];
    
    [refreshArrowBg release];
}



#pragma mark - Init

- (void)viewWillAppear:(BOOL)animated {
    
    [[AppDelegate sharedAppDelegate].navigationController setNavigationBarHidden:YES];
   
    if (_isFav) {
        
        [self reloadData];
    }
    
    [super viewDidAppear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    
        self.items = [NSMutableArray array];
        
        _textPull = [[NSString alloc] initWithString:@"下拉更新数据"];
        _textRelease = [[NSString alloc] initWithString:@"松开即可更新"];
        _textLoading = [[NSString alloc] initWithString:@"正在更新数据 ..."];
        
        _page = 1;
        _isFav = NO;
        _isLastPage = NO;
        
    }
    
    return self;
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    
    self.collectionView.delegate = nil;
    self.collectionView.collectionViewDelegate = nil;
    self.collectionView.collectionViewDataSource = nil;
    self.collectionView = nil;
}

- (void)dealloc {
    
    NSLog(@"[PSViewController dealloc]");
    
    self.collectionView.delegate = nil;
    self.collectionView.collectionViewDelegate = nil;
    self.collectionView.collectionViewDataSource = nil;
    self.collectionView = nil;
    self.items = nil;
    
    self.refreshHeaderView = nil;
    self.refreshLabel = nil;
    self.refreshArrow = nil;
    self.refreshSpinner = nil;
    self.textPull = nil;
    self.textRelease = nil;
    self.textLoading = nil;
    
    self.cateId = nil;
    self.cateName = nil;
    
    self.userinfo = nil;
    
    [_loadingLabel release];
    
    [_request clearDelegatesAndCancel];
    self.request = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_logo.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:176.0/255.0 alpha:1.0]];
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
    
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.collectionView = [[[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    [self.view addSubview:self.collectionView];
    self.collectionView.collectionViewDelegate = self;
    self.collectionView.collectionViewDataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_user.png"]];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    
    
    UILabel *loadingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)] autorelease];
    loadingLabel.text = @"正在加载...";
    [loadingLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [loadingLabel setShadowColor:[UIColor whiteColor]];
    [loadingLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    loadingLabel.textAlignment = UITextAlignmentCenter;
    [loadingLabel setBackgroundColor:[UIColor clearColor]];
    self.collectionView.footerView = loadingLabel;
    _loadingLabel = [loadingLabel retain];
    
    if (_isFav) {
        
        UILabel *loadingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)] autorelease];
        loadingLabel.text = @"您还没有收藏过商品";
        [loadingLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [loadingLabel setShadowColor:[UIColor whiteColor]];
        [loadingLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
        loadingLabel.textAlignment = UITextAlignmentCenter;
        [loadingLabel setBackgroundColor:[UIColor clearColor]];
        self.collectionView.headerView = loadingLabel;
    }
    
    if (isDeviceIPad()) {
        
        self.collectionView.numColsPortrait = 4;
        self.collectionView.numColsLandscape = 5;
    
    } else {
    
        self.collectionView.numColsPortrait = 2;
        self.collectionView.numColsLandscape = 3;
    }
    
    
    [self addPullToRefreshHeader];
    
    [self reloadData];

}

- (void)loadDataSource {
    
    if (_isFav) {
        
        [self.items removeAllObjects];
        
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
            
            [self.items addObjectsFromArray:items];
            [items release];
        }
        
        if ([self.items count] > 0) {
            
            [self.collectionView.headerView setHidden:YES];
            [self.collectionView.headerView setFrame:CGRectZero];
            
        } else {

            [self.collectionView.headerView setHidden:NO];
            [self.collectionView.headerView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
        }
        
        [self dataSourceDidLoad];
        [self stopLoading];
        
        return;
    } 
    
    NSString *URLPath = nil;
    
    if (_cateId) {
        
        URLPath = [kApiItemsOfCateURL stringByAppendingFormat:@"&t=%@&pgno=%d", _cateId, _page];
        
    } else {
        
        URLPath = [kApiItemsOfGuideURL stringByAppendingFormat:@"&t=%@&pgno=%d", [_userinfo objectForKey:@"type"], _page];
    }
    
    // Request
    NSURL *URL = [NSURL URLWithString:URLPath];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setDelegate:self];
    
    self.request = request;
    
    [_request setDownloadCache:[ASIDownloadCache sharedCache]];
    [_request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy]; //ASIAskServerIfModifiedCachePolicy
    [_request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [_request setAllowCompressedResponse:YES];
    [_request setShouldWaitToInflateCompressedResponses:NO];
    [_request setShouldAttemptPersistentConnection:YES];
    //[_request setNumberOfTimesToRetryOnTimeout:3];
    [_request setShouldAttemptPersistentConnection:YES];
    //[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
    
    [_request start];
    
    /*
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (!error && responseCode == 200) {
            
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if (res && [res isKindOfClass:[NSArray class]]) {
            
                if ([(NSArray *)res count] == 0) {
                    
                    _isLastPage = YES;
                
                } else {
                
                    [self.items addObjectsFromArray:res];
                    
                    if (_page == 1) {
                        
                        [self.items removeAllObjects];
                    }
                    
                    _page++;
                    
                    [self.items addObjectsFromArray:res];
                    
                    [self dataSourceDidLoad];
                }
            
            } else {
            
                [self dataSourceDidError];
            }
            
        } else {
            
            [self dataSourceDidError];
        }
        
        [self stopLoading];
    }];
     */
}

- (void)dataSourceDidLoad {
    
    [self.collectionView reloadData];
}

- (void)dataSourceDidError {
    
    [self.collectionView reloadData];
}

#pragma mark - PSCollectionViewDelegate and DataSource

- (NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView {
    
    return [self.items count];
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index {
    
    NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:[self.items objectAtIndex:index]];    
    
    if (![item objectForKey:@"height"] ||
        ![item objectForKey:@"width"] ||
        ![[item objectForKey:@"width"] isKindOfClass:[NSNumber class]] ||
        ![[item objectForKey:@"height"] isKindOfClass:[NSNumber class]] ||
        [[item objectForKey:@"width"] floatValue] <= 0.0f ||
        [[item objectForKey:@"height"] floatValue] <= 0.0f) {
        
    
        [item setValue:[NSNumber numberWithFloat:100.0f] forKey:@"width"];
        [item setValue:[NSNumber numberWithFloat:100.0f] forKey:@"height"];
    }
    
    
    PSBroView *v = (PSBroView *)[self.collectionView dequeueReusableView];
    
    if (!v) {
        
        v = [[[PSBroView alloc] initWithFrame:CGRectZero] autorelease];
    }
    
    [v fillViewWithObject:item];
    
    return v;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index {

    NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:[self.items objectAtIndex:index]];
            
    if ([[item objectForKey:@"width"] isKindOfClass:[NSNumber class]] && [[item objectForKey:@"height"] isKindOfClass:[NSNumber class]]) {
        
        if ([[item objectForKey:@"width"] floatValue] >= 0.0f && [[item objectForKey:@"height"] floatValue] >= 0.0f) {
            
            return [PSBroView heightForViewWithObject:item inColumnWidth:self.collectionView.colWidth];
        }
    }
    
    return 100.0f;
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index {
    
    //NSDictionary *item = [self.items objectAtIndex:index];
    // You can do something when the user taps on a collectionViewCell here
    
    ContentController *contentController = [[ContentController alloc] initWithNibName:@"ContentController" bundle:nil];
    
    NSArray *items = nil;
    NSInteger aIndex = 0;
    
    /*
    if ([_items count] >= 3) {
        
        if (index == [_items count] - 1) {
            
            aIndex = 2;
            items = [_items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index-2, 3)]];
            
        } else if (index == 0) {
            
            aIndex = 0;
            items = [_items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, 3)]];
            
        } else {
            
            aIndex = 1;
            items = [_items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index-1, 3)]];
        }
    
    } else if ([_items count] == 2) {
    
        items = [NSArray arrayWithArray:_items];
        aIndex = index;
        
    } else if ([_items count] == 1) {
    
        items = [NSArray arrayWithObjects:[_items objectAtIndex:index], nil];
        aIndex = 0;
    }
    */
    
    NSInteger size = 7;
    NSInteger center = size / 2;
    
    
    if ([_items count] <= size && [_items count] > 0) {
        
        items = [NSArray arrayWithArray:_items];
        aIndex = index;
    
    } else if ([_items count] > size) {
    
        if (index <= center) {
            
            aIndex = index;
            items = [_items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, size)]];
            
        } else if (index > center) {
        
            if ([_items count] - 1 >= index + center) {
                
                aIndex = center;
                items = [_items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index - center, size)]];
            
            } else if ([_items count] - 1 < index + center) {
            
                aIndex = index - ([_items count] - size);
                items = [_items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange([_items count] - size, size)]];
            }
        }
    }
    
    
    contentController.contentList = items;
    contentController.currentPage = aIndex;
    [[AppDelegate sharedAppDelegate].navigationController pushViewController:contentController animated:YES];
    [contentController release];
    
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
            
    if (_isLoading) return;
    
    _isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    /*
    NSLog(@"scrollView.contentOffset.y:%f", scrollView.contentOffset.y);
    NSLog(@"scrollView.contentSize.height:%f", scrollView.contentSize.height);
    */
    
    if (_isLoading) {
        
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            scrollView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (_isDragging && scrollView.contentOffset.y < 0) {
        
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            _refreshLabel.text = self.textRelease;
            [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            _refreshLabel.text = self.textPull;
            [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        
        [UIView commitAnimations];
    
    } else if (!_isFav && !_isLastPage && !_isLoading && scrollView.contentOffset.y > 0.0f && scrollView.contentSize.height - 392.0f > 0.0f && scrollView.contentOffset.y >= scrollView.contentSize.height - 392.0f) {
    
        [self startLoading];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
        
    if (_isLoading) return;
    _isDragging = NO;
    
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
        
    }
}

#pragma - mark ASIHTTPRequest

- (void)requestFailed:(ASIHTTPRequest *)request {

    NSError *error = [_request error];
    NSLog(@"%@", error);
    
    [self dataSourceDidError];
    
    [self stopLoading];
}

- (void)requestFinished:(ASIHTTPRequest *)request {

    id res = [NSJSONSerialization JSONObjectWithData:[_request responseData] options:NSJSONReadingMutableContainers error:nil];
    
    if (res && [res isKindOfClass:[NSArray class]]) {
        
        if ([(NSArray *)res count] == 0) {
            
            _isLastPage = YES;
            
        } else {
            
            if (_page == 1) {
                
                [self.items removeAllObjects];
            }
            
            _page++;
            
            [self.items addObjectsFromArray:res];
            
            [self dataSourceDidLoad];
        }
        
    } else {
        
        [self dataSourceDidError];
    }
    
    [self stopLoading];

}


@end
