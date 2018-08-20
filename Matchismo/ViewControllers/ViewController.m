//
//  ViewController.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 02/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "ViewController.h"
#import "CardView.h"

@interface ViewController ()




@end


@implementation ViewController

static const int DEFAULT_MODE = 2;
static int gameMode = DEFAULT_MODE;
static const int DEFAULT_INIT_CARDS = 30;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initGame];
  [self setGridBounds];
  [self createCardViews];
}

- (void)createCardViews {
  for (NSInteger i = 0; i < self.game.cardCount; i++) {
    CardView *createdCardView =
    [[CardView alloc] initWithFrame:[self.grid frameOfCellAtIndex:i]];
    [createdCardView setAttributedFromCard:[self.game cardAtIndex:i]];
    [createdCardView setBackgroundColor:[UIColor clearColor]];
    [createdCardView setUserInteractionEnabled:YES];
    [self.backgroundView addSubview:createdCardView];
  }
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self setGridBounds];
  NSUInteger i = 0;
  for (UIView *subview in self.backgroundView.subviews) {
    subview.center = [self.grid centerOfCellAtIndex:i++];
  }
}

#define DEFAULT_INITIAL_CARD_COUNT 30
- (void)awakeFromNib {
  [super awakeFromNib];
  _game = [[CardMatchingGame alloc] initWithCardCount:DEFAULT_INIT_CARDS usingDeck:[self createDeck] usingGameMode:gameMode];
  _grid = [[Grid alloc] init];
  _cardViewsToRemove = [[NSMutableArray alloc] init];
}

- (CardMatchingGame *)game{
  if (!_game) {[self resetGame];};
    return _game;
}

- (IBAction)touchStartNewGameButton:(UIButton *)sender {
    [self resetGame];
}

- (void)initGame {
  _game = [[CardMatchingGame alloc] initWithCardCount:DEFAULT_INIT_CARDS usingDeck:[self createDeck] usingGameMode:gameMode];
}

- (void)resetGame{
  [self animateRemovingCards:self.backgroundView.subviews];
  _game = [[CardMatchingGame alloc] initWithCardCount:DEFAULT_INIT_CARDS usingDeck:[self createDeck] usingGameMode:gameMode];
}

#define VERTICAL_BOUNDS_BUFFER 10
#define HORIZONTAL_BOUNDS_BUFFER 30 // seems to work after trial and error; should figure out why it matters

- (IBAction)touchCardButton:(UIButton *)sender {
  NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
  [self.game chooseCardAndCheckMatchAtIndex:chosenButtonIndex];
  
  self.scorelabel.text = [NSString stringWithFormat:@"Score: %lli",
                          (long long)self.game.score];
}


- (Deck *)createDeck{
  return nil; //abstract!
}


- (void)setGridBounds{
  _grid.size = CGSizeMake(self.view.bounds.size.width - HORIZONTAL_BOUNDS_BUFFER, self.view.bounds.size.height - VERTICAL_BOUNDS_BUFFER);
  _grid.cellAspectRatio = 0.6;
  _grid.minimumNumberOfCells = DEFAULT_INIT_CARDS;
  assert(_grid.inputsAreValid);
}

- (Grid *)grid {
  if (!_grid) _grid = [[Grid alloc] init];
  return _grid;
}

- (void)animateRemovingCards:(NSArray *)cardsToRemove {
  [UIView animateWithDuration:1.0 animations:^{
    for (UIView *card in cardsToRemove){
      int x = (arc4random()%(int)(self.backgroundView.bounds.size.width*5)) - (int)self.backgroundView.bounds.size.width*2;
      int y = self.backgroundView.bounds.size.height;
      card.center = CGPointMake(x, -y);
    }
  }
                   completion:^(BOOL finished) {
                     [cardsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                   }];
  NSUUID *uuid = [NSUUID UUID];
}

@end
