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
#import "Grid.h"

@interface DummyViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) Grid *grid;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;


@end

@implementation DummyViewController

#define FLIP_ANIMATION_DURATION 0.3

- (void)awakeFromNib{
  _grid = [[Grid alloc] init];
  _deck = [[PlayingCardDeck alloc] init];
}

- (void)setGridBounds{
  _grid.size = _backgroundView.bounds.size;
  _grid.cellAspectRatio = 0.6;
  _grid.minimumNumberOfCells = 12;
  assert(_grid.inputsAreValid);
}

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
  [UIView transitionWithView:self.playingCardView duration:FLIP_ANIMATION_DURATION options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(){
    self.playingCardView.faceUp = !self.playingCardView.faceUp;
  } completion:nil];
  
}

- (Grid *)grid {
  if (!_grid) _grid = [[Grid alloc] init];
  return _grid;
}

 - (IBAction)tapOnCard:(UITapGestureRecognizer *)sender {
  CGPoint tapLocation = ([sender locationInView:self.backgroundView]);
  UIView *tappedView = [self.backgroundView hitTest:tapLocation withEvent:nil];
  [UIView transitionWithView:(PlayingCardView*)tappedView duration:FLIP_ANIMATION_DURATION options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(){
    [(PlayingCardView *)tappedView setFaceUp:![(PlayingCardView *)tappedView faceUp]];
  } completion:nil];
 }

- (void)viewDidLoad {
    [super viewDidLoad];
  [self setGridBounds];
  
  for (NSInteger i = 0; i < 12; i++) {
    PlayingCardView *createdPlayingCardView = [[PlayingCardView alloc] initWithFrame:[_grid frameOfCellAtIndex:i]];
    PlayingCard *newRandomCard = [_deck drawRandomCard];
    createdPlayingCardView.suit = newRandomCard.suit;
    createdPlayingCardView.rank = newRandomCard.rank;
    createdPlayingCardView.faceUp = YES;
    [createdPlayingCardView setBackgroundColor:[UIColor clearColor]];
    [createdPlayingCardView setUserInteractionEnabled:YES];
    
    [self.backgroundView addSubview:createdPlayingCardView];

  }
  
  self.playingCardView.suit = @"♥️";
  self.playingCardView.rank = 13;

}

@end
