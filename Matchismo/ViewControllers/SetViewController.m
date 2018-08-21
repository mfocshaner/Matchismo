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

@property (strong, nonatomic) IBOutlet UIButton *HitMeButton;


@end

@implementation SetViewController

static int gameMode = 0;
static const int DEFAULT_INIT_CARDS = 18;

- (void)initGame {
  self.game = [[SetGame alloc] initWithCardCount:DEFAULT_INIT_CARDS usingDeck:[self createDeck] usingGameMode:gameMode];
  self.defaultInitialCardNumber = DEFAULT_INIT_CARDS;
}

- (Deck *)createDeck {
  return [[SetDeck alloc] init];
}

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
    }
     ];
  }
}

#define NUMBER_OF_CARDS_TO_ADD 3
- (IBAction)hitMePressed:(UIButton *)sender {
  [self insertNewCards:NUMBER_OF_CARDS_TO_ADD];
}

- (void)insertNewCards:(NSUInteger)numberOfCardsToAdd {
  NSUInteger currentCount = self.backgroundView.subviews.count;
  CGRect outerPointRect = CGRectMake(self.view.bounds.size.width, self.view.bounds.size.height, [self.grid frameOfCellAtIndex:0].size.width, [self.grid frameOfCellAtIndex:0].size.height);
  
  for (NSInteger i = currentCount; i < currentCount+numberOfCardsToAdd; i++) {
    if ([self.game drawNewCardFromDeckToGameCards]) {
      SetCardView *createdCardView =
      [[SetCardView alloc] initWithFrame:outerPointRect];
      [createdCardView setAttributedFromCard:[self.game cardAtIndex:i]];
      [createdCardView setBackgroundColor:[UIColor clearColor]];
      [createdCardView setUserInteractionEnabled:YES];
      [self.backgroundView addSubview:createdCardView];
      [UIView animateWithDuration:1.0 animations:^{
        [createdCardView setFrame:[self.grid frameOfCellAtIndex:i]];
      }
       ];
    }
  }
}

- (IBAction)tapOnCard:(UITapGestureRecognizer *)sender {
  CGPoint tapLocation = ([sender locationInView:self.backgroundView]);
  UIView *tappedView = [self.backgroundView hitTest:tapLocation withEvent:nil];
  if ([tappedView isKindOfClass:[SetCardView class]]){
    [UIView animateWithDuration:0.05
                     animations:^{
                       tappedView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                     }
                     completion:^(BOOL finished) {
                       [UIView animateWithDuration:0.05
                                        animations:^{
                                          tappedView.transform = CGAffineTransformIdentity;
                                          
                                        }];
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
      [(SetCardView *)tappedCardView setStrokeColor:[UIColor redColor]];
      [self.chosenCardViews addObject:tappedCardView];
    } else {
      [(SetCardView *)tappedCardView setChosen:NO];
      [self.chosenCardViews removeObject:tappedCardView];
      [(SetCardView *)tappedCardView setStrokeColor:[UIColor blackColor]];
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
  
  [UIView animateWithDuration:0.5 animations:^{
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
                     [self reorganizeCardViews];
                     [self.startNewGameButton setEnabled:YES];
                     
                     [self.game removeCardsFromGame:cardsToRemoveFromGame];
                     [self.chosenCardViews removeAllObjects];
                     if (self.game.cardCount < self.defaultInitialCardNumber){
                       [self insertNewCards:(self.defaultInitialCardNumber - self.game.cardCount)];
                     }
                   }];
  
//  [self animateRemovingCards:[self.chosenCardViews copy]];
//
//  for (SetCardView *cardView in self.chosenCardViews) {
//    [self animateRemovingCards:@[cardView]];
//    //[cardView removeFromSuperview];
//  }
  
//  [self.game removeCardsFromGame:cardsToRemoveFromGame];
//  [self.chosenCardViews removeAllObjects];
//  if (self.game.cardCount < self.defaultInitialCardNumber){
//    [self insertNewCards:(self.defaultInitialCardNumber - self.game.cardCount)];
//  }
}

- (void)unchooseAllChosen {
  for (SetCardView *cardView in self.chosenCardViews) {
    [(SetCardView *)cardView setChosen:NO];
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
