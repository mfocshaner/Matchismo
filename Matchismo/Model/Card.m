//
//  Card.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 05/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    for (Card *card in otherCards){
        if ([card.contents isEqualToString:self.contents]){
            score = 1;
        }
    }
    return score;
}

@end
