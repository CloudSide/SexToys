//
//  BarItemController.m
//  DailyDeals
//
//  Created by  on 12-1-19.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "BarItemController.h"

@implementation BarItemController

@synthesize button = _button;
@synthesize count = _count;
@synthesize name = _name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    
    _count.text = nil;
    _name.text = nil;
    
    [super viewDidLoad];
}

- (void)setCountValue:(NSString *)value {

    _count.text = value;
    
    CGFloat width = [value sizeWithFont:[UIFont systemFontOfSize:11.0]].width;
    CGFloat space = 2.0;
    
    CGFloat maxWidth = 80.0;
    CGFloat nameWidth = [_name.text sizeWithFont:[UIFont systemFontOfSize:11.0]].width;
    CGFloat height = 14.0;

    CGFloat x = (maxWidth - width - space - nameWidth) / 2.0;
    
    if (_count.text == nil) {
        
        space = 0.0;
        width = 0.0;
        nameWidth = 0.0;
    }
    
    _count.frame = CGRectMake(x, _count.frame.origin.y, width, height);
    _name.frame = CGRectMake(x + width + space, _name.frame.origin.y, nameWidth, height);
    
}

- (void)dealloc {

    [_button release];
    [_name release];
    [_count release];
    [super dealloc];
}

@end
