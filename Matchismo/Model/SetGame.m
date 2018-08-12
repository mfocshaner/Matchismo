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

@property (nonatomic, strong) NSMutableArray <Card*> *chosenCards;

@end


@implementation SetGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


- (NSMutableArray *)chosenCards{
    if (!_chosenCards) _chosenCards = [[NSMutableArray<Card *> alloc] init];
    return _chosenCards;
}


- (NSString *)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    if (card.isMatched){
        return @"";
    }
    
    if (card.isChosen){
        card.chosen = NO;
        [self.chosenCards removeObject:card];
        return @"";
    }
    card.chosen = YES;
    [self.chosenCards addObject:card];
    
    if (self.chosenCards.count < 3) {
        return @"";
    }

    // NSString *retString = @"";
    BOOL foundMatch = [card match:self.chosenCards];
    if (foundMatch) {
        [self matchAllChosen];
        self.score += MATCH_BONUS;
        return @"Set found, nice job!"; // should do something more informative
    }
    
    self.score -= COST_TO_CHOOSE;
    [self unchooseAllCards];
    [self.chosenCards removeAllObjects];
    return @"Not a set!";
}

@end
