//
//  PlayingCard.h
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 05/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
