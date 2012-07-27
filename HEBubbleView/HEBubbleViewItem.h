//
//  HEBubbleViewItem.h
//  HEBubbleView
//
//  Created by Clemens Hammerl on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HEBubbleViewItem;
@protocol HEBubbleViewItemDelegate <NSObject>

-(void)selectedBubbleItem:(HEBubbleViewItem *)item; 

@end

@interface HEBubbleViewItem : UIView
{

    id<HEBubbleViewItemDelegate> delegate;
    
    UILabel *textLabel;
    
    NSMutableDictionary *userInfo;
    
    @private
    BOOL _selected;
    NSString *reuseIdentifier;
    NSInteger index;
    CGPoint touchBegan;
    CGFloat bubbleTextLabelPadding;
}

@property (nonatomic, assign) id<HEBubbleViewItemDelegate> delegate;
@property (nonatomic, readonly) BOOL _selected;
@property (nonatomic, retain) NSMutableDictionary *userInfo;
@property (nonatomic, readonly) NSString *reuseIdentifier;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat bubbleTextLabelPadding;

-(void)setSelected:(BOOL)selected animated:(BOOL)animated;


-(id)initWithReuseIdentifier:(NSString *)reuseIdentifierIN;
-(void)setBubbleItemIndex:(NSInteger)itemIndex;

-(void)prepareItemForReuse;


@end
