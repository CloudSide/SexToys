//
//  UIViewController+iOS6Autorotation.m
//  VDiskMobile
//
//  Created by dongni on 12-9-26.
//
//

#import "UIViewController+iOS6Autorotation.h"

@implementation UIViewController (iOS6Autorotation)
#ifdef __IPHONE_6_0
/*
 * We've swizzled the new iOS 6 autorotation callbacks onto their iOS 5 and iOS 4 equivalents
 * to preserve existing functionality.
 *
 */
- (BOOL)sp_shouldAutorotate {
    BOOL shouldAutorotate = YES;
    if ([self respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)]) {
        NSUInteger mask = 0;
        if ([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait]) {
            mask |= UIInterfaceOrientationMaskPortrait;
        }
        if ([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft]) {
            mask |= UIInterfaceOrientationMaskLandscapeLeft;
        }
        if ([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight]) {
            mask |= UIInterfaceOrientationMaskLandscapeRight;
        }
        if ([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown]) {
            mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
        }
        if (mask == 0) {
            // Shouldn't autorotate to *any* orientation.
            shouldAutorotate = NO;
        }
        [self shouldAutorotateToInterfaceOrientation:[[UIDevice currentDevice] orientation]];
    } else {
        // This actually calls the original method implementation
        // instead of recursively calling into this method implementation.
        shouldAutorotate = [self sp_shouldAutorotate];
    }
    return shouldAutorotate;
}

- (NSUInteger)sp_supportedInterfaceOrientations {
    NSUInteger mask = 0;
    
    /*
     * In iOS 6, Apple dramatically changed the way autorotation works.
     * Rather than having each view controller respond to shouldAutorotateToInterfaceOrientation:
     * to specify whether or not it could support a particular orientation, the responsibility was
     * shifted to top-level container view controllers. That means UINavigationController becomes
     * responsible for declaring whether or not an orientation is supported. Since our app
     * has logic for how to autorotate on a per view controller basis, we call through to the
     * swizzled version of supportedInterfaceOrientations for the topViewController.
     *
     */
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [[(UINavigationController *)self topViewController] supportedInterfaceOrientations];
    }
    
    if ([self respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)]) {
        if ([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait]) {
            mask |= UIInterfaceOrientationMaskPortrait;
        }
        if ([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft]) {
            mask |= UIInterfaceOrientationMaskLandscapeLeft;
        }
        if ([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight]) {
            mask |= UIInterfaceOrientationMaskLandscapeRight;
        }
        if ([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown]) {
            mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
        }
        [self shouldAutorotateToInterfaceOrientation:[[UIDevice currentDevice] orientation]];
    } else {
        // This actually calls the original method implementation
        // instead of recursively calling into this method implementation.
        mask = [self sp_supportedInterfaceOrientations];
    }
    return mask;
}
#endif

@end
