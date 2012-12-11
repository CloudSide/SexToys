//
//  SettingLockerViewController.m
//  VDiskMobile
//
//  Created by gaopeng on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingLockerViewController.h"
#import "LockerViewController.h"
#import "DetailViewController.h"


@interface SettingLockerViewController ()

@end

@implementation SettingLockerViewController

@synthesize verifyPassed = _verifyPassed; 
@synthesize switchView = _switchView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        titleLabel.shadowColor = [UIColor whiteColor];
        [titleLabel setShadowOffset:CGSizeMake(0, -1)];
        titleLabel.text = @"密码锁         ";
        self.navigationItem.titleView = titleLabel;
        
        
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
            _verifyPassed = NO;
            
        } else {
            
            _verifyPassed = YES;
        }
        
        self.tableView.scrollEnabled = NO;
    }
    
    return self;
}

- (void)switchChanged: (id)sender {
    
    NSString *passcode = [Static getPasscode];
    
    if (passcode == nil) {
        
        LockerViewController *locker = [[LockerViewController alloc] initWithStyle:kPasscodeStyleSet];
        locker.delegate = self;
        UINavigationController *lockerNavController = [[[UINavigationController alloc] initWithRootViewController:locker] autorelease];
        [self.navigationController presentModalViewController:lockerNavController animated:YES];
        [locker release];
        
    } else {
        
        LockerViewController *locker = [[LockerViewController alloc] initWithStyle:kPasscodeStyleVerifyClose];
        locker.delegate = self;
        UINavigationController *lockerNavController = [[[UINavigationController alloc] initWithRootViewController:locker] autorelease];
        [self.navigationController presentModalViewController:lockerNavController animated:YES];
        [locker release];
    }
}

- (void)dealloc {
    
    [_switchView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        
//        NSString *passcode = [Static getPasscode];
//        if (passcode == nil) {
//            
//            LockerViewController *locker = [[LockerViewController alloc] initWithStyle:kPasscodeStyleSet];
//            locker.delegate = self;
//            UINavigationController *lockerNavController = [[[UINavigationController alloc] initWithRootViewController:locker] autorelease];
//            [locker release];
//            [self.navigationController presentModalViewController:lockerNavController animated:YES];
//        } else {
//            
//            LockerViewController *locker = [[LockerViewController alloc] initWithStyle:kPasscodeStyleVerify];
//            locker.delegate = self;
//            UINavigationController *lockerNavController = [[[UINavigationController alloc] initWithRootViewController:locker] autorelease];
//            [locker release];
//            [self.navigationController presentModalViewController:lockerNavController animated:YES];
//        }
//    }
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
//    if (!_verifyPassed) {
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
        
    } else {
        
        return YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell...
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"密码锁";
            cell.accessoryView = _switchView;
            if (!kShareAppDelegate.hasPasscode) {
                
                _switchView.on = NO;
            } else {
                _switchView.on = YES;
            }
            cell.textLabel.textAlignment = UITextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    } else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            if (!kShareAppDelegate.hasPasscode) {
                cell.userInteractionEnabled = NO;
                cell.textLabel.enabled = NO;
            } else {
                
                cell.userInteractionEnabled = YES;
                cell.textLabel.enabled = YES;
            }
            cell.textLabel.text = @"修改密码";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return nil;
        }
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
    
    } else if (indexPath.section == 1) {
        
        LockerViewController *locker = [[LockerViewController alloc] initWithStyle:kPasscodeStyleReset];
        locker.delegate = self;
        UINavigationController *lockerNavController = [[[UINavigationController alloc] initWithRootViewController:locker] autorelease];
        [self.navigationController presentModalViewController:lockerNavController animated:YES];
        [locker release];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - LockerViewDelegate

- (void)lockerSetSuccess:(LockerViewController *)lockerViewController {
    
    NSLog(@"set success");
    self.verifyPassed = YES;
    [self.tableView reloadData];
}

- (void)lockerCancel:(LockerViewController *)lockerViewController {
    
    [self.tableView reloadData];
}

- (void)lockerVerifyPassed:(LockerViewController *)lockerViewController {
    
    NSLog(@"verify success");
    self.verifyPassed = YES;
    [self.tableView reloadData];
    //if (lockerViewController.style == kPasscodeStyleVerifyClose) {
        
        //[self.navigationController popViewControllerAnimated:YES];
    //}
}

- (void)lockerResetSuccess:(LockerViewController *)lockerViewController {
    
    NSLog(@"reset success");
}

@end
