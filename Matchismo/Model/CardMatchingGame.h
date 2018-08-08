//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 06/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardMatchingGame : NSObject


- (nullable instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck usingGameMode:(NSUInteger)gameModeArg NS_DESIGNATED_INITIALIZER;


// - (void)chooseCardAtIndex:(NSUInteger)index;
- (NSString *)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;

@end

NS_ASSUME_NONNULL_END
