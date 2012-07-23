//
//  HEBubbleViewController.m
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HEBubbleViewController.h"

@interface HEBubbleViewController ()

-(void)test1:(id)sender;
-(void)test2:(id)sender;
-(void)addDummyItem;
@end

@implementation HEBubbleViewController

-(void)dealloc
{
    [data release];
    
    [super dealloc];
}

-(id)init
{
    self = [super init];
    
    if (self) {
        
        data = [[NSMutableArray alloc] init];
        
        //[self addDummyItem];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor blueColor];
    
    
    
    bubbleView = [[HEBubbleView alloc] initWithFrame:self.view.frame];

    bubbleView.alwaysBounceVertical = YES;
    
    [self.view addSubview:bubbleView];
    
    bubbleView.bubbleDataSource = self;
    bubbleView.bubbleDelegate = self;
    
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:bubbleView action:@selector(reloadData)];
    self.navigationItem.rightBarButtonItem = refresh;
    [refresh release];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDummyItem)];
    self.navigationItem.leftBarButtonItem = add;
    [add release];
    
    [bubbleView release];
    
}


-(void)addDummyItem
{
    
    NSInteger number = [data count] + 1;
    
    
    [data addObject:[NSString stringWithFormat:@"Item %i", number]];
    [bubbleView reloadData];
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


///////////////////////////////////////////////////////////////
#pragma mark - bubble view delegate and data source
///////////////////////////////////////////////////////////////

// DataSource

-(NSInteger)numberOfItemsInBubbleView:(HEBubbleView *)bubbleView
{
    
    NSLog(@"Asking for bubble count");
    
    return [data count];
}

-(HEBubbleViewItem *)bubbleView:(HEBubbleView *)bubbleView bubbleItemForIndex:(NSInteger)index
{
    // TODO: implement reuse queue
    
    NSLog(@"Requesting bubbble");
    
    NSString *itemIdentifier = @"bubble";
    
    HEBubbleViewItem *item = [bubbleView dequeueItemUsingReuseIdentifier:itemIdentifier];
    
    if (item == nil) {
        item = [[[HEBubbleViewItem alloc] initWithReuseIdentifier:itemIdentifier] autorelease];
    }
    
    item.textLabel.text = [data objectAtIndex:index];
    
    return item;
}

// Delegate

-(void)bubbleView:(HEBubbleView *)bubbleView didSelectBubbleItemAtIndex:(NSInteger)index
{
   
    NSLog(@"selected bubble at index");
}

-(BOOL)bubbleView:(HEBubbleView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index
{
    NSLog(@"telling delegate to show menu");
    
    return YES;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)test1:(id)sender
{
    NSLog(@"test1 controller %@",[sender class]);
    
    
    [data removeObjectAtIndex:bubbleView.activeBubble.index];
    [bubbleView reloadData];
    
}

-(void)test2:(id)sender
{
    NSLog(@"test2 controller %@",[sender class]);
    
}

-(NSArray *)bubbleView:(HEBubbleView *)bubbleView menuItemsForBubbleItemAtIndex:(NSInteger)index
{
    
    NSArray *items;
    
    UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"Delete item" action:@selector(test1:)];
    
    
    items = [NSArray arrayWithObjects:item1, nil];
    
    [item1 release];
    
    
    
    return items; 
}

-(void)bubbleView:(HEBubbleView *)bubbleView didHideMenuForButtbleItemAtIndex:(NSInteger)index
{
    NSLog(@"Did hide menu for bubble at index %i",index);
}

@end
