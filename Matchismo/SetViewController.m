//
//  SetViewController.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 09/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "SetViewController.h"
#import "SetDeck.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (Deck *)createDeck{
    return [[SetDeck alloc] init];
}

@end
