//
//  DummyViewController.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 15/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "DummyViewController.h"
#import "PlayingCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface DummyViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@property (strong, nonatomic) Deck *deck;


@end

@implementation DummyViewController

- (Deck *)deck {
  if (!_deck) _deck = [[PlayingCardDeck alloc] init];
  return _deck;
}

- (void)drawRandomPlayingCard {
  Card *card = [self.deck drawRandomCard];
  if ([card isKindOfClass:[PlayingCard class]]){
    PlayingCard *playingCard = (PlayingCard *)card;
    self.playingCardView.rank = playingCard.rank;
    self.playingCardView.suit = playingCard.suit;
  }
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
  if (!self.playingCardView.faceUp) {
    [self drawRandomPlayingCard];
  }
  self.playingCardView.faceUp = !self.playingCardView.faceUp;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.playingCardView.suit = @"♥️";
  self.playingCardView.rank = 13;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
