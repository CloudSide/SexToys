//
//  SlideViewController.m
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.
/*
 Copyright (c) 2011 Andrew Carter
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SlideViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kSVCLeftAnchorX                 100.0f
#define kSVCRightAnchorX                190.0f
#define kSVCSwipeNavigationBarOnly      YES


@interface SlideViewNavigationBar : UINavigationBar {
@private
    
    id <SlideViewNavigationBarDelegate> _slideViewNavigationBarDelegate;
    
}

@property (nonatomic, assign) id <SlideViewNavigationBarDelegate> slideViewNavigationBarDelegate;

@end

@implementation SlideViewNavigationBar

@synthesize slideViewNavigationBarDelegate = _slideViewNavigationBarDelegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    [self.slideViewNavigationBarDelegate slideViewNavigationBar:self touchesBegan:touches withEvent:event];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesMoved:touches withEvent:event];
    
    [self.slideViewNavigationBarDelegate slideViewNavigationBar:self touchesMoved:touches withEvent:event];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
    [self.slideViewNavigationBarDelegate slideViewNavigationBar:self touchesEnded:touches withEvent:event];
    
}

@end

@interface SlideViewTableCell : UITableViewCell {
@private
    
}
@end

@implementation SlideViewTableCell 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
        [background setImage:[[UIImage imageNamed:@"category_content_bg.png"] stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f]];
        self.backgroundView = background;
        [background release];
        
        UIImageView *selectedBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
        [selectedBackground setImage:[[UIImage imageNamed:@"category_content_bg_selected.png"] stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f]];
        self.selectedBackgroundView = selectedBackground;
        [selectedBackground release];
        
        self.textLabel.textColor = [UIColor colorWithRed:229.0f/255.0f green:94.0f/255.0f blue:67.0f/255.0f alpha:1.0f];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        //self.textLabel.shadowColor = [UIColor colorWithRed:33.0f/255.0f green:38.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
        //self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
        
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(5.0f, 5.0f, 34.0f, 34.0f);
    
}

@end

@implementation SlideViewController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"SlideViewController" bundle:nil];
    if (self) {
                
        _touchView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
        _touchView.exclusiveTouch = NO;
        
        _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 416.0f)];
        
        _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
        
    }
    return self;
}

- (void)dealloc {
    
    [_touchView release];
    [_overlayView release];
    [_slideNavigationController release];
    
    [super dealloc];
    
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    [_tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"category_list_bg.png"]]];
    
    if (![self.delegate respondsToSelector:@selector(configureSearchDatasourceWithString:)] || ![self.delegate respondsToSelector:@selector(searchDatasource)]) {
        _searchBar.hidden = YES;
        _tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
    }
    
    [_slideNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_logo.png"] forBarMetrics:UIBarMetricsDefault];
    [_slideNavigationController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:176.0/255.0 alpha:1.0]];
  
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, _slideNavigationController.navigationBar.bounds);
    _slideNavigationController.navigationBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    _slideNavigationController.navigationBar.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _slideNavigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
    _slideNavigationController.navigationBar.layer.shadowRadius = 2;
    _slideNavigationController.navigationBar.layer.shadowOpacity = 0.35f;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    _slideNavigationController.navigationBar.clipsToBounds = NO;
    
    /*
    _slideNavigationController.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    _slideNavigationController.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _slideNavigationController.view.layer.shadowRadius = 4.0f;
    _slideNavigationController.view.layer.shadowOpacity = 0.75f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_slideNavigationController.view.bounds cornerRadius:4.0];
    _slideNavigationController.view.layer.shadowPath = path.CGPath;
    
    [(SlideViewNavigationBar *)_slideNavigationController.navigationBar setSlideViewNavigationBarDelegate:self];
    
    UIImage *searchBarBackground = [UIImage imageNamed:@"search_bar_background"];
    [_searchBar setBackgroundImage:[searchBarBackground stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
    */
     
    UIViewController *initalViewController = [self.delegate initialViewController];
    [self configureViewController:initalViewController];
    
    [_slideNavigationController setViewControllers:[NSArray arrayWithObject:initalViewController] animated:NO];
    
    [self addChildViewController:_slideNavigationController];
    
    [self.view addSubview:_slideNavigationController.view];
    
    if ([self.delegate respondsToSelector:@selector(initialSelectedIndexPath)])
        [_tableView selectRowAtIndexPath:[self.delegate initialSelectedIndexPath] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
}

#pragma mark Instance Methods

- (void)configureViewController:(UIViewController *)viewController {
    
    //UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuBarButtonItemPressed:)];
    
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 35.0f, 35.0f)] autorelease];
    [button setImage:[UIImage imageNamed:@"btn_menu.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_menu_pressed.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(menuBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    viewController.navigationItem.leftBarButtonItem = [barButtonItem autorelease];
    
}

- (void)menuBarButtonItemPressed:(id)sender {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStatePeeking) {
        
        [self slideInSlideNavigationControllerView];
        return;
        
    }
    
    UIViewController *currentViewController = [[_slideNavigationController viewControllers] objectAtIndex:0];
    
    if ([currentViewController conformsToProtocol:@protocol(SlideViewControllerSlideDelegate)] && [currentViewController respondsToSelector:@selector(shouldSlideOut)]) {
        
        
        if ([(id <SlideViewControllerSlideDelegate>)currentViewController shouldSlideOut]) {
            
            [self slideOutSlideNavigationControllerView];
            
        }
        
        
    } else {
        
        [self slideOutSlideNavigationControllerView];
        
    }
    
}

- (void)slideOutSlideNavigationControllerView {
        
    _slideNavigationControllerState = kSlideNavigationControllerStatePeeking;

    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _slideNavigationController.view.transform = CGAffineTransformMakeTranslation(180.0f, 0.0f);
        
    } completion:^(BOOL finished) {
        
        [_slideNavigationController.view addSubview:_overlayView];
        
    }];
    
}

- (void)slideInSlideNavigationControllerView {
            
    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _slideNavigationController.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self cancelSearching];
        
        _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
        [_overlayView removeFromSuperview];
        
    }];
    
}

- (void)slideSlideNavigationControllerViewOffScreen {
    
    _slideNavigationControllerState = kSlideNavigationControllerStateSearching;

    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _slideNavigationController.view.transform = CGAffineTransformMakeTranslation(320.0f, 0.0f);
        
    } completion:^(BOOL finished) {
        
        [_slideNavigationController.view addSubview:_overlayView];
        
    }];
    
}

#pragma mark UITouch Logic

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (_slideNavigationControllerState == kSlideNavigationControllerStateDrilledDown || _slideNavigationControllerState == kSlideNavigationControllerStateSearching)
        return;
    
    UITouch *touch = [touches anyObject];
    
    _startingDragPoint = [touch locationInView:self.view];
    
    if ((CGRectContainsPoint(_slideNavigationController.view.frame, _startingDragPoint)) && _slideNavigationControllerState == kSlideNavigationControllerStatePeeking) {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateDragging;
        _startingDragTransformTx = _slideNavigationController.view.transform.tx;
    }
    
    // we only trigger a swipe if either navigationBarOnly is deactivated
    // or we swiped in the navigationBar
    if (!kSVCSwipeNavigationBarOnly || _startingDragPoint.y <= 44.0f) {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateDragging;
        _startingDragTransformTx = _slideNavigationController.view.transform.tx;

    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_slideNavigationControllerState != kSlideNavigationControllerStateDragging)
        return;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:self.view];
  
    [UIView animateWithDuration:0.05f delay:0.0f options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{

        _slideNavigationController.view.transform = CGAffineTransformMakeTranslation(MAX(_startingDragTransformTx + (location.x - _startingDragPoint.x), 0.0f), 0.0f);

    } completion:^(BOOL finished) {
        
    }];
    
      
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateDragging) {
        UITouch *touch = [touches anyObject];
        CGPoint endPoint = [touch locationInView:self.view];
        
        // Check in which direction we were dragging
        if (endPoint.x < _startingDragPoint.x) {
            if (_slideNavigationController.view.transform.tx <= kSVCRightAnchorX) {
                [self slideInSlideNavigationControllerView];
            } else {
                [self slideOutSlideNavigationControllerView]; 
            }
        } else {
            if (_slideNavigationController.view.transform.tx >= kSVCLeftAnchorX) {
                [self slideOutSlideNavigationControllerView];
            } else {
                [self slideInSlideNavigationControllerView];
            }
        }
    }
    
}

- (void)cancelSearching {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        [_searchBar resignFirstResponder];
        _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
        _searchBar.text = @"";
        [_tableView reloadData];
    }
    
}

#pragma mark SlideViewNavigationBarDelegate Methods

- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesBegan:touches withEvent:event];
    
}

- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesMoved:touches withEvent:event];
    
}

- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesEnded:touches withEvent:event];
    
}

#pragma mark UINavigationControlerDelgate Methods 

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self cancelSearching];
    
    if ([[navigationController viewControllers] count] > 1) {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateDrilledDown;
        
    } else {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
        
    }
    
}

#pragma mark UITableViewDelegate / UITableViewDatasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        return [[self.delegate searchDatasource] count];
    } else {
        return [[[[self.delegate datasource] objectAtIndex:section] objectForKey:kSlideViewControllerSectionViewControllersKey] count];        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        return 1;
    } else {
        return [[self.delegate datasource] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *resuseIdentifier = @"SlideViewControllerTableCell";
    
    SlideViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseIdentifier];
    
    if (!cell) {
        
        cell = [[[SlideViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseIdentifier] autorelease];
    
    }

    NSDictionary *viewControllerDictionary = nil;
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        viewControllerDictionary = [[self.delegate searchDatasource] objectAtIndex:indexPath.row];
    } else {
        viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:indexPath.section] objectForKey:kSlideViewControllerSectionViewControllersKey] objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerTitleKey];
    
    if ([[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerIconKey] isKindOfClass:[UIImage class]]) {
        cell.imageView.image = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerIconKey];
    } else {
        cell.imageView.image = nil;
    }
    
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching)
        return nil;
    
    NSDictionary *sectionDictionary = [[self.delegate datasource] objectAtIndex:section];
    
    if ([sectionDictionary objectForKey:kSlideViewControllerSectionTitleKey]) {
        
        NSString *sectionTitle = [sectionDictionary objectForKey:kSlideViewControllerSectionTitleKey];
        
        if ([sectionTitle isEqualToString:kSlideViewControllerSectionTitleNoTitle]) {
            
            return nil;
            
        } else {
            
            return sectionTitle;
            
        }
        
    } else {
        
        return nil;
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching)
        return nil;
    
    NSString *titleString = [self tableView:tableView titleForHeaderInSection:section];
    
    if (!titleString)
        return nil;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 42.0f)];
    imageView.image = [[UIImage imageNamed:@"filterbar_menu_bg.png"] stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(imageView.frame, 10.0f, 0.0f)];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithRed:227.0f/255.0f green:93.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    //titleLabel.shadowColor = [UIColor colorWithRed:40.0f/255.0f green:45.0f/255.0f blue:57.0f/255.0f alpha:1.0f];
    //titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = titleString;
    [imageView addSubview:titleLabel];
    [titleLabel release];

    return [imageView autorelease];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        return 0.0f;
    }
    else if ([self tableView:tableView titleForHeaderInSection:section]) {
        return 42.0f;
    } else {
        return 0.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    NSDictionary *viewControllerDictionary = nil;
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        viewControllerDictionary = [[self.delegate searchDatasource] objectAtIndex:indexPath.row];
    } else {
        viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:indexPath.section] objectForKey:kSlideViewControllerSectionViewControllersKey] objectAtIndex:indexPath.row];
    }
    
    Class viewControllerClass = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerClassKey];
    NSString *nibNameOrNil = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerNibNameKey];
    UIViewController *viewController = [[viewControllerClass alloc] initWithNibName:nibNameOrNil bundle:nil];
    
    if ([self.delegate respondsToSelector:@selector(configureViewController:userInfo:)])
        [self.delegate configureViewController:viewController userInfo:[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerUserInfoKey]];
    
    [self configureViewController:viewController];
    
    [_slideNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
    [viewController release];
    
    [self slideInSlideNavigationControllerView];
    
}

#pragma mark UISearchBarDelegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
        
    if ([self.delegate respondsToSelector:@selector(configureSearchDatasourceWithString:)]) {
    
        [self slideSlideNavigationControllerViewOffScreen];
        
        [self.delegate configureSearchDatasourceWithString:searchBar.text];
        
        [_tableView reloadData];

    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([self.delegate respondsToSelector:@selector(configureSearchDatasourceWithString:)]) {
        
        [self.delegate configureSearchDatasourceWithString:searchBar.text];
     
        [_tableView reloadData];

    }    

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self cancelSearching];
    
    [self slideOutSlideNavigationControllerView];
    
    [_tableView reloadData];
    
}

@end
