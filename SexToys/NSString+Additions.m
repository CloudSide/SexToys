//
//  NSString+Additions.m
//  DailyDeals
//
//  Created by Bruce Chen on 11-12-26.
//  Copyright (c) 2011年 Sina. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (NSString_Additions)

- (NSString *)stringByDecodingURLFormat {
    
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end