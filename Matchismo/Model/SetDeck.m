//
//  SetDeck.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 09/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck



- (instancetype)init
{
    self = [super init];
    
    if (self) {
        for (NSString *symbol in [SetCard validSymbols]){
            for (NSString *shading in [SetCard validShadings]) {
                for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++){
                    SetCard *card = [[SetCard alloc] init];
                    card.number = number;
                    card.symbol = symbol;
                    card.shading = shading;
                    [self addCard:card];
                }
            }
        }
    }
    return self;
}

@end
