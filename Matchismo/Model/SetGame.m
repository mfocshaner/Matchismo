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
    return [self concatenateCardContents:self.chosenCards];
  }
  card.chosen = YES;
  [self.chosenCards addObject:card];
  
  if (self.chosenCards.count < 3) {
    return [self concatenateCardContents:self.chosenCards];
  }
  
  // NSString *retString = @"";
  BOOL foundMatch = [card match:self.chosenCards];
  if (foundMatch) {
    [self matchAllChosen];
    self.score += MATCH_BONUS;
    return [self matchMessage:[self concatenateCardContents:self.chosenCards] success:YES];
  }
  
  self.score -= COST_TO_CHOOSE;
  [self unchooseAllCards];
  NSAttributedString *stringToReturn = [self matchMessage:[self concatenateCardContents:self.chosenCards] success:NO];
  [self.chosenCards removeAllObjects];
  return stringToReturn;
//  return @"Not a set!";
}

- (NSAttributedString *)concatenateCardContents:(NSArray<SetCard *> *)chosenCards {
  NSAttributedString *separator = [[NSAttributedString alloc] initWithString:@", "];
  NSMutableAttributedString *retString = [[NSMutableAttributedString alloc] init];
  for (SetCard *card in chosenCards) {
    [retString appendAttributedString:card.contents];
    [retString appendAttributedString:separator];
  }
  return (NSAttributedString *) retString;
}

- (NSAttributedString *)matchMessage:(NSAttributedString *)cardsString success:(BOOL)didMatch {
  NSAttributedString *successMessage = [[NSAttributedString alloc] initWithString:@"matched! Hurray!"];
  NSAttributedString *failureMessage = [[NSAttributedString alloc] initWithString:@"didn't match :("];
  NSMutableAttributedString *retString = [[NSMutableAttributedString alloc] initWithAttributedString:cardsString];
  if (didMatch){
    [retString appendAttributedString:successMessage];
    return retString;
  }
  [retString appendAttributedString:failureMessage];
  return retString;
}

@end
