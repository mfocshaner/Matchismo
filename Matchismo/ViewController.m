//
//  ViewController.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 02/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "ViewController.h"
#import "HistoryViewController.h"


@interface ViewController ()


@end


@implementation ViewController

static const int DEFAULT_MODE = 2;
static int gameMode = DEFAULT_MODE;

- (void)viewDidLoad {
  [super viewDidLoad];
  if (!self.gameHistory) {
    self.gameHistory = [[NSMutableAttributedString alloc] init];
  }
  [self updateUI];
}

- (CardMatchingGame *)game{
  if (!_game) {[self resetGame];};
    return _game;
}

- (IBAction)touchStartNewGameButton:(UIButton *)sender {
    [self resetGame];
    self.modeButton.enabled = YES;
    [self updateUI];
}

- (void)resetGame{
  _game = [[CardMatchingGame alloc] initWithCardCount:_cardButtons.count usingDeck:[self createDeck] usingGameMode:gameMode];
  self.resultLabel.text = @"Result: new game";
  [self.gameHistory appendAttributedString:[[NSAttributedString alloc] initWithString:@"New game started\n"]];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]){
    HistoryViewController *destinationHistoryController = (HistoryViewController *)segue.destinationViewController;
    if (!destinationHistoryController.historyString) {
      destinationHistoryController.historyString = [[NSMutableAttributedString alloc] initWithAttributedString:self.gameHistory];
      return;
    }
    destinationHistoryController.historyString = self.gameHistory;
  }
}


@end
