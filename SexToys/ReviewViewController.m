//
//  ReviewViewController.m
//  DailyDeals
//
//  Created by Bruce Chen on 11-12-28.
//  Copyright (c) 2011年 Sina. All rights reserved.
//

#import "ReviewViewController.h"


@implementation ReviewViewController

@synthesize textContainer = _textContainer;
@synthesize UUID = _UUID;
@synthesize hud = _hud;

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    
    if (self) {
        
        _textContainer = [[UITextView alloc] init];
		_textContainer.textColor = [UIColor colorWithRed:16.0/255.0 green:60.0/255.0 blue:92.0/255.0 alpha:1.0];
		_textContainer.font = [UIFont fontWithName:@"Arial" size:18];
		_textContainer.delegate = self;
		_textContainer.backgroundColor = [UIColor whiteColor];
		_textContainer.text = @"";
		_textContainer.returnKeyType = UIReturnKeyDefault;
		_textContainer.keyboardType = UIKeyboardTypeDefault;
		_textContainer.scrollEnabled = YES;
		_textContainer.backgroundColor = [UIColor clearColor];
		_textContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        self.UUID = [[NSUserDefaults standardUserDefaults] stringForKey:kUUID];
        
    }
    
    return self;
}

- (void)dealloc {
    
    _textContainer.delegate = nil;
    [_textContainer release];
    
    [_UUID release];
    
    _hud.delegate = nil;
    [_hud release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)back {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)_sleep {
    
    _hud.customView = [[[UIImageView alloc] init] autorelease];
    _hud.mode = MBProgressHUDModeCustomView;
    sleep(1);
    [_textContainer performSelectorOnMainThread:@selector(becomeFirstResponder) withObject:nil waitUntilDone:YES];
}

- (void)_post {

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kApiReviewURL]];
    
    [request setRequestMethod:@"POST"];
    //[request addRequestHeader:@"User-Device" value:[NSString stringWithFormat:@"%@/", _UUID]];
    [request setPostValue:_textContainer.text forKey:@"content"];
    [request setPostValue:[ASIHTTPRequest defaultUserAgentString] forKey:@"device"];
    [request startSynchronous];
    
    sleep(1);
        
    NSError *error = [request error];
	
	if (!error) {
        
        if ([[[request responseString] JSONValue] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *data = [[request responseString] JSONValue];
            
            NSLog(@"%@", data);
        }
        
        
        
        
    } else {
        
        
    }
    
    
    
    [_textContainer performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:YES];
        
    _hud.labelText = @"反馈发送成功";
    _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    _hud.mode = MBProgressHUDModeCustomView;
        
    sleep(1);
    
    [_textContainer performSelectorOnMainThread:@selector(becomeFirstResponder) withObject:nil waitUntilDone:YES];
    
    [self performSelectorOnMainThread:@selector(back) withObject:nil waitUntilDone:YES];
}

- (void)post {
    
    [_textContainer resignFirstResponder];
    
    NSString *msg = [_textContainer.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
    
    if (msg.length < 1) {
        
        _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:_hud];
        
        _hud.delegate = self;
        _hud.labelText = @"反馈内容不能为空";
        _hud.dimBackground = YES;
        [_hud showWhileExecuting:@selector(_sleep) onTarget:self withObject:nil animated:YES];

        
    } else {
    
        _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:_hud];
        _hud.delegate = self;
        _hud.labelText = @"正在发送...";
        _hud.dimBackground = YES;
        [_hud show:YES];
        [_hud showWhileExecuting:@selector(_post) onTarget:self withObject:nil animated:YES];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"填写反馈";
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
    
    self.navigationItem.rightBarButtonItem =
	[[[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleBordered
									 target:self action:@selector(post)] autorelease];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [_textContainer becomeFirstResponder];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        CGRect bounds = CGRectMake(0, 0, tableView.bounds.size.width - 2.0, 44.0);
        CGRect rect = CGRectInset(bounds, 17.0, 11.0);
        
        cell.frame = CGRectMake(0.0, 0.0, cell.frame.size.width, 150.0);
		
		bounds = CGRectMake(0, 0, tableView.bounds.size.width - 16.0, cell.bounds.size.height);
		rect = CGRectInset(bounds, 5.0, 5.0);
		
		_textContainer.frame = rect;
		[cell.contentView addSubview:_textContainer];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 150.0;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    // Remove HUD from screen when the HUD was hidded
    [_hud removeFromSuperview];
	self.hud = nil;
}

@end
