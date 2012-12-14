//
//  PSBroView.m
//  BroBoard
//
//  Created by Bruce Chen on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 This is an example of a subclass of PSCollectionViewCell
 */

#import "PSBroView.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"


#define MARGIN 4.0 

@interface PSBroView () <ASIHTTPRequestDelegate>

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *captionLabel;
@property (nonatomic, retain) UILabel *captionLabel2;
@property (nonatomic, retain) ASIHTTPRequest *request;

@end

@implementation PSBroView

@synthesize
imageView = _imageView,
captionLabel = _captionLabel,
captionLabel2 = _captionLabel2,
request = _request;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
    
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        

        self.captionLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.captionLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.captionLabel.numberOfLines = 0;
        [self.captionLabel setTextAlignment:NSTextAlignmentCenter];
        [self.captionLabel setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8]];
        [self.captionLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:176.0/255.0 alpha:1.0]];
        [self addSubview:self.captionLabel];
        
        
        self.captionLabel2 = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.captionLabel2.font = [UIFont boldSystemFontOfSize:12.0];
        self.captionLabel2.numberOfLines = 0;
        [self.captionLabel2 setTextAlignment:NSTextAlignmentCenter];
        [self.captionLabel2 setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4]];
        [self.captionLabel2 setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
        [self addSubview:self.captionLabel2];
    }
    
    return self;
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    self.imageView.image = nil;
    self.captionLabel.text = nil;
    self.captionLabel2.text = nil;
}

- (void)dealloc {
    
    NSLog(@"[PSBroView dealloc]");
    
    self.imageView = nil;
    self.captionLabel = nil;
    self.captionLabel2 = nil;
    
    [_request clearDelegatesAndCancel];
    self.request = nil;
    
    [super dealloc];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width - MARGIN * 2;
    CGFloat top = MARGIN;
    CGFloat left = MARGIN;
    
    
    // Image
    CGFloat objectWidth = 100.0f;
    CGFloat objectHeight = 100.0f;
    
    if ([[self.object objectForKey:@"width"] isKindOfClass:[NSNumber class]] && [[self.object objectForKey:@"height"] isKindOfClass:[NSNumber class]]) {
            
        if ([[self.object objectForKey:@"width"] floatValue] >= 0.0f && [[self.object objectForKey:@"height"] floatValue] >= 0.0f) {
            
            objectWidth = [[self.object objectForKey:@"width"] floatValue];
            objectHeight = [[self.object objectForKey:@"height"] floatValue];
        }
    }
    
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    self.imageView.frame = CGRectMake(left, top, width, scaledHeight);
    
    // Label
    CGSize labelSize = CGSizeZero;
    labelSize = [self.captionLabel.text sizeWithFont:self.captionLabel.font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:self.captionLabel.lineBreakMode];
    //top = self.imageView.frame.origin.y + self.imageView.frame.size.height + MARGIN;
    
    self.captionLabel.frame = CGRectMake(MARGIN, scaledHeight + MARGIN - labelSize.height, labelSize.width + 10.0f, labelSize.height);
    
    
    
    labelSize = [self.captionLabel2.text sizeWithFont:self.captionLabel2.font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:self.captionLabel2.lineBreakMode];
    
    self.captionLabel2.frame = CGRectMake(width - MARGIN - labelSize.width - 2.0, scaledHeight + MARGIN - labelSize.height, labelSize.width + 10.0f, labelSize.height);

}

- (void)fillViewWithObject:(id)object {
    
    [super fillViewWithObject:object];
    
    self.imageView.image = [UIImage imageNamed:@"gray.png"];
    
    NSURL *url = [NSURL URLWithString:[object objectForKey:@"pic_url"]];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [self.request clearDelegatesAndCancel];
    self.request = request;
    [_request setDownloadCache:[ASIDownloadCache sharedCache]];
    [_request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    [_request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
    [_request setDelegate:self];
    
    [_request start];
    
    /*
    NSString *keyString = [@"pic_" stringByAppendingFormat:@"%@", [(NSString *)[object objectForKey:@"pic_url"] MD5EncodedString]];
    
    if ([[LdbHandler sharedCacheDb] getObject:keyString]) {
        
        //dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image = [UIImage imageWithData:[[LdbHandler sharedCacheDb] getObject:keyString]];
        //});
        
    
    } else {
    
        NSURL *URL = [NSURL URLWithString:[object objectForKey:@"pic_url"]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            //dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image = [UIImage imageWithData:data];
            
            if (data && [data length] > 0) {
                
                [[LdbHandler sharedCacheDb] putObject:data forKey:keyString];
            }
            //});
            
        }]; 
    }
     */
    
    self.captionLabel.text = [NSString stringWithFormat:@"¥%@", [object objectForKey:@"price"]];
    self.captionLabel2.text = [NSString stringWithFormat:@"销量(%@)", [object objectForKey:@"volume"]];
}

+ (CGFloat)heightForViewWithObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    
    CGFloat height = 0.0;
    CGFloat width = columnWidth - MARGIN * 2;
    
    height += MARGIN;
    
    // Image
    CGFloat objectWidth = [[object objectForKey:@"width"] floatValue];
    CGFloat objectHeight = [[object objectForKey:@"height"] floatValue];
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    height += scaledHeight;
    
    // Label
    /*
    NSString *caption = [object objectForKey:@"title"];
    CGSize labelSize = CGSizeZero;
    UIFont *labelFont = [UIFont boldSystemFontOfSize:14.0];
    labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    height += labelSize.height;
    */
    
    height += MARGIN;
    
    return height;
}

#pragma - mark ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {

    [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageWithData:[_request responseData]] afterDelay:0.01];
}



- (void)requestFailed:(ASIHTTPRequest *)request {

    NSError *error = [_request error];
    NSLog(@"%@", error);
}




@end
