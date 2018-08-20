//
//  SetGame.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 09/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "SetGame.h"

#import "SetCard.h"

@interface SetGame()
@property (nonatomic, readwrite) NSInteger score;

@property (nonatomic, strong) NSMutableArray <SetCard *> *chosenCards;

@end


@implementation SetGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


- (NSMutableArray *)chosenCards{
  if (!_chosenCards) _chosenCards = [[NSMutableArray<SetCard *> alloc] init];
  return _chosenCards;
}




- (BOOL)chooseCardAndCheckMatchAtIndex:(NSUInteger)index {
  SetCard *card = [self cardAtIndex:index];
  if (card.isMatched){
    return NO;
  }
  
  if (card.isChosen){
    card.chosen = NO;
    [self.chosenCards removeObject:card];
    return NO;
  }
  card.chosen = YES;
  [self.chosenCards addObject:card];
  if (self.chosenCards.count < 3) {
    return NO;
  }
  
  BOOL foundMatch = [card match:self.chosenCards];
  return foundMatch ? [self foundMatchActions] : [self mismatchActions];
}

- (BOOL)foundMatchActions {
  [self matchAllChosen];
  self.score += MATCH_BONUS;
  
  [self.chosenCards removeAllObjects];
  return YES;
}

- (BOOL)mismatchActions {
  self.score -= COST_TO_CHOOSE;
  // [self unchooseAllCards];
  [self.chosenCards removeAllObjects];
  return NO;
}



@end
