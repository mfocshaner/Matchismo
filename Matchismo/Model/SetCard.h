//
//  SetCard.h
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 08/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number;


+ (NSArray *)validSymbols;
+ (NSUInteger)maxNumber;

@end



@end
