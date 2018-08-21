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
#import "Grid.h"


@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *startNewGameButton;

@property (weak, nonatomic) IBOutlet UILabel *scorelabel;

@property (strong, nonatomic) CardMatchingGame *game;

@property (strong, nonatomic) Grid *grid;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) NSMutableArray <UIView *> *cardViewsToRemove;
@property (nonatomic) NSInteger defaultInitialCardNumber;
@property (nonatomic, strong) NSMutableArray <UIView *> *chosenCardViews;

- (Deck *)createDeck;
- (void)animateRemovingCards:(NSArray *)cardsToRemove;
#define FLIP_ANIMATION_DURATION 0.3
- (void)reorganizeCardViews;

@end

