//
//  SlideViewController.h
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.
/*
 Copyright (c) 2011 Andrew Carter
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

#define kSlideViewControllerSectionTitleKey @"slideViewControllerSectionTitle"
#define kSlideViewControllerSectionViewControllersKey @"slideViewControllerSectionViewControllers"
#define kSlideViewControllerSectionTitleNoTitle @"slideViewControllerSectionTitleNoTitle"
#define kSlideViewControllerViewControllerTitleKey @"slideViewControllerViewControllerTitle"
#define kSlideViewControllerViewControllerNibNameKey @"slideViewControllerViewControllerNibName"
#define kSlideViewControllerViewControllerClassKey @"slideViewControllerViewControllerClass"
#define kSlideViewControllerViewControllerUserInfoKey @"slideViewControllerViewControllerUserInfo"
#define kSlideViewControllerViewControllerIconKey @"slideViewControllerViewControllerIcon"

typedef enum {
    
    kSlideNavigationControllerStateNormal,
    kSlideNavigationControllerStateDragging,
    kSlideNavigationControllerStatePeeking,
    kSlideNavigationControllerStateDrilledDown,
    kSlideNavigationControllerStateSearching
    
} SlideNavigationControllerState;

@class SlideViewController;
@class SlideViewNavigationBar;

@protocol SlideViewControllerDelegate <NSObject>
@optional
- (void)configureViewController:(UIViewController *)viewController userInfo:(id)userInfo;
- (NSIndexPath *)initialSelectedIndexPath;
- (void)configureSearchDatasourceWithString:(NSString *)string;
- (NSArray *)searchDatasource;
@required
- (UIViewController *)initialViewController;
- (NSArray *)datasource;
@end

@protocol SlideViewControllerSlideDelegate <NSObject>
@optional
- (BOOL)shouldSlideOut;
@end

@protocol SlideViewNavigationBarDelegate <NSObject>
- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface SlideViewController : UIViewController <SlideViewNavigationBarDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate, UITextFieldDelegate> {
    
    IBOutlet UINavigationController *_slideNavigationController;
    IBOutlet UISearchBar *_searchBar;
    IBOutlet UITableView *_tableView;
    id <SlideViewControllerDelegate> _delegate;
    CGPoint _startingDragPoint;
    CGFloat _startingDragTransformTx;
    UIView *_touchView;
    SlideNavigationControllerState _slideNavigationControllerState;
    UIView *_overlayView;
}

@property (nonatomic, assign) id <SlideViewControllerDelegate> delegate;

- (void)configureViewController:(UIViewController *)viewController;
- (void)menuBarButtonItemPressed:(id)sender;
- (void)slideOutSlideNavigationControllerView;
- (void)slideInSlideNavigationControllerView;
- (void)slideSlideNavigationControllerViewOffScreen;
- (void)cancelSearching;

@end
