//
//  CardView.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 19/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "CardView.h"

@implementation CardView


- (void)setAttributedFromCard:(Card *)card {
  return; // abstract!
}

- (CGFloat)cornerScaleFactor {
  return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius {
  return CORNER_RADIUS * [self cornerScaleFactor];
}

- (CGFloat)cornerOffset {
  return [self cornerRadius] / 3.0;
}

@synthesize strokeColor = _strokeColor;

#define BUFFER_BETWEEN_CARDS 3
- (void)drawRect:(CGRect)rect {
  self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width - BUFFER_BETWEEN_CARDS,
      self.bounds.size.height - BUFFER_BETWEEN_CARDS);
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
  
  [roundedRect addClip];
  
  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);
  
  [self.strokeColor setStroke];
  [roundedRect stroke];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
  _strokeColor = strokeColor;
  [self setNeedsDisplay];
}

- (UIColor *)strokeColor {
  if (!_strokeColor) {
    _strokeColor = [UIColor blackColor];
  }
  return _strokeColor;
}

#pragma mark - Initialization

- (void)viewDidLoad {
  [self setup];
}

- (void)setup{
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
  self.strokeColor = [UIColor blackColor];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

@end
