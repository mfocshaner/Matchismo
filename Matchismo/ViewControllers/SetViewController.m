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

@end

@implementation SetViewController



static int gameMode = 0;

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

- (IBAction)tapOnCard:(UITapGestureRecognizer *)sender {
  CGPoint tapLocation = ([sender locationInView:self.backgroundView]);
  UIView *tappedView = [self.backgroundView hitTest:tapLocation withEvent:nil];
  if ([tappedView isKindOfClass:[SetCardView class]]){
    [self touchCard:tappedView];
    [UIView transitionWithView:(SetCardView*)tappedView duration:FLIP_ANIMATION_DURATION options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(){
    } completion:^(BOOL finished){
      [self.cardViewsToRemove addObject:tappedView];
      if (self.cardViewsToRemove.count > 8) {
        [self animateRemovingCards:[self.cardViewsToRemove copy]];
        [self.cardViewsToRemove removeAllObjects];
      }
    }];
  }
}


- (void)touchCard:(UIView *)tappedCardView {
  NSUInteger chosenButtonIndex = [self.backgroundView.subviews indexOfObject:tappedCardView];
  [self.game chooseCardAndCheckMatchAtIndex:chosenButtonIndex];
  if ([self.game cardAtIndex:chosenButtonIndex].isChosen){
    [(SetCardView *)tappedCardView setStrokeColor:[UIColor redColor]];
  } else {
    [(SetCardView *)tappedCardView setStrokeColor:[UIColor blackColor]];
  }

}


#define SET_INITIAL_CARD_COUNT 12
- (void)resetGame {
  self.game = [[SetGame alloc] initWithCardCount: SET_INITIAL_CARD_COUNT usingDeck:[self createDeck] usingGameMode:gameMode];
}

@end
