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
@property (nonatomic, strong) NSMutableArray<Card *> *cards;
@property (nonatomic) NSUInteger gameMode;

@end


@implementation SetGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;
NSMutableArray <Card*> *chosenCards;

- (NSString *)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    if (card.isMatched){
        return @"";
    }
    
    if (card.isChosen){
        card.chosen = NO;
        [chosenCards removeObject:card];
        return @"";
    }
    card.chosen = YES;
    [chosenCards addObject:card];
    
    if (chosenCards.count < 3) {
        return @"";
    }

    NSString *retString = @"";
    BOOL foundMatch = [card match:chosenCards];
    for (Card* card in chosenCards) {
        // add something here? don't know
    }
    
    // match against other chosen cards
    self.score -= COST_TO_CHOOSE;
    card.chosen = YES;
    return retString;
}

@end
