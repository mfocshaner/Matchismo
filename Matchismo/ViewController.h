//
//  ViewController.h
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 02/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//
// Abstract class. Must implement createDeck using specific deckType.


#import <UIKit/UIKit.h>
#import "Deck.h"

@interface ViewController : UIViewController

- (Deck *)createDeck;


@end

