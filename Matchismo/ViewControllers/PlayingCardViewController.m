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

- (IBAction)tapOnCard:(UITapGestureRecognizer *)sender {
  CGPoint tapLocation = ([sender locationInView:self.backgroundView]);
  UIView *tappedView = [self.backgroundView hitTest:tapLocation withEvent:nil];
  if ([tappedView isKindOfClass:[PlayingCardView class]]){
    [UIView transitionWithView:(PlayingCardView*)tappedView duration:FLIP_ANIMATION_DURATION options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(){
      [(PlayingCardView *)tappedView setFaceUp:![(PlayingCardView *)tappedView faceUp]];
    } completion:^(BOOL finished){
      [self.cardViewsToRemove addObject:tappedView];
      if (self.cardViewsToRemove.count > 2) {
        [self animateRemovingCards:[self.cardViewsToRemove copy]];
        [self.cardViewsToRemove removeAllObjects];
      }
    }];
  }
}

@end
