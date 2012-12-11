//
//  BarItemController.h
//  DailyDeals
//
//  Created by  on 12-1-19.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarItemController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *button;
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *count;

- (void)setCountValue:(NSString *)value;

@end
