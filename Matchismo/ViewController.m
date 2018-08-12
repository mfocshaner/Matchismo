//
//  ViewController.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 02/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "ViewController.h" 


@interface ViewController ()


@end


@implementation ViewController

static const int DEFAULT_MODE = 2;
static int gameMode = DEFAULT_MODE;


- (CardMatchingGame *)game{
  if (!_game) {[self resetGame];};
    return _game;
}

- (IBAction)touchStartNewGameButton:(UIButton *)sender {
    [self resetGame];
    self.modeButton.enabled = YES;
    // NSLog(@"%@", [NSString stringWithFormat:@"Mode: %d", gameMode]);
    [self updateUI];
}

- (IBAction)modeChange:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0){
        gameMode = DEFAULT_MODE;
        NSLog(@"%@", [NSString stringWithFormat:@"Mode: %d", gameMode]);
    }
    else {
        gameMode = 3;
        NSLog(@"%@", [NSString stringWithFormat:@"Mode: %d", gameMode]);
    }
    [self resetGame];
}

- (void)resetGame{
  _game = [[CardMatchingGame alloc] initWithCardCount:_cardButtons.count usingDeck:[self createDeck] usingGameMode:gameMode];
  self.resultLabel.text = [NSString stringWithFormat:@"Result: new game"];
}

- (IBAction)touchCardButton:(UIButton *)sender {
  NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
  NSString *outputString = [self.game chooseCardAtIndex:chosenButtonIndex];
  self.resultLabel.text = [NSString stringWithFormat:@"Result: %@", outputString];
  self.modeButton.enabled = NO;
  [self updateUI];
}

- (void)updateUI{
    for (UIButton *cardButton in self.cardButtons){
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scorelabel.text = [NSString stringWithFormat:@"Score: %lli",
                                (long long)self.game.score];
    }
}

- (NSString *)titleForCard:(Card *)card{
    return card.isChosen? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}


- (Deck *)createDeck{
  return nil; //abstract!
}


@end
