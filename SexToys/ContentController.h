//
//  ContentController.h
//  DailyDeals
//
//  Created by  on 12-1-21.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DetailViewController.h"

@interface ContentController : UIViewController <UIScrollViewDelegate> {
    
    NSInteger currentPage;

    NSArray *contentList;
    
    UIScrollView *scrollView;
	UIPageControl *pageControl;
    NSMutableArray *viewControllers;
    
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}

@property (nonatomic, retain) NSArray *contentList;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic) NSInteger currentPage;

- (IBAction)changePage:(id)sender;
- (NSDictionary *)currentItem;

@end
