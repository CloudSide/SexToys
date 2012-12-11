//
//  LockerViewController.m
//  MyTestProject
//
//  Created by gaopeng on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LockerViewController.h"
#import "MainViewController.h"
#import <AudioToolbox/AudioServices.h>

@interface LockerViewController ()

@end

@implementation LockerViewController

@synthesize passcode = _passcode, delegate = _delegate, style = _style, errorFlag = _errorFlag;

- (id)initWithStyle:(kPasscodeStyle) style {
    
    self = [super init];
    if (self) {
        
        _style = style;
        _fisrtflag = YES;
        _resetVerifyPassed = NO;
        _errorTime = 0;
        _maxErrorTime = 10;
        _passcode = [[Static getPasscode] retain];
        _errorFlag = NO;
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
            self.view.backgroundColor = RGBACOLOR(214.0, 219.0, 228.0, 1);
        }
    }
    return self;
}

- (void)dealloc {
    
    [_delegate release];
    _delegate = nil;
    [_passcode release];
    [super dealloc];
}

- (void)cancel {

    if (_delegate != nil && [_delegate respondsToSelector:@selector(lockerCancel:)]) {
        
        [_delegate lockerCancel:self];
    }
    kShareAppDelegate.verifyPassed = YES;
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    titleLabel.shadowColor = [UIColor whiteColor];
    [titleLabel setShadowOffset:CGSizeMake(0, -1)];
    self.navigationItem.titleView = titleLabel;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_logo.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:176.0/255.0 alpha:1.0]];
    
    if (_style == kPasscodeStyleReset) {
        
        titleLabel.text = @"           修改密码";
        UILabel *lable = (UILabel *)[self.view viewWithTag:kPasscodePanelTitleTag];
        lable.text = @"请输入原密码";
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];//add autorelease by gaopeng on 2012-10-31
        
    } else if (_style == kPasscodeStyleSet){
        
        titleLabel.text = @"           设置密码";
        UILabel *lable = (UILabel *)[self.view viewWithTag:kPasscodePanelTitleTag];
        lable.text = @"请输入密码";
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];//add autorelease by gaopeng on 2012-10-31
        
    } else if (_style == kPasscodeStyleVerifyLogin){
        
        titleLabel.text = @"解锁";
        UILabel *lable = (UILabel *)[self.view viewWithTag:kPasscodePanelTitleTag];
        lable.text = @"请输入密码";
    } else if (_style == kPasscodeStyleVerifyClose){
        
        titleLabel.text = @"           取消密码锁";
        UILabel *lable = (UILabel *)[self.view viewWithTag:kPasscodePanelTitleTag];
        lable.text = @"请输入密码";
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];//add autorelease by gaopeng on 2012-10-31
    } else {
        
        titleLabel.text = @"           输入密码";
        UILabel *lable = (UILabel *)[self.view viewWithTag:kPasscodePanelTitleTag];
        lable.text = @"请输入密码";
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];//add autorelease by gaopeng on 2012-10-31
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIView *panelView = [self createPanel:CGRectMake(kPasscodePanelX, kPasscodePanelY, kPasscodePanelWidth, kPasscodePanelHeight) tagIndex:kPasscodePanel];
    [self.view addSubview:panelView];
    //[panelView release];//remove by gaopeng on 2012-10-31
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    [textField setDelegate:self];
    [textField setTag:kPasscodeFakeTextField];
    [textField setHidden:YES];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:textField];
    [textField release];
    [textField becomeFirstResponder];
    
    // Create title
    CGRect labelFrame = CGRectMake(kPasscodePanelX + 25.0, 22.0, kPasscodeEntryWidth * 4 + 30, 30.0);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setTag:kPasscodePanelTitleTag];
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    [label setTextAlignment:UITextAlignmentCenter];    
    [label setTextColor:[UIColor colorWithRed:66.0/255.0 green:85.0/255.0 blue:102.0/255.0 alpha:1.0]];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    [label release];
    
    // Create summary
    labelFrame = CGRectMake(kPasscodePanelX + 25.0, 130.0, kPasscodeEntryWidth * 4 + 30, 40.0);
    label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setTag:kPasscodePanelSummaryTag];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [label setNumberOfLines:0];
    [label setBaselineAdjustment:UIBaselineAdjustmentNone];
    [label setTextAlignment:UITextAlignmentCenter];    
    [label setTextColor:[UIColor redColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setShadowColor:[UIColor whiteColor]];
    [label setShadowOffset:CGSizeMake(1, 1)];
    [self.view addSubview:label];
    [label release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
        
    } else {
        
        return YES;
    }
}

- (UITextField*) createPasscodeEntry:(CGRect)textFieldFrame tag:(NSInteger)tag
{
    //CGRect textFieldFrame = CGRectMake(40.0, 60.0, 60.0, 60.0);
    //NSLog(@"tag:%d", tag);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldFrame];
    [textField setBorderStyle:UITextBorderStyleBezel];
    [textField setTextColor:[UIColor blackColor]];
    [textField setTextAlignment:UITextAlignmentCenter];
    [textField setFont:[UIFont systemFontOfSize:41]];
    [textField setTag:tag];
    [textField setSecureTextEntry:YES];
    [textField setBackgroundColor:[UIColor whiteColor]];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    return [textField autorelease];////add autorelease by gaopeng on 2012-10-31
}

- (UIView*) createPanel:(CGRect)rect tagIndex:(NSInteger)tagIndex
{
    UIView *panelView = [[UILabel alloc] initWithFrame:rect];
    [panelView setTag:tagIndex];
    [panelView setBounds:rect];
    [panelView setBackgroundColor:[UIColor clearColor]];
    
    UITextField *textField = [self createPasscodeEntry:CGRectMake(rect.origin.x + 25.0, rect.origin.y, kPasscodeEntryWidth, kPasscodeEntryHeight) tag:tagIndex + 1];
    [panelView addSubview:textField];
    //[textField  release];//remove by gaopeng on 2012-10-31
    
    textField = [self createPasscodeEntry:CGRectMake(rect.origin.x + 95.0, rect.origin.y, kPasscodeEntryWidth, kPasscodeEntryHeight) tag:tagIndex + 2];
    [panelView addSubview:textField];
    //[textField  release];//remove by gaopeng on 2012-10-31
    
    textField = [self createPasscodeEntry:CGRectMake(rect.origin.x + 165.0, rect.origin.y, kPasscodeEntryWidth, kPasscodeEntryHeight) tag:tagIndex + 3];
    [panelView addSubview:textField];
    //[textField  release];//remove by gaopeng on 2012-10-31
    
    textField = [self createPasscodeEntry:CGRectMake(rect.origin.x + 235.0, rect.origin.y, kPasscodeEntryWidth, kPasscodeEntryHeight) tag:tagIndex + 4];
    [panelView addSubview:textField];
    //[textField  release];//remove by gaopeng on 2012-10-31
    
    return [panelView autorelease];//add autorelease by gaopeng on 2012-10-31
}

- (void)enableInput {
    
    _errorFlag = NO;
}

- (void) clearPanel
{
    NSInteger panelTag = kPasscodePanel;
    
    UIView *currentPanel = [self.view viewWithTag:panelTag];
    
    UITextField *entryText =  (UITextField*)[currentPanel viewWithTag:panelTag + 1];
    [entryText setText:@""];
    
    entryText =  (UITextField*)[currentPanel viewWithTag:panelTag + 2];
    [entryText setText:@""];
    
    entryText =  (UITextField*)[currentPanel viewWithTag:panelTag + 3];
    [entryText setText:@""];
    
    entryText =  (UITextField*)[currentPanel viewWithTag:panelTag + 4];
    [entryText setText:@""];
    
    // Clear fake text field
    UITextField *textField = (UITextField*)[self.view viewWithTag:kPasscodeFakeTextField];
    [textField setText:@""];
    
    //[self performSelector:@selector(enableInput) withObject:nil afterDelay:0];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_errorFlag) {
        return NO;
    }
    NSString *passcode = [textField text];
    passcode = [passcode stringByReplacingCharactersInRange:range withString:string];
    //NSLog(@"%@", passcode);
    
    NSInteger index = [passcode length];
    if([string length] == 0) {
        index++;
    }
    
    if(index <= 4) {
        
        NSInteger tag = kPasscodePanel;
        UIView *currentPanel = [self.view viewWithTag:tag];
        UITextField *tf = (UITextField*)[currentPanel viewWithTag:tag + index];
        [tf setText:string];        
        UILabel *lable = (UILabel *)[self.view viewWithTag:kPasscodePanelSummaryTag];
        lable.hidden = YES;
        if (index == 4) {
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:passcode, @"passcode", currentPanel, @"panel", nil];
            [self performSelector:@selector(handlePasscode:) withObject:dict afterDelay:0];
            
            return NO;
        }
        
        return YES;
    } 
    
    return NO;
}

- (void)handlePasscode: (NSDictionary *)dict {
    
    [self handlePasscode:[dict objectForKey:@"passcode"] withView:[dict objectForKey:@"panel"]];
}

- (void)handlePasscode:(NSString *)passcode withView:(UIView *)currentPanel{
    
    if (_style == kPasscodeStyleSet) { //设置密码锁
        
        CATransition *transition = [CATransition animation]; 
        [transition setDelegate:self]; 
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
        [transition setType:kCATransitionPush]; 
        [transition setDuration:0.5f];
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        if (_fisrtflag) {
            
            self.passcode = passcode;
            UILabel *lable = (UILabel *)[self.view viewWithTag:kPasscodePanelTitleTag];
            lable.text = @"请再次输入新密码";
            lable = (UILabel *)[self.view viewWithTag:kPasscodePanelSummaryTag];
            lable.hidden = YES;
            [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];            
            [transition setSubtype:kCATransitionFromRight];
            _fisrtflag = NO;
        } else {
            if ([self.passcode isEqualToString:passcode]) {
                
                
                if (_delegate != nil && [_delegate respondsToSelector:@selector(lockerSetSuccess:)]) {
                    
                    [_delegate lockerSetSuccess:self];
                }
                [[LdbHandler sharedDb] putObject:passcode forKey:@"passcode"];
                kShareAppDelegate.verifyPassed = YES;
                kShareAppDelegate.hasPasscode = YES;
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
//                                                                message:@"密码锁设置成功" 
//                                                               delegate:nil 
//                                                      cancelButtonTitle:@"确定" 
//                                                      otherButtonTitles:nil];
//                alert.delegate = self;
//                [alert show];
//                [alert release];
                [self disView:NO];
                return;
                //[self dismissModalViewControllerAnimated:YES];
            } else {
                
                UILabel *lable = (UILabel *)[self.view viewWithTag:kPasscodePanelTitleTag];
                lable.text = @"请输入新密码";
                lable = (UILabel *)[self.view viewWithTag:kPasscodePanelSummaryTag];
                lable.text = @"两次密码输入不一致，请重新输入";
                lable.hidden = NO;
                [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
                [transition setSubtype:kCATransitionFromLeft];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                _fisrtflag = YES;
            }
        }
        _errorFlag = YES;
        [[currentPanel layer] addAnimation:transition forKey:@"swipe"];
        //[self clearPanel];
        
    } else if (_style == kPasscodeStyleVerify || _style == kPasscodeStyleVerifyClose || _style == kPasscodeStyleVerifyLogin) { //验证密码锁
        
        if ([self.passcode isEqualToString:passcode]) {
            
            kShareAppDelegate.isLocked = NO;
            if (_delegate != nil && [_delegate respondsToSelector:@selector(lockerVerifyPassed:)]) {
                
                [_delegate lockerVerifyPassed:self];
            }
            UIImageView *imageView = (UIImageView *)[kShareAppDelegate.window viewWithTag:kImageViewDefaultTag];
            [imageView removeFromSuperview];
            if (_style == kPasscodeStyleVerifyLogin) {
                
                kShareAppDelegate.verifyPassed = YES;
            }
            kShareAppDelegate.verifyPassed = YES;
            if (_style == kPasscodeStyleVerifyClose) {
                
                [[LdbHandler sharedDb] deleteObject:@"passcode"];
                
                kShareAppDelegate.hasPasscode = NO;
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
//                                                                message:@"密码锁已取消" 
//                                                               delegate:nil 
//                                                      cancelButtonTitle:@"确定" 
//                                                      otherButtonTitles:nil];
//                alert.delegate = self;
//                [alert show];
//                [alert release];
                [self disView:NO];
                return;
            } else {
                
                if (_style != kPasscodeStyleVerifyLogin) {
                    
                    [self dismissModalViewControllerAnimated:YES];
                } else {
                    
                    [kShareAppDelegate.navigationController dismissModalViewControllerAnimated:YES];
                }
            }
            
        } else {
            
            _errorFlag = YES;
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            [animation setDelegate:self]; 
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
            [animation setDuration:0.025];
            [animation setRepeatCount:8];
            [animation setAutoreverses:YES];
            [animation setFromValue:[NSValue valueWithCGPoint:CGPointMake([currentPanel center].x - 14.0f, [currentPanel center].y)]];
            [animation setToValue:[NSValue valueWithCGPoint:CGPointMake([currentPanel center].x + 14.0f, [currentPanel center].y)]];
            [[currentPanel layer] addAnimation:animation forKey:@"position"];
            UILabel *lable = (UILabel *)[self.view viewWithTag:kPasscodePanelSummaryTag];
            lable.hidden = NO;
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            if (_style == kPasscodeStyleVerifyLogin) {
                
                //lable.text = [NSString stringWithFormat:@"密码错误，请重新输入(失败%d/%d)", ++_errorTime, _maxErrorTime];
                
                lable.text = [NSString stringWithFormat:@"密码错误，请重新输入(失败:%d次)", ++_errorTime];
                
                if (_errorTime >= _maxErrorTime) {
                    
                    [[LdbHandler sharedDb] deleteObject:@"passcode"];
                    
                    kShareAppDelegate.hasPasscode = NO;

//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
//                                                                    message:@"为安全起见微盘将退出此帐号，请您重新登录" 
//                                                                   delegate:nil 
//                                                          cancelButtonTitle:@"确定" 
//                                                          otherButtonTitles:nil];
//                    alert.delegate = self;
//                    alert.tag = kPasscodeReloginAlert;
//                    [alert show];
//                    [alert release];
                    [self disView:YES];
                    return;
                }
            } else {
                
                lable.text = [NSString stringWithFormat:@"密码错误，请重新输入"];
            }
            
        }
        
    } else if (_style == kPasscodeStyleReset) {
        
        if (![self.passcode isEqualToString:passcode] && !_resetVerifyPassed) {
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            [animation setDelegate:self]; 
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
            [animation setDuration:0.025];
            [animation setRepeatCount:8];
            [animation setAutoreverses:YES];
            [animation setFromValue:[NSValue valueWithCGPoint:CGPointMake([currentPanel center].x - 14.0f, [currentPanel center].y)]];
            [animation setToValue:[NSValue valueWithCGPoint:CGPointMake([currentPanel center].x + 14.0f, [currentPanel center].y)]];
            [[currentPanel layer] addAnimation:animation forKey:@"position"];
            UILabel *lable = (UILabel *)[self.view viewWithTag:kPasscodePanelSummaryTag];
            lable.text = @"密码输入错误，请重新输入";
            ++_errorTime;
            lable.hidden = NO;
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        } else {
            
            CATransition *transition = [CATransition animation]; 
            [transition setDelegate:self]; 
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
            [transition setType:kCATransitionPush]; 
            [transition setDuration:0.5f];
            [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            
            if (_resetVerifyPassed) {
                if (_fisrtflag) {
                    
                    self.passcode = passcode;
                    UILabel *lable = (UILabel *)[self.view viewWithTag:kPasscodePanelTitleTag];
                    lable.text = @"确认密码";
                    lable = (UILabel *)[self.view viewWithTag:kPasscodePanelSummaryTag];
                    lable.hidden = YES;
                    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
                    [transition setSubtype:kCATransitionFromRight];
                    _fisrtflag = NO;
                    
                } else {
                    if ([self.passcode isEqualToString:passcode]) {
                        
                        if (_delegate != nil && [_delegate respondsToSelector:@selector(lockerResetSuccess::)]) {
                            
                            [_delegate lockerResetSuccess:self];
                        }
                        
                        [[LdbHandler sharedDb] putObject:passcode forKey:@"passcode"];
                        
                        kShareAppDelegate.verifyPassed = YES;
                        kShareAppDelegate.hasPasscode = YES;
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
//                                                                        message:@"密码修改成功" 
//                                                                       delegate:nil 
//                                                              cancelButtonTitle:@"确定" 
//                                                              otherButtonTitles:nil];
//                        alert.delegate = self;
//                        [alert show];
//                        [alert release];
                        [self disView:NO];
                        return;
                        //[self dismissModalViewControllerAnimated:YES];
                    } else {
                        
                        UILabel *lable = (UILabel *)[self.view viewWithTag:kPasscodePanelTitleTag];
                        lable.text = @"输入新密码";
                        lable = (UILabel *)[self.view viewWithTag:kPasscodePanelSummaryTag];
                        lable.text = @"两次密码输入不一致，请重新输入";
                        lable.hidden = NO;
                        [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
                        [transition setSubtype:kCATransitionFromLeft];
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        _fisrtflag = YES;
                    }
                }
            } else {
                
                _resetVerifyPassed = YES;
                UILabel *lable = (UILabel *)[self.view viewWithTag:kPasscodePanelTitleTag];
                lable.text = @"输入新密码";
                [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
                [transition setSubtype:kCATransitionFromRight];
            }
            
            [self clearPanel];
            [[currentPanel layer] addAnimation:transition forKey:@"swipe"];
        }
    }
}

- (void)animationDidStart:(CAAnimation *)anim {
    
    [self clearPanel];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    
    [self enableInput];
}

- (void)disView:(BOOL)logout {
    
    if (logout) {
        
        UIImageView *imageView = (UIImageView *)[kShareAppDelegate.window viewWithTag:kImageViewDefaultTag];
        [imageView removeFromSuperview];
        kShareAppDelegate.verifyPassed = YES;
        [kShareAppDelegate.navigationController popToRootViewControllerAnimated:NO];
        [[LdbHandler sharedDb] deleteObject:@"passcode"];
        kShareAppDelegate.hasPasscode = NO;
  
    } else {
        
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == kPasscodeReloginAlert) {
        
        [self disView:YES];
    } else {
        
        [self disView:NO];
    }
}
@end
