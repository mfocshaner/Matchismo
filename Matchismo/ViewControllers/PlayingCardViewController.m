//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 09/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardViewController ()

@end

@implementation PlayingCardViewController

- (Deck *)createDeck{
    return [[PlayingCardDeck alloc] init];
}

@end
