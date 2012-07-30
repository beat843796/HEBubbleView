//
//  HEAppDelegate.h
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 Clemens Hammerl / Adam Eri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HESampleController.h"

@interface HEAppDelegate : UIResponder <UIApplicationDelegate>
{
    
    HESampleController *bubbleController;
    UINavigationController *nav;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HESampleController *bubbleController;
@property (strong, nonatomic) UINavigationController *nav;

@end
