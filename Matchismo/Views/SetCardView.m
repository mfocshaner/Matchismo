//
//  SetCardView.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 19/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "SetCardView.h"
#import "SetCard.h"

@implementation SetCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSymbol:(NSString *)symbol {
  _symbol = symbol;
  [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading {
  _shading = shading;
  [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color {
  _color = color;
  [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number {
  _number = number;
  [self setNeedsDisplay];
}


- (void)setAttributedFromCard:(Card *)card {
  if (![card isKindOfClass:[SetCard class]]){
    return;
  }
  SetCard *setCard = (SetCard *)card;
  _symbol = setCard.symbol;
  _shading = setCard.shading;
  _color = setCard.color;
  _number = setCard.number;
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  NSDictionary<NSString *, UIColor *> *colorsByName = @{
                                                        @"red": UIColor.redColor,
                                                        @"green": UIColor.greenColor,
                                                        @"purple": UIColor.purpleColor
                                                        };
  [colorsByName[self.color] setStroke];
  for (NSUInteger i = 0; i < _number; i++) {
    CGFloat fraction = (i + 1.0) / (_number + 1.0);
    CGPoint centerPoint = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2,
                                      self.bounds.origin.y + fraction*self.bounds.size.height);
    UIBezierPath *pathToDraw = [self drawShapePathAtPoint:centerPoint];
    [pathToDraw stroke];
    if ([self.shading  isEqualToString:@"striped"]){
      [self drawStripedShadingForPath:pathToDraw];
    } else if ([self.shading  isEqualToString:@"solid"]) {
      [colorsByName[self.color] setFill];
      [pathToDraw fill];
    }
  }
}

- (UIBezierPath *)drawShapePathAtPoint:(CGPoint)point {
  if ([self.symbol isEqualToString:@"squiggle"]){
    return [self drawSquiggleAtPoint:point];
  } else if ([self.symbol isEqualToString:@"diamond"]) {
    return [self drawDiamondAtPoint:point];
  } else if ([self.symbol isEqualToString:@"oval"]) {
    return [self drawOvalAtPoint:point];
  }
  return nil; // should throw exception?
}

#define SQUIGGLE_CURVE_FACTOR 0.5
#define SYMBOL_WIDTH_RATIO 0.7
#define SYMBOL_HEIGHT_RATIO 0.2

- (UIBezierPath *)drawSquiggleAtPoint:(CGPoint)point
{
  CGSize size = CGSizeMake(self.bounds.size.width * SYMBOL_WIDTH_RATIO, self.bounds.size.height * SYMBOL_HEIGHT_RATIO);
  
  UIBezierPath *path = [[UIBezierPath alloc] init];
  [path moveToPoint:CGPointMake(104, 15)];
  [path addCurveToPoint:CGPointMake(63, 54) controlPoint1:CGPointMake(112.4, 36.9) controlPoint2:CGPointMake(89.7, 60.8)];
  [path addCurveToPoint:CGPointMake(27, 53) controlPoint1:CGPointMake(52.3, 51.3) controlPoint2:CGPointMake(42.2, 42)];
  [path addCurveToPoint:CGPointMake(5, 40) controlPoint1:CGPointMake(9.6, 65.6) controlPoint2:CGPointMake(5.4, 58.3)];
  [path addCurveToPoint:CGPointMake(36, 12) controlPoint1:CGPointMake(4.6, 22) controlPoint2:CGPointMake(19.1, 9.7)];
  [path addCurveToPoint:CGPointMake(89, 14) controlPoint1:CGPointMake(59.2, 15.2) controlPoint2:CGPointMake(61.9, 31.5)];
  [path addCurveToPoint:CGPointMake(104, 15) controlPoint1:CGPointMake(95.3, 10) controlPoint2:CGPointMake(100.9, 6.9)];
  
  [path applyTransform:CGAffineTransformMakeScale(0.9524*size.width/100, 0.9524*size.height/50)];
  [path applyTransform:CGAffineTransformMakeTranslation(point.x - size.width/2 - 3 * size.width /100, point.y - size.height/2 - 8 * size.height/50)];
  
  return path;
}

- (UIBezierPath *)drawDiamondAtPoint:(CGPoint)point
{
  CGSize size = CGSizeMake(self.bounds.size.width * SYMBOL_WIDTH_RATIO, self.bounds.size.height * SYMBOL_HEIGHT_RATIO);
  
  UIBezierPath *path = [[UIBezierPath alloc] init];
  [path moveToPoint:CGPointMake(15, 30)];
  [path addLineToPoint:CGPointMake(55, 60)];
  [path addLineToPoint:CGPointMake(95, 30)];
  [path addLineToPoint:CGPointMake(55, 0)];
  [path addLineToPoint:CGPointMake(15, 30)];
  
  
  [path applyTransform:CGAffineTransformMakeScale(0.9524*size.width/100, 0.9524*size.height/50)];
  [path applyTransform:CGAffineTransformMakeTranslation(point.x - size.width/2 - 3 * size.width /100, point.y - size.height/2 - 8 * size.height/50)];
  
  return path;
}

- (UIBezierPath *)drawOvalAtPoint:(CGPoint)point
{
  CGSize size = CGSizeMake(self.bounds.size.width * SYMBOL_WIDTH_RATIO, self.bounds.size.height * SYMBOL_HEIGHT_RATIO);
  
  
  UIBezierPath *path = [[UIBezierPath alloc] init];
  path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x - (size.width/2), point.y - (size.height/2), size.width, size.height)];
  
  return path;
}

#define DISTANCE_BETWEEN_STRIPES 4


-(void)drawStripedShadingForPath:(UIBezierPath *)pathOfSymbol
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  CGRect bounds = [pathOfSymbol bounds];
  UIBezierPath *path = [[UIBezierPath alloc] init];
  
  for (int i = 0; i < bounds.size.width; i += DISTANCE_BETWEEN_STRIPES)
  {
    [path moveToPoint:CGPointMake(bounds.origin.x + i, bounds.origin.y)];
    [path addLineToPoint:CGPointMake(bounds.origin.x + i, bounds.origin.y + bounds.size.height)];
  }
  
  [pathOfSymbol addClip];
  
  [path stroke];
  
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

@end
