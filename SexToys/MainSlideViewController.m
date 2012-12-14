//
//  MySlideViewController.m
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.

#import "MainSlideViewController.h"
#import "ListViewController.h"
#import "PSViewController.h"


@implementation MainSlideViewController

@synthesize datasource = _datasource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        //creating _searchDatasource for later use!
        _searchDatasource = [NSMutableArray new];
        
        NSMutableArray *datasource = [NSMutableArray array];
        
        _listViewController00 = nil;
        _listViewController01 = nil;
        _listViewController02 = nil;
        
        /*
        Here's the fun part. What we need to do is creat a datasource array that uses this structure
         
         <Array>
            <Dictionary><!--represents a section in the table-->
                
                <!--This will be displayed as the text in section header. You could also use kSlideViewControllerSectionTitleNoTitle for the value-->
                <key>kSlideViewControllerSectionTitleKey</key>
                <value>My Section Header Text</value>
            
                <!--This will be the rows of that section.-->
                <key>kSlideViewControllerSectionViewControllersKey</key>
                <value>
                    <Array>
         
                        <Dictionary>
         
                            <!--this will be the title for the row-->
                            <key>kSlideViewControllerViewControllerTitleKey</key>
                            <value>My Text</value>
         
                            <!--This is the view controller class that should be created / displayed when this row is clicked-->
                            <key>kSlideViewControllerViewControllerClassKey</key>
                            <value>[MyViewControllerSubclass class]</value>
                            
                            <!--If you're using nibs, include the nib name in this key-->
                            <key>kSlideViewControllerViewControllerNibNameKey</key>
                            <value>MyViewControllerSubclass</value>
                            
                            <!--Include a UIImage with this key to have an icon for the row -->
                            <key>kSlideViewControllerViewControllerIconKey</key>
                            <value>*UIImage*</value>
         
                            <!--This gets passed along with the configureViewController:userInfo: method if you implement it-->
                            <key>kSlideViewControllerViewControllerUserInfoKey</key>
                            <value>anything you want</value>
         
                        </Dictionary>
         
                    </Array>
                </value>
         
            </Dictionary><!--end table section-->
         </Array>
        
         
         */
        
        
        
        NSMutableDictionary *sectionOne = [NSMutableDictionary dictionary];
        [sectionOne setObject:@"热门商品" forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *hotViewControllerOneDictionary = [NSMutableDictionary dictionary];
        [hotViewControllerOneDictionary setObject:@"新鲜上市" forKey:kSlideViewControllerViewControllerTitleKey];
        [hotViewControllerOneDictionary setObject:[PSViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        [hotViewControllerOneDictionary setObject:@"PSViewController_iPhone" forKey:kSlideViewControllerViewControllerNibNameKey];
        //[hotViewControllerOneDictionary setObject:[UIImage imageNamed:@"icon_cate_beauties.png"] forKey:kSlideViewControllerViewControllerIconKey];
        NSMutableDictionary *hotOneUserInfo = [NSMutableDictionary dictionary];
        [hotOneUserInfo setObject:@"新鲜上市" forKey:@"name"];
        [hotOneUserInfo setObject:@"1" forKey:@"type"];
        [hotViewControllerOneDictionary setObject:hotOneUserInfo forKey:kSlideViewControllerViewControllerUserInfoKey];
        
        NSMutableDictionary *hotViewControllerTwoDictionary = [NSMutableDictionary dictionary];
        [hotViewControllerTwoDictionary setObject:@"热门推荐" forKey:kSlideViewControllerViewControllerTitleKey];
        [hotViewControllerTwoDictionary setObject:[PSViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        [hotViewControllerTwoDictionary setObject:@"PSViewController_iPhone" forKey:kSlideViewControllerViewControllerNibNameKey];
        //[hotViewControllerTwoDictionary setObject:[UIImage imageNamed:@"icon_cate_shoes.png"] forKey:kSlideViewControllerViewControllerIconKey];
        NSMutableDictionary *hotTwoUserInfo = [NSMutableDictionary dictionary];
        [hotTwoUserInfo setObject:@"热门推荐" forKey:@"name"];
        [hotTwoUserInfo setObject:@"2" forKey:@"type"];
        [hotViewControllerTwoDictionary setObject:hotTwoUserInfo forKey:kSlideViewControllerViewControllerUserInfoKey];
        
        NSMutableDictionary *hotViewControllerThreeDictionary = [NSMutableDictionary dictionary];
        [hotViewControllerThreeDictionary setObject:@"特价商品" forKey:kSlideViewControllerViewControllerTitleKey];
        [hotViewControllerThreeDictionary setObject:[PSViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        [hotViewControllerThreeDictionary setObject:@"PSViewController_iPhone" forKey:kSlideViewControllerViewControllerNibNameKey];
        //[hotViewControllerThreeDictionary setObject:[UIImage imageNamed:@"icon_cate_bags.png"] forKey:kSlideViewControllerViewControllerIconKey];
        NSMutableDictionary *hotThreeUserInfo = [NSMutableDictionary dictionary];
        [hotThreeUserInfo setObject:@"特价商品" forKey:@"name"];
        [hotThreeUserInfo setObject:@"3" forKey:@"type"];
        [hotViewControllerThreeDictionary setObject:hotThreeUserInfo forKey:kSlideViewControllerViewControllerUserInfoKey];
        
        [sectionOne setObject:[NSArray arrayWithObjects:hotViewControllerOneDictionary, hotViewControllerTwoDictionary, hotViewControllerThreeDictionary, nil] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionOne];
        _datasource = [datasource retain];
        
        /*
        NSMutableDictionary *sectionOne = [NSMutableDictionary dictionary];
        [sectionOne setObject:kSlideViewControllerSectionTitleNoTitle forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *homeViewControllerDictionary = [NSMutableDictionary dictionary];
        [homeViewControllerDictionary setObject:@"Home" forKey:kSlideViewControllerViewControllerTitleKey];
        [homeViewControllerDictionary setObject:@"HomeViewController" forKey:kSlideViewControllerViewControllerNibNameKey];
        [homeViewControllerDictionary setObject:[HomeViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        
        [sectionOne setObject:[NSArray arrayWithObject:homeViewControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionOne];
        
        NSMutableDictionary *sectionTwo = [NSMutableDictionary dictionary];
        [sectionTwo setObject:@"Friends" forKey:kSlideViewControllerSectionTitleKey];

        NSMutableDictionary *friendViewControllerOneDictionary = [NSMutableDictionary dictionary];
        [friendViewControllerOneDictionary setObject:@"Andrew" forKey:kSlideViewControllerViewControllerTitleKey];
        [friendViewControllerOneDictionary setObject:[FriendViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        [friendViewControllerOneDictionary setObject:@"FriendViewController" forKey:kSlideViewControllerViewControllerNibNameKey];
        [friendViewControllerOneDictionary setObject:[UIImage imageNamed:@"andrew.jpeg"] forKey:kSlideViewControllerViewControllerIconKey];
        NSMutableDictionary *friendOneUserInfo = [NSMutableDictionary dictionary];
        [friendOneUserInfo setObject:@"Andrew" forKey:@"name"];
        [friendOneUserInfo setObject:@"24" forKey:@"age"];
        [friendViewControllerOneDictionary setObject:friendOneUserInfo forKey:kSlideViewControllerViewControllerUserInfoKey];
        
        NSMutableDictionary *friendViewControllerTwoDictionary = [NSMutableDictionary dictionary];
        [friendViewControllerTwoDictionary setObject:@"Leigh Anne" forKey:kSlideViewControllerViewControllerTitleKey];
        [friendViewControllerTwoDictionary setObject:[FriendViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        [friendViewControllerTwoDictionary setObject:@"FriendViewController" forKey:kSlideViewControllerViewControllerNibNameKey];
        [friendViewControllerTwoDictionary setObject:[UIImage imageNamed:@"leighanne.jpg"] forKey:kSlideViewControllerViewControllerIconKey];
        NSMutableDictionary *friendTwoUserInfo = [NSMutableDictionary dictionary];
        [friendTwoUserInfo setObject:@"Leigh Anne" forKey:@"name"];
        [friendTwoUserInfo setObject:@"27" forKey:@"age"];
        [friendViewControllerTwoDictionary setObject:friendTwoUserInfo forKey:kSlideViewControllerViewControllerUserInfoKey];
        
        NSMutableDictionary *friendViewControllerThreeDictionary = [NSMutableDictionary dictionary];
        [friendViewControllerThreeDictionary setObject:@"Blake" forKey:kSlideViewControllerViewControllerTitleKey];
        [friendViewControllerThreeDictionary setObject:[FriendViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        [friendViewControllerThreeDictionary setObject:@"FriendViewController" forKey:kSlideViewControllerViewControllerNibNameKey];
        [friendViewControllerThreeDictionary setObject:[UIImage imageNamed:@"bsirach.jpg"] forKey:kSlideViewControllerViewControllerIconKey];
        NSMutableDictionary *friendThreeUserInfo = [NSMutableDictionary dictionary];
        [friendThreeUserInfo setObject:@"Blake" forKey:@"name"];
        [friendThreeUserInfo setObject:@"24" forKey:@"age"];
        [friendViewControllerThreeDictionary setObject:friendThreeUserInfo forKey:kSlideViewControllerViewControllerUserInfoKey];
        
        [sectionTwo setObject:[NSArray arrayWithObjects:friendViewControllerOneDictionary, friendViewControllerTwoDictionary, friendViewControllerThreeDictionary, nil] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionTwo];
        
        NSMutableDictionary *sectionThree = [NSMutableDictionary dictionary];
        [sectionThree setObject:@"" forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *settingsViewControllerDictionary = [NSMutableDictionary  dictionary];
        [settingsViewControllerDictionary setObject:@"Settings" forKey:kSlideViewControllerViewControllerTitleKey];
        [settingsViewControllerDictionary setObject:[SettingsViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        
        [sectionThree setObject:[NSArray arrayWithObject:settingsViewControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionThree];
        */
        
    }
    
    return self;
}

- (void)dealloc {
    
    [_listViewController00 release];
    [_listViewController01 release];
    [_listViewController02 release];
    [_datasource release];
    [_searchDatasource release];
    
    [super dealloc];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return NO;
}

- (UIViewController *)initialViewController {
    
    if (_listViewController01 == nil) {
        
        _listViewController01 = [[PSViewController alloc] initWithNibName:@"PSViewController_iPhone" bundle:nil];
        _listViewController01.userinfo = [[[[_datasource objectAtIndex:0] objectForKey:kSlideViewControllerSectionViewControllersKey] objectAtIndex:1] objectForKey:kSlideViewControllerViewControllerUserInfoKey];
        
    }
        
    return _listViewController01;
}

- (NSIndexPath *)initialSelectedIndexPath {
    
    return [NSIndexPath indexPathForRow:1 inSection:0];
    
}

- (void)configureViewController:(UIViewController *)viewController userInfo:(id)userInfo {
    
    if ([viewController isKindOfClass:[PSViewController class]]) {
        
        NSDictionary *info = (NSDictionary *)userInfo;
        PSViewController *listViewController = (PSViewController *)viewController;
        listViewController.userinfo = info;
        
        if (![listViewController.userinfo isEqual:userInfo]) {
            
            listViewController.userinfo = info;
        }
        
        //[listViewController reloadData];
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
    UIViewController *viewController = nil;
    
    if (indexPath.section == 0) {
                
        DDLogInfo(@"%@\t%@", @"guide", [NSString stringWithFormat:@"%d", indexPath.row]);
        
        
        if (indexPath.row == 0) {
            
            if (_listViewController00 == nil) {
                
                _listViewController00 = [[PSViewController alloc] initWithNibName:@"PSViewController_iPhone" bundle:nil];
                
            } 
                
            viewController = _listViewController00;
            
            
        } else if (indexPath.row == 1) {
            
            if (_listViewController01 == nil) {
                
                _listViewController01 = [[PSViewController alloc] initWithNibName:@"PSViewController_iPhone" bundle:nil];
                
            } 
                
            viewController = _listViewController01;
            
            
        } else if (indexPath.row == 2) {
            
            if (_listViewController02 == nil) {
                
                _listViewController02 = [[PSViewController alloc] initWithNibName:@"PSViewController_iPhone" bundle:nil];
                
            } 
                
            viewController = _listViewController02;
            
        
        } else {
        
            viewController = [[[viewControllerClass alloc] initWithNibName:nibNameOrNil bundle:nil] autorelease];
        }
    
    } else {
    
         viewController = [[[viewControllerClass alloc] initWithNibName:nibNameOrNil bundle:nil] autorelease];
    }
    
    if ([self.delegate respondsToSelector:@selector(configureViewController:userInfo:)]) {
        
        [self.delegate configureViewController:viewController userInfo:[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerUserInfoKey]];
    }
    
    [self configureViewController:viewController];
    
    [_slideNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
    
    //[viewController release];
    
    [self slideInSlideNavigationControllerView];
    
}

/*
- (void)configureSearchDatasourceWithString:(NSString *)string {

    NSArray *searchableControllers = [[[self datasource] objectAtIndex:1] objectForKey:kSlideViewControllerSectionViewControllersKey];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slideViewControllerViewControllerTitle CONTAINS[cd] %@", string];
    [_searchDatasource setArray:[searchableControllers filteredArrayUsingPredicate:predicate]];
    
}

- (NSArray *)searchDatasource  {
    
    return _searchDatasource;
}
*/

@end
