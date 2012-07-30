//
//  HEBubbleViewController.h
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 Clemens Hammerl / Adam Eri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HEBubbleView.h"
#import "HEBubbleViewItem.h"

/*
 Always implement the DataSource, Delegate is optional, though menu callouts are only possinle
 when implementing the deleagate
 */

@interface HESampleController : UIViewController <HEBubbleViewDataSource, HEBubbleViewDelegate>
{
    
    NSMutableArray *data;               // the data source
    
    
    @private
    HEBubbleView *bubbleView;           // The view containing the bubbles
    NSInteger bubbleCount;               // item number for bubble label
}
@end
