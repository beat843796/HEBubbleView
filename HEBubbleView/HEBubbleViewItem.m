//
//  HEBubbleViewItem.m
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HEBubbleViewItem.h"
#import <QuartzCore/QuartzCore.h>

#define GRADIENT_START_COLOR [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
#define GRADIENT_END_COLOR [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0]


@implementation HEBubbleViewItem

@synthesize delegate;

@synthesize _selected = isSelected;
@synthesize _highlighted = isHighlighted;
@synthesize reuseIdentifier;
@synthesize textLabel;
@synthesize index;
-(void)dealloc
{
    [reuseIdentifier release];
    reuseIdentifier = nil;
    
    [super dealloc];
}

-(BOOL)isItemVisibleInFrame:(CGRect)frame
{
    
    //NSLog(@"SELF: %@ SUPER: %@",NSStringFromCGRect(self.frame),NSStringFromCGRect(frame));
    
    return (BOOL)CGRectIntersectsRect(frame, self.frame);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    touchBegan = touchPoint;
    
    [self setSelected:YES animated:YES];
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.bounds, touchPoint)) {
        [self touchesCancelled:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        [self touchesCancelled:touches withEvent:event];
        
        NSLog(@"Click");
        
        if ([delegate respondsToSelector:@selector(selectedBubbleItem:)]) {
            [delegate selectedBubbleItem:self];
        }
        
        [self setSelected:YES animated:YES];
        
        return;
    }
    
    [self setSelected:NO animated:YES];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setSelected:NO animated:YES];
}

-(void)setBubbleItemIndex:(NSInteger)itemIndex
{
    index = itemIndex;
}



-(id)initWithReuseIdentifier:(NSString *)reuseIdentifierIN;
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        reuseIdentifier = [reuseIdentifierIN retain];
        
        textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        
        self.textLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:textLabel];
        [textLabel release];

        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    return [self initWithReuseIdentifier:nil];
}

-(id)init
{
    return [self initWithReuseIdentifier:nil];
}

-(void)layoutSubviews
{
    
    
    NSLog(@"laying out subvuews");
    
    self.textLabel.frame = self.bounds;
    
    
    
    [super layoutSubviews];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        
        self.textLabel.backgroundColor = [UIColor blueColor];
        self.textLabel.textColor = [UIColor whiteColor];
        
    }else {
        self.textLabel.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor blackColor];
    }
    
    isSelected = selected;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
    if (highlighted) {

        
    }else {
        
    }
    
    isHighlighted = highlighted;
    
}

@end
