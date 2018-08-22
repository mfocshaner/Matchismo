//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 09/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

@interface PlayingCardViewController ()

@end

@implementation PlayingCardViewController

- (Deck *)createDeck{
    return [[PlayingCardDeck alloc] init];
}

static const int defaultNumCards = 30;
-(void)awakeFromNib {
  self.defaultInitialCardNumber = defaultNumCards;
  [super awakeFromNib];
}

- (void)createCardViews {
  for (NSInteger i = 0; i < self.game.cardCount; i++) {
    PlayingCardView *createdCardView =
    [[PlayingCardView alloc] initWithFrame:[self.grid frameOfCellAtIndex:i]];
    [createdCardView setAttributedFromCard:[self.game cardAtIndex:i]];
    [createdCardView setBackgroundColor:[UIColor clearColor]];
    [createdCardView setUserInteractionEnabled:YES];
    [self.backgroundView addSubview:createdCardView];
  }
}

- (void)createCardsOutOfView {
  CGRect outerPointRect = CGRectMake(self.view.bounds.size.width, self.view.bounds.size.height, [self.grid frameOfCellAtIndex:0].size.width, [self.grid frameOfCellAtIndex:0].size.height);
  
  for (NSInteger i = 0; i < self.game.cardCount; i++) {
    PlayingCardView *createdCardView =
    [[PlayingCardView alloc] initWithFrame:outerPointRect];
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

- (IBAction)tapOnCard:(UITapGestureRecognizer *)sender {
  CGPoint tapLocation = ([sender locationInView:self.backgroundView]);
  UIView *tappedView = [self.backgroundView hitTest:tapLocation withEvent:nil];
//  NSUInteger chosenViewIndex = [self.backgroundView.subviews indexOfObject:tappedView];

  if ([tappedView isKindOfClass:[PlayingCardView class]]){
    if ([(PlayingCardView *)tappedView isMatched]) { return;}
    [UIView transitionWithView:(PlayingCardView*)tappedView duration:FLIP_ANIMATION_DURATION options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(){
      [(PlayingCardView *)tappedView setFaceUp:YES];
    } completion:^(BOOL finished){
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
      [(PlayingCardView *)tappedCardView setChosen:YES];
      [self.chosenCardViews addObject:tappedCardView];
    } else {
      if ([(PlayingCardView *)tappedCardView isChosen]){
        [UIView transitionWithView:(PlayingCardView*)tappedCardView duration:FLIP_ANIMATION_DURATION options:UIViewAnimationOptionTransitionFlipFromRight animations:^(){
          [(PlayingCardView *)tappedCardView setFaceUp:NO];
        } completion:^(BOOL finished){}];
      }
      [(PlayingCardView *)tappedCardView setChosen:NO];
      [self.chosenCardViews removeObject:tappedCardView];
    }
    if (self.chosenCardViews.count == 2){
      [self unchooseAllChosen];
    }
  }
  self.scorelabel.text = [NSString stringWithFormat:@"Score: %lli",
                          (long long)self.game.score];
}


- (void)matchActions {
  
  for (PlayingCardView *cardView in self.chosenCardViews) {
    cardView.matched = YES;
  }
  
  [UIView animateWithDuration:0.75 animations:^{
    for (UIView *card in self.chosenCardViews){
      card.alpha = 0.3;
    }
  }
                   completion:^(BOOL finished) {
                     [self.startNewGameButton setEnabled:YES];
                   }];
  [self.chosenCardViews removeAllObjects];
}

- (void)unchooseAllChosen {
  PlayingCardView *lastClickedCardView;
  for (PlayingCardView *cardView in self.chosenCardViews) {
    if ([self.chosenCardViews indexOfObject:cardView] == self.chosenCardViews.count - 1) {
      lastClickedCardView = cardView;
      break;
    }
    [(PlayingCardView *)cardView setChosen:NO];
    [UIView transitionWithView:(PlayingCardView*)cardView duration:FLIP_ANIMATION_DURATION options:UIViewAnimationOptionTransitionFlipFromRight animations:^(){
      [(PlayingCardView *)cardView setFaceUp:NO];
    } completion:^(BOOL finished){}];
    

    NSUInteger chosenViewIndex = [self.backgroundView.subviews indexOfObject:cardView];
    [self.game cardAtIndex:chosenViewIndex].chosen = NO;
  }
  [self.chosenCardViews removeAllObjects];
  [self.chosenCardViews addObject:lastClickedCardView];
}

- (void)resetGame {
  self.chosenCardViews = [[NSMutableArray<PlayingCardView *> alloc] init];
  [self animateRemovingCards:self.backgroundView.subviews];
  self.game = [[CardMatchingGame alloc] initWithCardCount:self.defaultInitialCardNumber usingDeck:[self createDeck] usingGameMode:2];
  self.scorelabel.text = [NSString stringWithFormat:@"Score: %lli",
                          (long long)self.game.score];
  [self createCardsOutOfView];
}



@end
