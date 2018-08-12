//
//  SetViewController.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 09/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "SetViewController.h"
#import "SetDeck.h"
#import "SetGame.h"
#import "SetCard.h"

@interface SetViewController ()

@end

@implementation SetViewController

static int gameMode = 0;

- (Deck *)createDeck {
  return [[SetDeck alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self updateUI];
}

- (void)updateUI {
  for (UIButton *cardButton in self.cardButtons){
    NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    NSAttributedString *title = card.contents;
    [cardButton setAttributedTitle:title forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    [self setCardBorder:cardButton ifChosen:card.isChosen];
    self.scorelabel.text = [NSString stringWithFormat:@"Score: %lli",
                            (long long)self.game.score];
  }
}

// TODO should be attributed string
- (NSString *)titleForCard:(Card *)card {
  return card.contents;
}

- (NSAttributedString *)attributedTitleForCard:(SetCard *)card {
  NSDictionary<NSString *, UIColor *> *colorsByName = @{
                                 @"red": UIColor.redColor,
                                 @"green": UIColor.greenColor,
                                 @"purple": UIColor.purpleColor
                                 };
  NSDictionary<NSString *,NSNumber *> *alphaForShading = @{
                                 @"solid": @1.0f,
                                 @"striped": @0.5f,
                                 @"open": @0.0f
                                 };
  
  UIColor * colorAttribute = colorsByName[card.color];
  CGFloat alphaValue = alphaForShading[card.shading].floatValue;
  UIColor * colorAttributeWithAlpha = [colorAttribute colorWithAlphaComponent:alphaValue];
  
  NSNumber* strokeWidth = @-0.1f;
  if ([card.shading  isEqual: @"open"]){
    strokeWidth = @-6.0f;
  }
  
  
  NSDictionary <NSAttributedStringKey, id> *attributes = @{NSForegroundColorAttributeName:colorAttributeWithAlpha,                                                          NSStrokeWidthAttributeName:strokeWidth,                                                           NSStrokeColorAttributeName:colorAttribute,                                                                                                          };
  
  NSAttributedString * string = [[NSAttributedString alloc] initWithString:card.contents attributes:attributes];
  
  return string;
}

- (IBAction)touchCardButton:(UIButton *)sender {
  NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
  NSAttributedString *outputString = [self.game chooseCardAtIndex:chosenButtonIndex];
  self.resultLabel.attributedText = outputString;
//  [NSString stringWithFormat:@"Result: %@", outputString];
  
  self.modeButton.enabled = NO;
  [self updateUI];
}


- (void)setCardBorder:(UIButton *)cardButton ifChosen:(BOOL)chosen {
  if (chosen){
    cardButton.layer.borderWidth = 2.0f;
    cardButton.layer.borderColor = [UIColor blueColor].CGColor;
    cardButton.layer.cornerRadius = 7.0f;
    return;
  }
  cardButton.layer.borderWidth=0;
  
}


- (void)resetGame {
  self.game = [[SetGame alloc] initWithCardCount: self.cardButtons.count usingDeck:[self createDeck] usingGameMode:gameMode];
  self.resultLabel.text = [NSString stringWithFormat:@"Result: new game"];
}

@end
