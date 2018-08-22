//
//  Deck.h
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 05/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;
- (BOOL)isEmpty;

@end
