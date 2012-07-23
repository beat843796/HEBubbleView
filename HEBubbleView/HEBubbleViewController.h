//
//  HEBubbleViewController.h
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HEBubbleView.h"
#import "HEBubbleViewItem.h"

@interface HEBubbleViewController : UIViewController <HEBubbleViewDataSource, HEBubbleViewDelegate>
{
    
    NSMutableArray *data;
    
    HEBubbleView *bubbleView;
    
}
@end
