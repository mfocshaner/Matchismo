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
#import "CardMatchingGame.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (strong, nonatomic) IBOutlet UIButton *startNewGameButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *modeButton;

@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *scorelabel;

@property (strong, nonatomic) CardMatchingGame *game;

@property (strong, nonatomic) NSMutableAttributedString *gameHistory;

- (Deck *)createDeck;


@end

