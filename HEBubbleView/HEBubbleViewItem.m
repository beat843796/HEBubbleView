//
//  HEBubbleViewItem.m
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HEBubbleViewItem.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_BG_COLOR UIColorFromRGB(222,231,248,255)
#define DEFAULT_SELECTED_BG_COLOR UIColorFromRGB(89,137,236,255)

#define DEFAULT_TEXT_COLOR UIColorFromRGB(0,0,0,255)
#define DEFAULT_SELECTED_TEXT_COLOR UIColorFromRGB(255,255,255,255)

#define DEFAUL_BORDER_COLOR UIColorFromRGB(109,149,224,255)
#define DEFAULT_SELECTED_BORDER_COLOR UIColorFromRGB(109,149,224,255)

#define ITEM_TEXTLABELPADDING_LEFT_AND_RIGHT 10.0;

UIColor* UIColorFromRGB(NSInteger red, NSInteger green, NSInteger blue, NSInteger alpha) {
    return [UIColor colorWithRed:((float)red)/255.0
                           green:((float)green)/255.0
                            blue:((float)blue)/255.0
                           alpha:((float)alpha)/255.0];
}

@interface HEBubbleViewItem (private)

-(void)prepareItemForReuse;

@end

@implementation HEBubbleViewItem

@synthesize delegate;

@synthesize _selected = isSelected;
//@synthesize _highlighted = isHighlighted;
@synthesize reuseIdentifier;
@synthesize textLabel;
@synthesize index;
@synthesize bubbleTextLabelPadding;

-(void)dealloc
{
    [reuseIdentifier release];
    reuseIdentifier = nil;
    delegate = nil;
    
    [super dealloc];
}

/*
-(BOOL)isItemVisibleInFrame:(CGRect)frame
{
    return (BOOL)CGRectIntersectsRect(frame, self.frame);
}
*/

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
        
        NSLog(@"HEBUbbleView: called initWithReuseIdentifier and set reuseIdentifier to %@",reuseIdentifierIN);
        
        reuseIdentifier = [reuseIdentifierIN retain];
        
        textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        
        self.textLabel.backgroundColor = [UIColor clearColor]; 
        
        self.backgroundColor = DEFAULT_BG_COLOR;
        
        [self addSubview:textLabel];
        [textLabel release];
        
        self.bubbleTextLabelPadding = ITEM_TEXTLABELPADDING_LEFT_AND_RIGHT;

        
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

    self.textLabel.frame = CGRectMake(bubbleTextLabelPadding, self.bounds.origin.y, self.bounds.size.width-2*bubbleTextLabelPadding, self.bounds.size.height);

    NSLog(@"Layout subviews");
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.height/2;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [DEFAUL_BORDER_COLOR CGColor];
    
    
    [super layoutSubviews];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        
        self.backgroundColor = DEFAULT_SELECTED_BG_COLOR;
        self.textLabel.textColor = DEFAULT_SELECTED_TEXT_COLOR;
        
    }else {
        self.backgroundColor = DEFAULT_BG_COLOR;
        self.textLabel.textColor = DEFAULT_TEXT_COLOR;
    }
    
    isSelected = selected;
}

-(void)prepareItemForReuse
{
    self.textLabel.text = nil;
    [self setSelected:NO animated:NO];
    self.index = 0;
    self.delegate = nil;
    isSelected = NO;
    
}

@end
