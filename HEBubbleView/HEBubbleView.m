//
//  HEBubbleView.m
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HEBubbleView.h"
#define BUBBLE_ANIMATION_TIME 0.2
@interface HEBubbleView (private)

-(void)renderBubbles;

-(void)showMenuCalloutWthItems:(NSArray *)menuItems forBubbleItem:(HEBubbleViewItem *)item;

-(void)willShowMenuController;
-(void)didHideMenuController;

@end

@implementation HEBubbleView

@synthesize bubbleDataSource;
@synthesize bubbleDelegate;

@synthesize itemPadding;
@synthesize itemHeight;

@synthesize reuseQueue;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
    
        itemHeight = 25.0;
        itemPadding = 20.0;

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
            NSLog(@"found reuse item");
            reuseItem = item;
            break;
            
        }
        
    }
    
    if (reuseItem != nil) {
        [reuseQueue removeObject:reuseItem];
    }
    
    
    return reuseItem;
    
}

-(void)reloadData
{
    [self renderBubbles];
}



-(void)renderBubbles
{
    NSLog(@"rendering bubbles");
    
    
    NSInteger bubbleCount = 0;
    
    if (bubbleDataSource != nil && [bubbleDataSource respondsToSelector:@selector(numberOfItemsInBubbleView:)]) {
        bubbleCount = [bubbleDataSource numberOfItemsInBubbleView:self];
    }
    
    
    
    for (HEBubbleViewItem *item in self.subviews) {
        
        //NSLog(@"CLASS: %@",[HEBubbleViewItem class]);
        
        if ([item isKindOfClass:[HEBubbleViewItem class]]) {
            
            [reuseQueue addObject:item];
            [item removeFromSuperview];
            
        }
        
        
    }
    

    NSLog(@"Bubble count %i",bubbleCount);

    CGFloat nextBubbleX = itemPadding;
    CGFloat nextBubbleY = itemPadding;
    
    NSInteger lineNumber = 1;
    
    for (int i = 0; i < bubbleCount; i++) {
        
        
        
        if (bubbleDataSource != nil && [bubbleDataSource respondsToSelector:@selector(bubbleView:bubbleItemForIndex:)]) {

            
            HEBubbleViewItem *bubble = [bubbleDataSource bubbleView:self bubbleItemForIndex:i];
            
            CGFloat bubbleWidth = [bubble.textLabel.text sizeWithFont:bubble.textLabel.font constrainedToSize:CGSizeMake(self.frame.size.width, itemHeight)].width;
            

            if ((nextBubbleX + bubbleWidth) > self.frame.size.width-itemPadding) {
                lineNumber++;
                
                nextBubbleX = itemPadding;
                nextBubbleY += (itemHeight+itemPadding);
                
            }
            
            CGRect bubbleFrame = CGRectMake(nextBubbleX, nextBubbleY, bubbleWidth, itemHeight);
            
            bubble.frame = bubbleFrame;
            
            [bubble setBubbleItemIndex:i];
            bubble.delegate = self;
           [self addSubview:bubble];
            //[bubble release];
            
             NSLog(@"Bubble %@",bubble);
            
           
            
            nextBubbleX += bubble.frame.size.width + itemPadding;
            

            
        }
        
        
    }
    NSLog(@"Setting content size");
    self.contentSize = CGSizeMake(self.frame.size.width, lineNumber * (itemHeight + itemPadding) + itemPadding);
    NSLog(@"Bubble setup complete");
    
    
   
	NSLog(@"reuse queue %@",reuseQueue);
    
	
    NSLog(@"WTF");
    
    //[self setContentSize:CGSizeMake(self.frame.size.width, (lineNumber+1) * itemHeight )];
    
}



-(void)selectedBubbleItem:(HEBubbleViewItem *)item
{
    NSLog(@"Selected item with index %i",item.index);
    
    
    if ([bubbleDelegate respondsToSelector:@selector(bubbleView:didSelectBubbleItemAtIndex:)]) {
        [bubbleDelegate bubbleView:self didSelectBubbleItemAtIndex:item.index];
    }
    
    if ([bubbleDelegate respondsToSelector:@selector(bubbleView:shouldShowMenuForBubbleItemAtIndex:)]) {
        
        if ([bubbleDelegate bubbleView:self shouldShowMenuForBubbleItemAtIndex:item.index]) {
            
            NSArray *menuItems = nil;
            
            if ([bubbleDelegate respondsToSelector:@selector(bubbleView:menuItemsForBubbleItemAtIndex:)]) {
                
                NSLog(@"creating menu");
                
                menuItems = [bubbleDelegate bubbleView:self menuItemsForBubbleItemAtIndex:item.index];
            }
            
            NSLog(@"Menuitems %@",menuItems);
            
            if (menuItems) {
                [self showMenuCalloutWthItems:menuItems forBubbleItem:item];
            }
            
            
            
        }
        
    }
}


-(BOOL)canBecomeFirstResponder
{
    NSLog(@"ASked for can become first responder");
    return YES;
}


 
-(void)willShowMenuController
{
    
    NSLog(@"will show notification");
    self.scrollEnabled = NO;
}

-(void)didHideMenuController
{
    NSLog(@"Did hide notification");
    self.scrollEnabled = YES;
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
    NSLog(@"Showing menu items");
    
    [self becomeFirstResponder];
    
    menu = [UIMenuController sharedMenuController];
    menu.menuItems = nil;
    menu.menuItems = menuItems;
    NSLog(@"Menuitems %@",menu.menuItems);
    [menu setTargetRect:item.frame inView:self];
    [menu setMenuVisible:YES animated:YES];
    
    
    NSLog(@"Menu should be shown");
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.bubbleDataSource = nil;
    self.bubbleDelegate = nil;
    
    [reuseQueue release];
    
    [super dealloc];
}

@end
