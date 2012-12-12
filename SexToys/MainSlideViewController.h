//
//  MySlideViewController.h
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.

#import "SlideViewController.h"
#import "PSViewController.h"

@interface MainSlideViewController : SlideViewController <SlideViewControllerDelegate> {
    
    NSArray *_datasource;
    NSMutableArray *_searchDatasource;
    PSViewController *_listViewController00;
    PSViewController *_listViewController01;
    PSViewController *_listViewController02;
}

@property (nonatomic, readonly) NSArray *datasource;

@end
