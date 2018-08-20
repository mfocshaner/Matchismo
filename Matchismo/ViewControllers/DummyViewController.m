//
//  DummyViewController.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 15/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "DummyViewController.h"

#import "Deck.h"
#import "Grid.h"
#import "PlayingCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "SetCardView.h"

@interface DummyViewController ()

@property (readonly, nonatomic) Deck *deck;
@property (strong, nonatomic) Grid *grid;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) NSMutableArray <UIView *> *cardViewsToRemove;

@end

@implementation DummyViewController

@synthesize deck = _deck;

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
  _grid.cellAspectRatio = 0.6;
  _grid.minimumNumberOfCells = 20;
  assert(_grid.inputsAreValid);
}

- (Deck *)deck {
  if (!_deck) _deck = [[PlayingCardDeck alloc] init];
  return _deck;
}

- (Grid *)grid {
  if (!_grid) _grid = [[Grid alloc] init];
  return _grid;
}

- (void)drawRandomPlayingCard {
  Card *card = [self.deck drawRandomCard];
  if ([card isKindOfClass:[PlayingCard class]]){
    PlayingCard *playingCard = (PlayingCard *)card;
    // not used, so why? I was probably in the middle of something..
  }
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
      [self animateRemovingCards:[self.cardViewsToRemove copy]];
      [self.cardViewsToRemove removeAllObjects];
    }
  }];
  }
}

- (void)createCardViews {
  for (NSInteger i = 0; i < 12; i++) {
     PlayingCardView *createdPlayingCardView =
        [[PlayingCardView alloc] initWithFrame:[self.grid frameOfCellAtIndex:i]];
    PlayingCard *newRandomCard = (PlayingCard *)[self.deck drawRandomCard];
    createdPlayingCardView.suit = newRandomCard.suit;
    createdPlayingCardView.rank = newRandomCard.rank;
    createdPlayingCardView.faceUp = YES;
    [createdPlayingCardView setBackgroundColor:[UIColor clearColor]];
    [createdPlayingCardView setUserInteractionEnabled:YES];
    [self.backgroundView addSubview:createdPlayingCardView];
  }
  
  // manually created set cards
  SetCardView *setCard = [[SetCardView alloc] initWithFrame:[self.grid frameOfCellAtIndex:13]];
  setCard.symbol = @"oval";
  setCard.shading = @"solid";
  setCard.number = 3;
  setCard.color = @"green";
  
  [setCard setBackgroundColor:[UIColor clearColor]];
  [setCard setUserInteractionEnabled:YES];
  [self.backgroundView addSubview:setCard];
  
  SetCardView *setCard2 = [[SetCardView alloc] initWithFrame:[self.grid frameOfCellAtIndex:14]];
  setCard2.symbol = @"squiggle";
  setCard2.shading = @"striped";
  setCard2.number = 2;
  setCard2.color = @"purple";
  
  [setCard2 setBackgroundColor:[UIColor clearColor]];
  [setCard2 setUserInteractionEnabled:YES];
  [self.backgroundView addSubview:setCard2];

  SetCardView *setCard3 = [[SetCardView alloc] initWithFrame:[self.grid frameOfCellAtIndex:15]];
  setCard3.symbol = @"diamond";
  setCard3.shading = @"open";
  setCard3.number = 1;
  setCard3.color = @"red";

  [setCard3 setBackgroundColor:[UIColor clearColor]];
  [setCard3 setUserInteractionEnabled:YES];
  [self.backgroundView addSubview:setCard3];
  
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
  NSUUID *uuid = [NSUUID UUID];
  NSUInteger count = cardsToRemove.count;
  //[cardsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)insertNewCards {
  return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  [self setGridBounds];
  [self createCardViews];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self setGridBounds];
  NSUInteger i = 0;
  for (UIView *subview in self.backgroundView.subviews) {
    subview.center = [self.grid centerOfCellAtIndex:i++];
  }
}

@end
