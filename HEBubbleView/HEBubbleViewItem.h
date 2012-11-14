//
//  HEBubbleViewItem.h
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 Clemens Hammerl / Adam Eri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HEBubbleViewItem;
@protocol HEBubbleViewItemDelegate <NSObject>

-(void)selectedBubbleItem:(HEBubbleViewItem *)item; 


@end

@interface HEBubbleViewItem : UIView
{

    id<HEBubbleViewItemDelegate> __weak delegate;          // Bubble Item delegate
    UILabel *textLabel;                             // textlabel that displays the bubble string
    NSMutableDictionary *userInfo;                  // dictionary for additional data
    
    UIColor *unselectedBGColor;
    UIColor *selectedBGColor;
    
    UIColor *unselectedBorderColor;
    UIColor *selectedBorderColor;
    
    UIColor *unselectedTextColor;
    UIColor *selectedTextColor;
    
    BOOL highlightTouches;
    
//////////// PRIVATE STUFF /////////////////
    
    @private
    
    BOOL isSelected;
    NSString *reuseIdentifier;
    NSInteger index;
    CGPoint touchBegan;
    CGFloat bubbleTextLabelPadding;
}

@property (nonatomic, weak) id<HEBubbleViewItemDelegate> delegate;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, strong) NSMutableDictionary *userInfo;
@property (nonatomic, assign) BOOL highlightTouches;

@property (nonatomic, strong) UIColor *unselectedBGColor;
@property (nonatomic, strong) UIColor *selectedBGColor;

@property (nonatomic, strong) UIColor *unselectedBorderColor;
@property (nonatomic, strong) UIColor *selectedBorderColor;

@property (nonatomic, strong) UIColor *unselectedTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@property (nonatomic, readonly) BOOL isSelected;
@property (nonatomic, readonly) NSString *reuseIdentifier;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat bubbleTextLabelPadding;

-(void)setSelected:(BOOL)selected animated:(BOOL)animated;

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifierIN;
-(void)setBubbleItemIndex:(NSInteger)itemIndex;

-(void)prepareItemForReuse;


@end
