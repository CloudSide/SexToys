//
//  Static.m
//  DailyDeals
//
//  Created by Bruce Chen on 11-12-28.
//  Copyright (c) 2011年 Sina. All rights reserved.
//

#import "Static.h"

@implementation Static


+ (void)hideGradientBackground:(UIView *)theView {
    
    for (UIView * subview in theView.subviews) {
        
        if ([subview isKindOfClass:[UIImageView class]]) {
            
            subview.hidden = YES;
        }
        
        [Static hideGradientBackground:subview];
    }
}

+ (NSString *)getPasscode {

    return [[LdbHandler sharedDb] getString:@"passcode"];
}


+ (id)infoValueForKey:(NSString *)key {
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

@end
