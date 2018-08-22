//
//  CardView.h
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 19/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardView : UIView

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

@property (strong, nonatomic) UIColor *strokeColor;
@property (nonatomic, getter=isChosen) BOOL chosen;

@property (nonatomic, strong) UIAttachmentBehavior *attachment;

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;
- (CGFloat)cornerOffset;

- (void)drawRect:(CGRect)rect;
- (void)setAttributedFromCard:(Card *)card;
- (void)setStrokeColor:(UIColor *)strokeColor;
- (void)setChosen:(BOOL)chosen;

@end
