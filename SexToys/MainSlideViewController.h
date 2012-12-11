//
//  MySlideViewController.h
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.

#import "SlideViewController.h"

@interface MainSlideViewController : SlideViewController <SlideViewControllerDelegate> {
    
    NSArray *_datasource;
    NSMutableArray *_searchDatasource;
    
}

@property (nonatomic, readonly) NSArray *datasource;

@end
