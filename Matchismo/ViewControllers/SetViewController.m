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
#import "SetCardView.h"

@interface SetViewController ()

@property (strong, nonatomic) IBOutlet UIButton *hitMeButton;


@end

@implementation SetViewController

static int gameMode = 0;
static const int DEFAULT_INIT_CARDS = 18;

-(void)awakeFromNib {
  self.defaultInitialCardNumber = DEFAULT_INIT_CARDS;
  [super awakeFromNib];
}

- (void)initGame {
  self.game = [[SetGame alloc] initWithCardCount:DEFAULT_INIT_CARDS usingDeck:[self createDeck] usingGameMode:gameMode];
  self.defaultInitialCardNumber = DEFAULT_INIT_CARDS;
}

- (Deck *)createDeck {
  return [[SetDeck alloc] init];
}

#pragma mark Views Management

- (void)createCardViews {
  for (NSInteger i = 0; i < self.game.cardCount; i++) {
    SetCardView *createdCardView =
    [[SetCardView alloc] initWithFrame:[self.grid frameOfCellAtIndex:i]];
    [createdCardView setAttributedFromCard:[self.game cardAtIndex:i]];
    [createdCardView setBackgroundColor:[UIColor clearColor]];
    [createdCardView setUserInteractionEnabled:YES];
    [self.backgroundView addSubview:createdCardView];
  }
}

- (void)createCardsOutOfView {
  CGRect outerPointRect = CGRectMake(self.view.bounds.size.width, self.view.bounds.size.height, [self.grid frameOfCellAtIndex:0].size.width, [self.grid frameOfCellAtIndex:0].size.height);
  
  for (NSInteger i = 0; i < self.game.cardCount; i++) {
    SetCardView *createdCardView =
    [[SetCardView alloc] initWithFrame:outerPointRect];
    [createdCardView setAttributedFromCard:[self.game cardAtIndex:i]];
    [createdCardView setBackgroundColor:[UIColor clearColor]];
    [createdCardView setUserInteractionEnabled:YES];
    [self.backgroundView addSubview:createdCardView];
    [UIView animateWithDuration:1.0 animations:^{
      [createdCardView setFrame:[self.grid frameOfCellAtIndex:i]];
    } completion:^(BOOL finished) {
      if (i == self.game.cardCount - 1) {
        [self enableButtons];
      }
    }
     ];
  }
}

- (void)insertNewCards:(NSUInteger)numberOfCardsToAdd {
  NSUInteger currentCount = self.backgroundView.subviews.count;
  NSInteger newCount = currentCount+numberOfCardsToAdd;
  CGRect outerPointRect = CGRectMake(self.view.bounds.size.width, self.view.bounds.size.height, [self.grid frameOfCellAtIndex:0].size.width, [self.grid frameOfCellAtIndex:0].size.height);
  
  if (newCount > [self.grid numberOfCells]) {
    self.grid.minimumNumberOfCells = newCount;
    [self reorganizeCardViews:newCount];
  }
  
  for (NSInteger i = currentCount; i < newCount; i++) {
    if ([self.game drawNewCardFromDeckToGameCards]) {
      SetCardView *createdCardView =
      [[SetCardView alloc] initWithFrame:outerPointRect];
      [createdCardView setAttributedFromCard:[self.game cardAtIndex:i]];
      [createdCardView setBackgroundColor:[UIColor clearColor]];
      [createdCardView setUserInteractionEnabled:YES];
      [self.backgroundView addSubview:createdCardView];
      [UIView animateWithDuration:1.0 animations:^{
        [createdCardView setFrame:[self.grid frameOfCellAtIndex:i]];
      } completion:^(BOOL finished){
        if (i == newCount - 1) {
          [self enableButtons];
        }
      }
       ];
    }
  }
}



#pragma mark Buttons

- (IBAction)touchStartNewGameButton:(UIButton *)sender {
  sender.enabled = NO;
  self.hitMeButton.enabled = NO;
  [self resetGame];
}

#define NUMBER_OF_CARDS_TO_ADD 3
- (IBAction)hitMePressed:(UIButton *)sender {
  [self.startNewGameButton setEnabled:NO];
  [sender setEnabled:NO];
  [self insertNewCards:NUMBER_OF_CARDS_TO_ADD];
  if (self.game.isDeckEmpty) {
    [sender setTitle:@"empty!" forState:UIControlStateNormal];
    [sender setEnabled:FALSE];
    [self.startNewGameButton setEnabled:YES];
  }
}

- (void)enableButtons {
  [self.startNewGameButton setEnabled:YES];
  [self.hitMeButton setEnabled:YES];
  if (!self.game.isDeckEmpty) {
    [self.hitMeButton setTitle:@"Hit me!" forState:UIControlStateNormal];
  }
}

- (void)disableButtons {
  [self.startNewGameButton setEnabled:NO];
  [self.hitMeButton setEnabled:NO];
}


#pragma mark Card Interactions

- (IBAction)tapOnCard:(UITapGestureRecognizer *)sender {
  if (self.piled) {
    [super tapOnCard:sender];
    return;
  }
  CGPoint tapLocation = ([sender locationInView:self.backgroundView]);
  UIView *tappedView = [self.backgroundView hitTest:tapLocation withEvent:nil];
  if ([tappedView isKindOfClass:[SetCardView class]]){
        [UIView animateWithDuration:0.05
                         animations:^{
                           tappedView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                         }];
    [self touchCard:tappedView];
  }
}

- (void)touchCard:(UIView *)tappedCardView {
  NSUInteger chosenViewIndex = [self.backgroundView.subviews indexOfObject:tappedCardView];
  BOOL match = [self.game chooseCardAndCheckMatchAtIndex:chosenViewIndex];
  if (match) {
    [self.chosenCardViews addObject:tappedCardView];
    [self matchActions];
  } else {
    if ([self.game cardAtIndex:chosenViewIndex].isChosen){
      [(SetCardView *)tappedCardView setChosen:YES];
      [self.chosenCardViews addObject:tappedCardView];
      [UIView animateWithDuration:0.3 animations:^{
        tappedCardView.alpha = 0.4;
        tappedCardView.transform = CGAffineTransformIdentity;
      }];
    } else {
      [(SetCardView *)tappedCardView setChosen:NO];
      [self.chosenCardViews removeObject:tappedCardView];
      [UIView animateWithDuration:0.3 animations:^{
        tappedCardView.alpha = 1.0;
        tappedCardView.transform = CGAffineTransformIdentity;
      }];
    }
    if (self.chosenCardViews.count == 3){
      [self unchooseAllChosen];
  }
  }
  self.scorelabel.text = [NSString stringWithFormat:@"Score: %lli",
                          (long long)self.game.score];
}

- (void)matchActions {
  NSMutableArray *cardsToRemoveFromGame = [[NSMutableArray alloc] init];
  
  NSUInteger viewsCount = self.backgroundView.subviews.count;
  for (SetCardView *cardView in self.chosenCardViews) {
    NSUInteger viewIndex = [self.backgroundView.subviews indexOfObject:cardView];
    [cardsToRemoveFromGame addObject:[self.game cardAtIndex:viewIndex]];
  } // after we got indices of cards (in game.cards) we can remove the views safely
  
  [UIView animateWithDuration:0.75 animations:^{
    for (UIView *card in self.chosenCardViews){
      int x = (arc4random()%(int)(self.backgroundView.bounds.size.width*5)) - (int)self.backgroundView.bounds.size.width*2;
      int y = self.backgroundView.bounds.size.height;
      card.center = CGPointMake(x, -y);
    }
  }
                   completion:^(BOOL finished) {
                     for (UIView *card in self.chosenCardViews) {
                       [card removeFromSuperview];
                     }
                     [self reorganizeCardViews:self.backgroundView.subviews.count];
                     [self.startNewGameButton setEnabled:YES];
                     
                     [self.game removeCardsFromGame:cardsToRemoveFromGame];
                     [self.chosenCardViews removeAllObjects];
                     if (self.game.cardCount < self.defaultInitialCardNumber){
                       [self insertNewCards:(self.defaultInitialCardNumber - self.game.cardCount)];
                     }
                   }];
}

- (void)unchooseAllChosen {
  for (SetCardView *cardView in self.chosenCardViews) {
    [(SetCardView *)cardView setChosen:NO];
    [UIView animateWithDuration:0.5 animations:^{ cardView.alpha = 1.0;}
                     completion:^(BOOL finished) {
                       [UIView animateWithDuration:0.05
                                        animations:^{
                                          cardView.transform = CGAffineTransformIdentity;
                                        }];
                     }];
    [(SetCardView *)cardView setStrokeColor:[UIColor blackColor]];
    NSUInteger chosenViewIndex = [self.backgroundView.subviews indexOfObject:cardView];
    [self.game cardAtIndex:chosenViewIndex].chosen = NO;
  }
  [self.chosenCardViews removeAllObjects];
}

- (void)resetGame {
  self.chosenCardViews = [[NSMutableArray<SetCardView *> alloc] init];
  [self animateRemovingCards:self.backgroundView.subviews];
  self.game = [[SetGame alloc] initWithCardCount: DEFAULT_INIT_CARDS usingDeck:[self createDeck] usingGameMode:gameMode];
  self.scorelabel.text = [NSString stringWithFormat:@"Score: %lli",
                          (long long)self.game.score];
  [self createCardsOutOfView];
}



@end
