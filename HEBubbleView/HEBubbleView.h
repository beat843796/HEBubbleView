//
//  HEBubbleView.h
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HEBubbleViewItem.h"

@class HEBubbleView;
@protocol HEBubbleViewDataSource <NSObject>

-(NSInteger)numberOfItemsInBubbleView:(HEBubbleView *)bubbleView;
-(HEBubbleViewItem *)bubbleView:(HEBubbleView *)bubbleView bubbleItemForIndex:(NSInteger)index;


@end

@protocol HEBubbleViewDelegate <NSObject>

@optional
-(void)bubbleView:(HEBubbleView *)bubbleView didSelectBubbleItemAtIndex:(NSInteger)index;
-(BOOL)bubbleView:(HEBubbleView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index;
-(NSArray *)bubbleView:(HEBubbleView *)bubbleView menuItemsForBubbleItemAtIndex:(NSInteger)index;
-(void)bubbleView:(HEBubbleView *)bubbleView didHideMenuForButtbleItemAtIndex:(NSInteger)index;

@end

@interface HEBubbleView : UIScrollView <HEBubbleViewItemDelegate>
{
    
    @private
    
    id<HEBubbleViewDelegate> bubbleDelegate;
    id<HEBubbleViewDataSource> bubbleDataSource;
    
    CGFloat itemPadding;
    CGFloat itemHeight;
    
    NSMutableArray *reuseQueue;
    
    UIMenuController *menu;
    
    
   
    HEBubbleViewItem *activeBubble;
}

@property (nonatomic, assign) id<HEBubbleViewDelegate> bubbleDelegate;
@property (nonatomic, assign) id<HEBubbleViewDataSource> bubbleDataSource;

@property (nonatomic, assign) CGFloat itemPadding;
@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, assign) HEBubbleViewItem *activeBubble;
@property (nonatomic, readonly) NSMutableArray *reuseQueue;

-(HEBubbleViewItem *)dequeueItemUsingReuseIdentifier:(NSString *)reuseIdentifier;

-(void)reloadData;

@end
