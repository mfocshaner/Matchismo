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
#import "SetCardView.h"
#import "Grid.h"

@interface DummyViewController ()
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) Grid *grid;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) NSMutableArray <UIView *> *cardViewsToRemove;


@end

@implementation DummyViewController

#define FLIP_ANIMATION_DURATION 0.3

- (void)awakeFromNib {
  [super awakeFromNib];
  _grid = [[Grid alloc] init];
  _deck = [[PlayingCardDeck alloc] init];
  _cardViewsToRemove = [[NSMutableArray alloc] init];
}

#define VERTICAL_BOUNDS_BUFFER 10
#define HORIZONTAL_BOUNDS_BUFFER 30 // seems to work after trial and error; should figure out why it matters
- (void)setGridBounds{
  _grid.size = CGSizeMake(self.view.bounds.size.width - HORIZONTAL_BOUNDS_BUFFER, self.view.bounds.size.height - VERTICAL_BOUNDS_BUFFER);
  //_grid.size = self.backgroundView.bounds.size;
  _grid.cellAspectRatio = 0.6;
  _grid.minimumNumberOfCells = 20;
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
    // not used, so why? probably i was in the middle of something..
  }
}

//- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
//  if (!self.playingCardView.faceUp) {
//    [self drawRandomPlayingCard];
//  }
//  [UIView transitionWithView:self.playingCardView duration:FLIP_ANIMATION_DURATION options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(){
//    self.playingCardView.faceUp = !self.playingCardView.faceUp;
//  } completion:nil];
//
//}

- (Grid *)grid {
  if (!_grid) _grid = [[Grid alloc] init];
  return _grid;
}

- (IBAction)tapOnCard:(UITapGestureRecognizer *)sender {
  CGPoint tapLocation = ([sender locationInView:self.backgroundView]);
  UIView *tappedView = [self.backgroundView hitTest:tapLocation withEvent:nil];
  if ([tappedView isKindOfClass:[PlayingCardView class]]){
  [UIView transitionWithView:(PlayingCardView*)tappedView duration:FLIP_ANIMATION_DURATION options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(){
      [(PlayingCardView *)tappedView setFaceUp:![(PlayingCardView *)tappedView faceUp]];
  } completion:^(BOOL finished){
    [self.cardViewsToRemove addObject:tappedView];
    if (self.cardViewsToRemove.count > 2) {
      [self animateRemovingCards:self->_cardViewsToRemove];
      [self.cardViewsToRemove removeAllObjects];
    }
  }];
  }
}

static void createCardViews(DummyViewController *object) {
  for (NSInteger i = 0; i < 12; i++) {
    PlayingCardView *createdPlayingCardView = [[PlayingCardView alloc] initWithFrame:[object->_grid frameOfCellAtIndex:i]];
    PlayingCard *newRandomCard = [object->_deck drawRandomCard];
    createdPlayingCardView.suit = newRandomCard.suit;
    createdPlayingCardView.rank = newRandomCard.rank;
    createdPlayingCardView.faceUp = YES;
    [createdPlayingCardView setBackgroundColor:[UIColor clearColor]];
    [createdPlayingCardView setUserInteractionEnabled:YES];
    [object.backgroundView addSubview:createdPlayingCardView];
  }
  SetCardView *setCard = [[SetCardView alloc] initWithFrame:[object->_grid frameOfCellAtIndex:13]];
  setCard.symbol = @"squiggle";
  [setCard setBackgroundColor:[UIColor clearColor]];
  [setCard setUserInteractionEnabled:YES];
  [object.backgroundView addSubview:setCard];
}

- (void)animateRemovingCards:(NSArray *)cardsToRemove {
  [UIView animateWithDuration:1.0 animations:^{
    for (UIView *card in cardsToRemove){
      int x = (arc4random()%(int)(self.backgroundView.bounds.size.width*5)) - (int)self.backgroundView.bounds.size.width*2;
      int y = self.backgroundView.bounds.size.height;
      card.center = CGPointMake(x, -y);
    }
  }
                   completion:^(BOOL finished) {
                     [cardsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                   }];
}

- (void)insertNewCards {
  return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  [self setGridBounds];
  createCardViews(self);
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self setGridBounds];
  NSUInteger i = 0;
  for (UIView *subview in self.backgroundView.subviews) {
    subview.center = [_grid centerOfCellAtIndex:i++];
  }
}

@end