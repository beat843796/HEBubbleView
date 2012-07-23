//
//  HEAppDelegate.h
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HEBubbleViewController.h"

@interface HEAppDelegate : UIResponder <UIApplicationDelegate>
{
    
    HEBubbleViewController *bubbleController;
    UINavigationController *nav;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HEBubbleViewController *bubbleController;
@property (strong, nonatomic) UINavigationController *nav;

@end
