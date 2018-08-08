//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 08/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "PlayingCardGameViewController.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck{
    return [[PlayingCardDeck alloc] init]; // abstract!
}

@end
