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
  if (!_chosenCards) _chosenCards = [[NSMutableArray<Card *> alloc] init];
  return _chosenCards;
}


- (NSAttributedString *)chooseCardAtIndex:(NSUInteger)index {
  SetCard *card = [self cardAtIndex:index];
  if (card.isMatched){
    return nil;
  }
  
  if (card.isChosen){
    card.chosen = NO;
    [self.chosenCards removeObject:card];
    return nil;
  }
  card.chosen = YES;
  [self.chosenCards addObject:card];
  
  if (self.chosenCards.count < 3) {
    return nil;
  }
  
  // NSString *retString = @"";
  BOOL foundMatch = [card match:self.chosenCards];
  if (foundMatch) {
    [self matchAllChosen];
    self.score += MATCH_BONUS;
    return [self concatenateCardContents:self.chosenCards];
  }
  
  self.score -= COST_TO_CHOOSE;
  [self unchooseAllCards];
  [self.chosenCards removeAllObjects];
  return [self concatenateCardContents:self.chosenCards];
//  return @"Not a set!";
}

- (NSAttributedString *)concatenateCardContents:(NSArray<SetCard *> *)matchdedCards {
  if (matchdedCards.count != 3) {
    return nil;
  }
  NSMutableAttributedString *retString = [[NSMutableAttributedString alloc] init];
  [retString appendAttributedString:matchdedCards[0].contents];
  [retString appendAttributedString:matchdedCards[1].contents];
  [retString appendAttributedString:matchdedCards[2].contents];
//  [returnedAttributedString appendAttributedString:@"match! nice job!"];
//  NSString *retString = [NSString stringWithFormat:@"%@%@%@ don't match!", matchdedCards[0].contents, matchdedCards[1].contents, matchdedCards[2].contents];
  return (NSAttributedString *) retString;
}

@end
