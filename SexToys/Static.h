//
//  Static.h
//  DailyDeals
//
//  Created by Bruce Chen on 11-12-28.
//  Copyright (c) 2011年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Static : NSObject

+ (void)hideGradientBackground:(UIView *)theView;
+ (NSString *)getPasscode;
+ (id)infoValueForKey:(NSString *)key;

@end
