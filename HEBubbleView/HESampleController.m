//
//  HEBubbleViewController.m
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 Clemens Hammerl / Adam Eri. All rights reserved.
//

#import "HESampleController.h"

//////////////////////////////// Private Methods /////////////////////////////
#pragma mark - Private Methods
@interface HESampleController (private)

// Implement all menucontroller item actions in delegate of bubbleview
-(void)deleteSelectedBubble:(id)sender;
-(void)inserLeft:(id)sender;
-(void)insertRight:(id)sender;
-(void)addDummyItem;

@end

@implementation HESampleController

//////////////////////////////// Memory Management /////////////////////////////
#pragma mark - Memory Management

-(void)dealloc
{
    [data release];
    [super dealloc];
}

//////////////////////////////// Initializiation /////////////////////////////
#pragma mark - Initialization

-(id)init
{
    self = [super init];
    
    if (self) {
        
        // initializing the data source
        data = [[NSMutableArray alloc] init];
        
        bubbleCount = 0;
    }
    
    return self;
}

//////////////////////////////// View Lifecycle /////////////////////////////
#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // init bubble view
    bubbleView = [[HEBubbleView alloc] initWithFrame:self.view.frame];
    
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    
    // configure bubble view
    bubbleView.alwaysBounceVertical = YES;
    bubbleView.bubbleDataSource = self;
    bubbleView.bubbleDelegate = self;
    
    bubbleView.selectionStyle = HEBubbleViewSelectionStyleDefault;
    
    [self.view addSubview:bubbleView];
    [bubbleView release];
    
    
    // configure bar buttons
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:bubbleView action:@selector(reloadData)];
    self.navigationItem.rightBarButtonItem = refresh;
    [refresh release];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDummyItem)];
    self.navigationItem.leftBarButtonItem = add;
    [add release];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    bubbleView.frame = self.view.bounds;
    
    // [bubbleView reloadData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [bubbleView removeFromSuperview];
    bubbleView = nil;
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

//////////////////////////////// Add bubble item ///////////////////////////////
#pragma mark - add bubble item

/*
 Add a new item to the bubble view at the end of the list
*/
-(void)addDummyItem
{
    
    bubbleCount++;
    
    NSInteger index = [data count];
    
    if (index < 0) {
        index = 0;
    }
    
    if (index > [data count]) {
        index = [data count];
    }

    // ALWAYS: first add data to your data source, then call addItem on the bubble view
    
    [data insertObject:[NSString stringWithFormat:@"Item %i", bubbleCount] atIndex:index];
    [bubbleView addItemAnimated:YES];

    // data is rerendered automatically by the bubble view
    
}

//////////////////////////////// delete an item ///////////////////////////////
#pragma mark - delete bubble item

-(void)deleteSelectedBubble:(id)sender
{
    NSLog(@"test1 controller %@",[sender class]);
    
    
    [data removeObjectAtIndex:bubbleView.activeBubble.index];
    [bubbleView removeItemAtIndex:bubbleView.activeBubble.index animated:YES];
    //[bubbleView reloadData];
    
}

//////////////////////////////// insert item at index ///////////////////////////////
#pragma mark - add bubble item at index

-(void)inserLeft:(id)sender
{
    bubbleCount++;
    
    NSInteger index = bubbleView.activeBubble.index;
    
    if (index < 0) {
        index = 0;
    }
    
    [data insertObject:[NSString stringWithFormat:@"Item %i", bubbleCount] atIndex:index];
    
    [bubbleView insertItemAtIndex:index animated:YES];
}

////////////////////////////////insert item at index///////////////////////////////


-(void)insertRight:(id)sender
{
    
    bubbleCount++;
    
    NSInteger index = bubbleView.activeBubble.index+1;
    
    if (index >= [data count]) {
        [self addDummyItem];
        return;
    }
    
    [data insertObject:[NSString stringWithFormat:@"Item %i", bubbleCount] atIndex:index];
    
    [bubbleView insertItemAtIndex:index animated:YES];
}


///////////////////////////////////////////////////////////////
#pragma mark - bubble view data source
///////////////////////////////////////////////////////////////

// DataSource

-(NSInteger)numberOfItemsInBubbleView:(HEBubbleView *)bubbleView
{
    
    NSLog(@"Asking for bubble count");
    
    return [data count];
}

-(HEBubbleViewItem *)bubbleView:(HEBubbleView *)bubbleViewIN bubbleItemForIndex:(NSInteger)index
{
    // TODO: implement reuse queue
    
    NSLog(@"Requesting bubbble for index %i",index);
    
    NSString *itemIdentifier = @"bubble";
    
    HEBubbleViewItem *item = [bubbleView dequeueItemUsingReuseIdentifier:itemIdentifier];
    
    if (item == nil) {
        item = [[[HEBubbleViewItem alloc] initWithReuseIdentifier:itemIdentifier] autorelease];
         NSLog(@"Created a new bubble");
    }else {
        NSLog(@"Used a bubble from the queue");
    }
    
    item.textLabel.text = [data objectAtIndex:index];
    
    return item;
}

///////////////////////////////////////////////////////////////
#pragma mark - bubble view delegate
///////////////////////////////////////////////////////////////

// DataSource

// called when a bubble gets selected
-(void)bubbleView:(HEBubbleView *)bubbleView didSelectBubbleItemAtIndex:(NSInteger)index
{
    NSLog(@"selected bubble at index");
}

// returns wheter to show a menu callout or not for a given index
-(BOOL)bubbleView:(HEBubbleView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index
{
    NSLog(@"telling delegate to show menu");
    return YES;
}

/* ////////////////////////////////////////////////////////////////////////////////////////////////////
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 !!!!! Always override canBecomeFirstResponder and return YES, otherwise the menu is not shown !!!!!!
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
* //////////////////////////////////////////////////////////////////////////////////////////////////// */

-(BOOL)canBecomeFirstResponder
{
    NSLog(@"Asking %@ if it can become first responder",[self class]);
    return YES;
}


/*
 Create the menu items you want to show in the callout and return them. Provide selectors
 that are implemented in your bubbleview delegate. override canBecomeFirstResponder and return
 YES, otherwise menu will not be shown
*/

-(NSArray *)bubbleView:(HEBubbleView *)bubbleView menuItemsForBubbleItemAtIndex:(NSInteger)index
{
    
    NSLog(@"Asking %@ for menu items",[self class]);
    
    NSArray *items;
    
    UIMenuItem *item0 = [[UIMenuItem alloc] initWithTitle:@"Delete item" action:@selector(deleteSelectedBubble:)];
    UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"Insert Left" action:@selector(inserLeft:)];
    UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"Insert Right" action:@selector(insertRight:)];
    
    items = [NSArray arrayWithObjects:item1,item0,item2, nil];
    
    [item1 release];
    [item0 release];
    [item2 release];
    
    
    
    return items; 
}

-(void)bubbleView:(HEBubbleView *)bubbleView didHideMenuForBubbleItemAtIndex:(NSInteger)index
{
    NSLog(@"Did hide menu for bubble at index %i",index);
}

@end
