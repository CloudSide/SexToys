//
//  SettingsViewController.m
//  SexToys
//
//  Created by Bruce on 12-12-10.
//  Copyright (c) 2012年 Bruce. All rights reserved.
//

#import "SettingsViewController.h"
#import "TopWebViewController.h"
#import "AppDelegate.h"
#import "ReviewViewController.h"
#import "SettingLockerViewController.h"
#import "ASIDownloadCache.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize hud = _hud;

- (void)dealloc {

    [_hud setDelegate:nil];
    [_hud release];
    
    [super dealloc];
}

- (void)openTaobao {
    
    TopWebViewController *webViewController = [[[TopWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://my.m.taobao.com/myTaobao.htm"]] autorelease];
    webViewController.availableActions = SVWebViewControllerAvailableActionsNone | SVWebViewControllerAvailableActionsOpenInSafari;
	[[AppDelegate sharedAppDelegate].navigationController pushViewController:webViewController animated:YES];
    
}


- (void)openAbout {
    
    TopWebViewController *webViewController = [[[TopWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.worldgogo.com/xjb/about.html"]] autorelease];
    webViewController.availableActions = SVWebViewControllerAvailableActionsNone | SVWebViewControllerAvailableActionsOpenInSafari;
	[[AppDelegate sharedAppDelegate].navigationController pushViewController:webViewController animated:YES];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [[AppDelegate sharedAppDelegate].navigationController setNavigationBarHidden:YES];
    [super viewDidAppear:animated];
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    
    if (self) {
    
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_user.png"]]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_logo.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:176.0/255.0 alpha:1.0]];
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
            
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 3;
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
    
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.textColor = [UIColor colorWithRed:50/255.0 green:58/255.0 blue:60/255.0 alpha:1];
    cell.detailTextLabel.text = @"";
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"查看我的淘宝订单";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        
    } else if (indexPath.section == 1) {
        
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"隐私保护";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } else if (indexPath.row == 1) {
        
            cell.textLabel.text = @"客服QQ: 12562426";
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        } else if (indexPath.row == 2) {
            
            cell.textLabel.text = @"服务时间: 9:00~18:00 (周一至周五)";
            
        } else if (indexPath.row == 3) {
            
            cell.textLabel.text = @"意见反馈";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }


    
    } else if (indexPath.section == 2) {
    
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"清除缓存";
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } else if (indexPath.row == 1) {
            
            cell.textLabel.text = @"检查更新";
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } else if (indexPath.row == 2) {
            
            cell.textLabel.text = @"关于情趣宝";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

    }
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0) {
        
        
        if (indexPath.row == 0) {
            
            [self openTaobao];
        }
        
        
    } else if (indexPath.section == 1) {
        
        
        if (indexPath.row == 0) {
            
            SettingLockerViewController *settingLockerViewController = [[SettingLockerViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:settingLockerViewController animated:YES];
            [settingLockerViewController release];
            
        } else if (indexPath.row == 1) {
            
    
            
        } else if (indexPath.row == 2) {
            
    
            
        } else if (indexPath.row == 3) {
            
            ReviewViewController *reviewViewController = [[[ReviewViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
            [self.navigationController pushViewController:reviewViewController animated:YES];
        }
        
        
        
    } else if (indexPath.section == 2) {
        
        
        if (indexPath.row == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要清除缓存吗?"
                                                           delegate:self
                                                  cancelButtonTitle:@"否"
                                                  otherButtonTitles:@"是", nil];
            alert.tag = kTagMoreViewClearCacheAlertView;
            [alert show];
            [alert release];
            
        } else if (indexPath.row == 1) {
            
            if (nil == _indicatorView) {
                _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                _indicatorView.frame = CGRectMake(280, 13, 20, 20);
                [_indicatorView hidesWhenStopped];
                UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell addSubview:_indicatorView];
            }
            
            if (nil == _updateCheck){
                
                _updateCheck = [[UpdateCheck alloc] init];
                _updateCheck.delegate = self;
            }
            
            if (![_indicatorView isAnimating]) {
                
                [_updateCheck check];
                [_indicatorView  startAnimating];
            }
            
        } else if (indexPath.row == 2) {
            
            [self openAbout];
        }
        
    }
}



- (void)clearCache {
    
    //[[LdbHandler sharedCacheDb] deleteDatabase];
    [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    sleep(1);
}

#pragma mark - UpdateCheckDelegate

- (void)hasNewVersion {
    
    [_indicatorView stopAnimating];
}

- (void)noNewVersion {
    
    [_indicatorView stopAnimating];
    [_hud hide:NO];
    self.hud = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    [self.navigationController.view addSubview:_hud];
    _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.dimBackground = YES;
    _hud.delegate = self;
    _hud.labelText = @"当前版本已是最新版本";
    
    [_hud show:NO];
    [_hud hide:YES afterDelay:1];
}

- (void)checkFailed:(NSString *)errMsg {
    
    [_indicatorView stopAnimating];
    [_hud hide:NO];
    self.hud = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    [self.navigationController.view addSubview:_hud];
    _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"X.png"]] autorelease];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.dimBackground = YES;
    _hud.delegate = self;
    _hud.labelText = @"检测更新失败";
    _hud.detailsLabelText = @"网络连接失败";
    
    [_hud show:NO];
    [_hud hide:YES afterDelay:1.5];
}


#pragma mark - UIAlertViewDelegate



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == kTagMoreViewClearCacheAlertView) {
        
        switch (buttonIndex) {
                
            case 1: {
                
                [_hud hide:NO];
                
                self.hud = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
                [self.navigationController.view addSubview:_hud];
                _hud.dimBackground = YES;
                _hud.delegate = self;
                _hud.labelText = @"正在清理缓存...";
                _hud.detailsLabelText = nil;
                _hud.mode = MBProgressHUDModeIndeterminate;
                [_hud showWhileExecuting:@selector(clearCache) onTarget:self withObject:nil animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
	[_hud removeFromSuperview];
    //	[_hud release];
    //	_hud = nil;
}

@end
