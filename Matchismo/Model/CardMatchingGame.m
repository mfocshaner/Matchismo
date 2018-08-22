//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 06/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "CardMatchingGame.h"


// private section ("Class Extension")
@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray<Card *> *cards;
@property (nonatomic) NSUInteger gameMode;
@property (nonatomic, strong) Deck *deck;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards{
    if (!_cards) _cards = [[NSMutableArray<Card *> alloc] init];
    return _cards;
}

- (NSUInteger)cardCount {
  return self.cards.count;
}

- (nullable instancetype)initWithCardCount:(NSUInteger)count
                                 usingDeck:(Deck *)deck
                             usingGameMode:(NSUInteger)gameModeArg {
  if (self = [super init]){
    _cards = [[NSMutableArray<Card *> alloc] init];
    _deck = deck;
    for (int i = 0; i < count; i++) {
      Card *card = [_deck drawRandomCard];
      if (card) {
        [self.cards addObject:card];
      } else {
        self = nil;
        break;
      }
    }
    
  }
  self.gameMode = gameModeArg;
  return self;
}

- (BOOL)drawNewCardFromDeckToGameCards {
  Card *card = [self.deck drawRandomCard];
  if (card) {
    [self.cards addObject:card];
    return YES;
  }
  return NO;
}

- (BOOL)isDeckEmpty {
  return self.deck.isEmpty;
}

- (Card *)cardAtIndex:(NSUInteger)index{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


- (BOOL)chooseCardAndCheckMatchAtIndex:(NSUInteger)index {
  Card *card = [self cardAtIndex:index];
  if (card.isMatched){
    return NO;
  }
  
  if (card.isChosen){
    card.chosen = NO;
    return NO;
  }
  
  int numChosen = 1;
  BOOL foundMatch = NO;
  // match against other chosen cards
  for (Card *otherCard in self.cards){
    if (otherCard.isChosen && !otherCard.isMatched){
      numChosen++;
      int matchScore = [card match:@[otherCard]];
      if (matchScore){
        self.score += matchScore * MATCH_BONUS;
        card.matched = YES;
        [self matchAllChosen];
        foundMatch = YES;
        return YES;
      } else {
        self.score -= MISMATCH_PENALTY;
      }
      if (numChosen == _gameMode){ // found max num of chosen allowed
        [self unchooseAllCards];
        if (numChosen > 2 && !foundMatch) { // can't show more than 2 that don't match
        }
        break;
      }
    }
  }
  self.score -= COST_TO_CHOOSE;
  card.chosen = YES;
  return NO;
}

- (void)unchooseAllCards{
  for (Card *card in self.cards) {
    if (!card.isMatched && card.isChosen){
      card.chosen = NO;
    }
  }
}

- (void)matchAllChosen{
  for (Card *card in self.cards) {
    if (!card.isMatched && card.isChosen){
      card.matched = YES;
    }
  }
}

- (void)removeCardsFromGame:(NSArray *)cardsToRemove {
  [self.cards removeObjectsInArray:cardsToRemove];
}


@end
