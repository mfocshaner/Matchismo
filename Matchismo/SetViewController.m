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
    [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
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

- (void)setCardBorder:(UIButton *)cardButton ifChosen:(BOOL)chosen {
  if (chosen){
    cardButton.layer.borderWidth = 2.0f;
    cardButton.layer.borderColor = [UIColor blueColor].CGColor;
    return;
  }
  cardButton.layer.borderWidth=0;
  
}
//
//- (SetGame *)setGame {
//  if (!_setGame) {[self resetGame];};
//  return _setGame;
//}

- (void)resetGame {
  self.game = [[SetGame alloc] initWithCardCount: self.cardButtons.count usingDeck:[self createDeck] usingGameMode:gameMode];
  self.resultLabel.text = [NSString stringWithFormat:@"Result: new game"];
}

@end
