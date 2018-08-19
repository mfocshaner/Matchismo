//
//  CardView.h
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 19/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;
- (CGFloat)cornerOffset;
- (void)drawRect:(CGRect)rect;

@end
