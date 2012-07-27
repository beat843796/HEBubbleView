//
//  HEBubbleView.m
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HEBubbleView.h"
#define BUBBLE_ANIMATION_TIME 0.4
#define BUBBLE_FADE_TIME 0.2
@interface HEBubbleView (private)

-(void)renderBubblesAnimated:(BOOL)animated;
-(void)renderBubblesFromIndex:(NSInteger)start toIndex:(NSInteger)end animated:(BOOL)animated;

-(void)showMenuCalloutWthItems:(NSArray *)menuItems forBubbleItem:(HEBubbleViewItem *)item;

-(void)willShowMenuController;
-(void)didHideMenuController;
-(void)fadeInBubble:(HEBubbleViewItem *)item;
-(void)fadeOutBubble:(HEBubbleViewItem *)item;
-(void)removeItem:(HEBubbleViewItem *)item animated:(BOOL)animated;

@end

@implementation HEBubbleView

@synthesize bubbleDataSource;
@synthesize bubbleDelegate;

@synthesize itemPadding;
@synthesize itemHeight;

@synthesize reuseQueue;
@synthesize activeBubble;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
    
        itemHeight = 20.0;
        itemPadding = 10;

        items = [[NSMutableArray alloc] init];
        reuseQueue = [[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowMenuController) name:UIMenuControllerWillShowMenuNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideMenuController) name:UIMenuControllerDidHideMenuNotification object:nil];
        
    }
    
    return  self;
}



-(HEBubbleViewItem *)dequeueItemUsingReuseIdentifier:(NSString *)reuseIdentifier
{
    
    HEBubbleViewItem *reuseItem = nil;
    
    for (HEBubbleViewItem *item in reuseQueue) {
        
        if ([item.reuseIdentifier isEqualToString:reuseIdentifier]) {

            reuseItem = [item retain];
            break;
            
        }
        
    }
    
    if (reuseItem != nil) {
        [reuseQueue removeObject:reuseItem]; 
    }
    
    
    [reuseItem prepareItemForReuse];
    
    return [reuseItem autorelease];
    
}

-(void)reloadData
{
    NSInteger bubbleCount = 0;
    
    if (bubbleDataSource != nil && [bubbleDataSource respondsToSelector:@selector(numberOfItemsInBubbleView:)]) {
        bubbleCount = [bubbleDataSource numberOfItemsInBubbleView:self];
    }
    
    
    for (HEBubbleViewItem *oldItem in items) {
        
        [reuseQueue addObject:oldItem];
        [oldItem removeFromSuperview];
        
    }
    
    [items removeAllObjects];
    
    
    for (int i = 0; i < bubbleCount; i++) {
        
        
        if (bubbleDataSource != nil && [bubbleDataSource respondsToSelector:@selector(bubbleView:bubbleItemForIndex:)]) {
            HEBubbleViewItem *bubble = [bubbleDataSource bubbleView:self bubbleItemForIndex:i];
            
            [items addObject:bubble];
            [bubble setBubbleItemIndex:i];
            bubble.delegate = self;
            bubble.frame = CGRectZero;
            [self addSubview:bubble];
        }
        
    }
    
    
    [self renderBubblesAnimated:NO];
}

-(void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    
    if (index < 0 || index >= [items count]) {
        NSLog(@"Remove item:- Invalid item index.");
        return;
    }
    
    HEBubbleViewItem *item = [items objectAtIndex:index];
    

    
    
    [reuseQueue addObject:[items objectAtIndex:index]];
    [items removeObject:item];
    
    
    [self removeItem:item animated:animated];
        
   
    
}



-(void)addItemAnimated:(BOOL)animated
{
    [self insertItemAtIndex:[items count] animated:animated];
}

-(void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    
    
    if (index < 0) {
        index = 0;
    }
    
    if (index > [items count]) {
        index = [items count];
        
    }
    
    
    
    if (bubbleDataSource != nil && [bubbleDataSource respondsToSelector:@selector(bubbleView:bubbleItemForIndex:)]) {
        HEBubbleViewItem *bubble = [bubbleDataSource bubbleView:self bubbleItemForIndex:index];
        
        

        [items insertObject:bubble atIndex:index];
        [bubble setBubbleItemIndex:[items indexOfObject:bubble]];

        
        
        bubble.delegate = self;
        bubble.frame = CGRectZero;
        [self addSubview:bubble];
        
        
        
        
        bubble.alpha = 0.0;
        
        
        
        for (int i = 0; i < [items count]; i++) {
            HEBubbleViewItem *item = [items objectAtIndex:i];
            item.index = i;
        }
         

        
        
        if (animated) {
            
            if ([items lastObject] == bubble) {

                [self renderBubblesFromIndex:0 toIndex:[items count] animated:NO];
                [self fadeInBubble:bubble];
            }else {

                [self renderBubblesFromIndex:0 toIndex:[items count] animated:animated];
                [self performSelector:@selector(fadeInBubble:) withObject:bubble afterDelay:BUBBLE_ANIMATION_TIME+BUBBLE_FADE_TIME];
            }
            
            
            
        }else {
            [self renderBubblesFromIndex:0 toIndex:[items count] animated:animated];
            bubble.alpha = 1.0;
            //[self renderBubblesAnimated:animated];
        }
        
        
        
    }
    
    
}

-(void)fadeInBubble:(HEBubbleViewItem *)item
{
    [UIView beginAnimations:@"bubbleFadeIn" context:@"bubbleFade"];
    item.alpha = 1.0;
    [UIView commitAnimations];
}

-(void)fadeOutBubble:(HEBubbleViewItem *)item
{
    
    [UIView beginAnimations:@"bubbleFadeOut" context:@"bubbleFade"];
    [UIView setAnimationDuration:BUBBLE_ANIMATION_TIME];
    item.alpha = 0.0;
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeItem:animated:) withObject:item afterDelay:BUBBLE_ANIMATION_TIME+BUBBLE_FADE_TIME];
    
}

-(void)removeItem:(HEBubbleViewItem *)item animated:(BOOL)animated
{
    
    NSInteger index = 0;
    
    
    [item removeFromSuperview];
    
    
    
    
    for (HEBubbleViewItem *bubble in items) {
     
        bubble.index = index;
        
        index++;
        
    }
    
    
    
    [self renderBubblesAnimated:animated];
}

-(void)renderBubblesFromIndex:(NSInteger)start toIndex:(NSInteger)end animated:(BOOL)animated
{

    
    CGFloat nextBubbleX = itemPadding;
    CGFloat nextBubbleY = itemPadding;
    
    NSInteger lineNumber = 1;
    
    
    for (int i = start; i < end; i++) {
        
    
    
    //for (HEBubbleViewItem *bubble in items) {
        
        HEBubbleViewItem *bubble = [items objectAtIndex:i];
        [bubble setSelected:NO animated:animated];
        
        CGFloat bubbleWidth = [bubble.textLabel.text sizeWithFont:bubble.textLabel.font constrainedToSize:CGSizeMake(self.frame.size.width, itemHeight)].width+2*bubble.bubbleTextLabelPadding;
        
        
        if ((nextBubbleX + bubbleWidth) > self.frame.size.width-itemPadding) {
            lineNumber++;
            
            nextBubbleX = itemPadding;
            nextBubbleY += (itemHeight+itemPadding);
            
        }
        
        CGRect bubbleFrame = CGRectMake(nextBubbleX, nextBubbleY, bubbleWidth, itemHeight);
        
        
        if (animated) {
            [UIView beginAnimations:@"bubbleRendering" context:@"bubbleItems"];
            [UIView setAnimationDuration:BUBBLE_ANIMATION_TIME];
            bubble.frame = bubbleFrame;
            
            [UIView commitAnimations];
        }else {
        
            bubble.frame = bubbleFrame;
        
        }
        
    
        
        
        nextBubbleX += bubble.frame.size.width + itemPadding;
        
        
        
        
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, lineNumber * (itemHeight + itemPadding) + itemPadding);
    

}



-(void)renderBubblesAnimated:(BOOL)animated
{

    [self renderBubblesFromIndex:0 toIndex:[items count] animated:animated];
    
}



-(void)selectedBubbleItem:(HEBubbleViewItem *)item
{

    
    if (item == activeBubble) {
        return;
    }
    
    
    [item setSelected:YES animated:YES];
    
    if ([bubbleDelegate respondsToSelector:@selector(bubbleView:didSelectBubbleItemAtIndex:)]) {
        [bubbleDelegate bubbleView:self didSelectBubbleItemAtIndex:item.index];
    }
    
    if ([bubbleDelegate respondsToSelector:@selector(bubbleView:shouldShowMenuForBubbleItemAtIndex:)]) {
        
        if ([bubbleDelegate bubbleView:self shouldShowMenuForBubbleItemAtIndex:item.index]) {
            
            NSArray *menuItems = nil;
            
            if ([bubbleDelegate respondsToSelector:@selector(bubbleView:menuItemsForBubbleItemAtIndex:)]) {
                

                
                menuItems = [bubbleDelegate bubbleView:self menuItemsForBubbleItemAtIndex:item.index];
            }
            

            
            if (menuItems) {
                [self showMenuCalloutWthItems:menuItems forBubbleItem:item];
            }
            
            
            
        }
        
    }
}


-(BOOL)canBecomeFirstResponder
{

    return YES;
}


 
-(void)willShowMenuController
{
    

    self.userInteractionEnabled = NO;
}

-(void)didHideMenuController
{

    self.userInteractionEnabled = YES;
    
    [activeBubble setSelected:NO animated:YES];
    
    if ([bubbleDelegate respondsToSelector:@selector(bubbleView:didHideMenuForButtbleItemAtIndex:)]) {
        [bubbleDelegate bubbleView:self didHideMenuForButtbleItemAtIndex:activeBubble.index];
    }
    
    activeBubble = nil;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    if ([menu isMenuVisible]) {
        [menu setMenuVisible:NO animated:YES];
    }
    
    //[self resignFirstResponder];
    
}

-(void)showMenuCalloutWthItems:(NSArray *)menuItems forBubbleItem:(HEBubbleViewItem *)item
{

    
    [self becomeFirstResponder];
    
    activeBubble = item;
    
    menu = [UIMenuController sharedMenuController];
    menu.menuItems = nil;
    menu.menuItems = menuItems;

    [menu setTargetRect:item.frame inView:self];
    [menu setMenuVisible:YES animated:YES];
    

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.bubbleDataSource = nil;
    self.bubbleDelegate = nil;
    
    [reuseQueue release];
    [items release];
    
    [super dealloc];
}

@end
