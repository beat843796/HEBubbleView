//
//  HEBubbleView.h
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 Clemens Hammerl / Adam Eri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HEBubbleViewItem.h"

//////////////////// Bubble View DataSource /////////////////////

@class HEBubbleView;
@protocol HEBubbleViewDataSource <NSObject>

-(NSInteger)numberOfItemsInBubbleView:(HEBubbleView *)bubbleView;
-(HEBubbleViewItem *)bubbleView:(HEBubbleView *)bubbleView bubbleItemForIndex:(NSInteger)index;


@end

//////////////////// Bubble View Delegate /////////////////////

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
    
    id<HEBubbleViewDelegate> bubbleDelegate;            // bubble view delegate
    id<HEBubbleViewDataSource> bubbleDataSource;        // bubble view datasource
    
    CGFloat itemPadding;                                // space between items (vertical)
    CGFloat itemHeight;                                 // default item heigth
    
    NSMutableArray *reuseQueue;                         // reuse queue holds unused items
    NSMutableArray *items;                              // hold the HEBubbleViewItems that are visible
    
    UIMenuController *menu;                             // Menu Controller
   
    HEBubbleViewItem *activeBubble;                     // pointer to the currently selected bubble
    
}

@property (nonatomic, assign) id<HEBubbleViewDelegate> bubbleDelegate;
@property (nonatomic, assign) id<HEBubbleViewDataSource> bubbleDataSource;

@property (nonatomic, assign) CGFloat itemPadding;
@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, assign) HEBubbleViewItem *activeBubble;
@property (nonatomic, readonly) NSMutableArray *reuseQueue;

/*
 Returns an unused item from the queue if there is any
 */
-(HEBubbleViewItem *)dequeueItemUsingReuseIdentifier:(NSString *)reuseIdentifier;

/*
 
 Reloads all data. Removes all old bubbleItems from items, asks the delegate
 for new bubbleItems and renders them to screen
 
 */
-(void)reloadData;

// Removes an item from a given index and renders the view. Remove data in datasource before
// calling this method
-(void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;

// Adds an item at the end of the list. Remove data in datasource before
// calling this method
-(void)addItemAnimated:(BOOL)animated;

// Adds an item from a given index and renders the view. Remove data in datasource before
// calling this method
-(void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
