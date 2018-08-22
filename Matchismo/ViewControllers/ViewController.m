//
//  ViewController.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 02/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "ViewController.h"
#import "CardView.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchRecognizer;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;


@end


@implementation ViewController

static const int DEFAULT_MODE = 2;
static int gameMode = DEFAULT_MODE;
static const int DEFAULT_INIT_CARDS = 30;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initGame];
  [[self backgroundView] init];
  [self setGridBounds:self.defaultInitialCardNumber];
  [self createCardViews];
}

- (void)createCardViews {
  for (NSInteger i = 0; i < self.game.cardCount; i++) {
    CardView *createdCardView =
    [[CardView alloc] initWithFrame:[self.grid frameOfCellAtIndex:i]];
    [createdCardView setAttributedFromCard:[self.game cardAtIndex:i]];
    [createdCardView setBackgroundColor:[UIColor clearColor]];
    [createdCardView setUserInteractionEnabled:YES];
    [self.backgroundView addSubview:createdCardView];
  }
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  if (self.backgroundView) {
    [self reorganizeCardViews:self.backgroundView.subviews.count];
  } else {
    [self reorganizeCardViews:self.defaultInitialCardNumber];
  }
}

- (void)reorganizeCardViews:(NSUInteger)numCards {
  [self setGridBounds:numCards];
  for (UIView *subview in self.backgroundView.subviews) {
    if (subview.center.y < 0) continue; // make sure we don't reorganize out-of-screen cards (that haven't been removed yet)
    [UIView animateWithDuration:0.5 animations:^{
      NSUInteger indexOfView = [self.backgroundView.subviews indexOfObject:subview];
      [subview setFrame:[self.grid frameOfCellAtIndex:indexOfView]];
    } completion:^(BOOL finished) {
      if ([subview isEqual:[self.backgroundView.subviews lastObject]]){
        [self enableButtons];
      }
    }
     ];
  }
}

- (void)animateRemovingCards:(NSArray *)cardsToRemove {
  [UIView animateWithDuration:0.5 animations:^{
    for (UIView *card in cardsToRemove){
      int x = (arc4random()%(int)(self.backgroundView.bounds.size.width*5)) - (int)self.backgroundView.bounds.size.width*2;
      int y = self.backgroundView.bounds.size.height;
      card.center = CGPointMake(x, -y);
    }
  }
                   completion:^(BOOL finished) {
                     for (UIView *card in cardsToRemove) {
                       [card removeFromSuperview];
                     }
                     [self reorganizeCardViews:self.backgroundView.subviews.count];
                   }];
}

- (void)enableButtons {
  [self.startNewGameButton setEnabled:YES];
}

#define DEFAULT_INITIAL_CARD_COUNT 30
- (void)awakeFromNib {
  [super awakeFromNib];
  _game = [[CardMatchingGame alloc] initWithCardCount:self.defaultInitialCardNumber usingDeck:[self createDeck] usingGameMode:gameMode];
  _grid = [[Grid alloc] init];
  _cardViewsToRemove = [[NSMutableArray alloc] init];
  _chosenCardViews = [[NSMutableArray alloc] init];
  [self initRecognizersAndAnimator];
}

#pragma mark Pinching

- (void)initRecognizersAndAnimator {
  _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.backgroundView];
  _animator.delegate = self;
  _pinchRecognizer = [[UIPinchGestureRecognizer alloc] init];
  _panRecognizer = [[UIPanGestureRecognizer alloc] init];
  _piled = NO;
}

- (IBAction)userPinched:(UIPinchGestureRecognizer *)sender {
  if (self.piled) {
    return;
  }
  if (sender.state == UIGestureRecognizerStateEnded){
    CGPoint gesturePoint = [sender locationInView:self.view];
    UIView *lastView = self.backgroundView.subviews.lastObject;
self.attachment = [[UIAttachmentBehavior alloc] initWithItem:lastView attachedToAnchor:gesturePoint];
    for (int i = 0; i < self.backgroundView.subviews.count; i++) {
      CardView *view = (CardView *)self.backgroundView.subviews[i];

      [UIView animateWithDuration:0.3 animations:^{
        view.center = gesturePoint;
      } completion:^(BOOL finished) {
        if (i == self.backgroundView.subviews.count - 1) {
          return;
        }
        CardView *viewToAttach = (CardView *)self.backgroundView.subviews[i+1];
        [view setAttachment:[[UIAttachmentBehavior alloc] initWithItem:view attachedToItem:viewToAttach]];
        //view.attachment.attachedBehaviorType = [UIAttachmentBehavior Attachment
        [self.animator addBehavior:view.attachment];
      }
       ];
      
    }
    
    [self.animator addBehavior:self.attachment];
    self.piled = YES;
  }
}

- (IBAction)panAction:(UIPanGestureRecognizer *)sender {
  if (self.animator.behaviors.count){
    if (sender.state == UIGestureRecognizerStateBegan){
      CGPoint gesturePoint = [sender locationInView:self.view];
//      for (UIView *cardView in self.backgroundView.subviews) {
//        [UIView animateWithDuration:0.4
//                              animations:^{
//                           cardView.center = gesturePoint;
//                         }
//         ];
//      }
      
//      lastView.attachment.anchorPoint = gesturePoint;

      CardView *lastView = self.backgroundView.subviews.lastObject;
            [UIView animateWithDuration:0.3
                       animations:^{
                         lastView.center = gesturePoint;
                       }];
    }
    else if (sender.state == UIGestureRecognizerStateChanged){
    CGPoint gesturePoint = [sender locationInView:self.view];
    self.attachment.anchorPoint = gesturePoint;
      for (UIView *cardView in self.backgroundView.subviews) {
        [[(CardView *)cardView attachment] setAnchorPoint:gesturePoint];
      }
    }
    else if (sender.state == UIGestureRecognizerStateEnded){
      // [self.animator removeBehavior:_attachment];
    }
  }
}

- (IBAction)tapOnCard:(UITapGestureRecognizer *)sender {
  if (!self.piled) {
    return;
  } else {
    CGPoint tapLocation = ([sender locationInView:self.backgroundView]);
    UIView *tappedView = [self.backgroundView hitTest:tapLocation withEvent:nil];
    if (tappedView == self.backgroundView.subviews.lastObject) {
      self.piled = NO;
      [self.animator removeAllBehaviors];
      [self reorganizeCardViews:self.game.cardCount];
    }
}
}


- (CardMatchingGame *)game{
  if (!_game) {[self resetGame];};
    return _game;
}

- (IBAction)touchStartNewGameButton:(UIButton *)sender {
  sender.enabled = NO;
  [self resetGame];
}

- (void)initGame {
  _game = [[CardMatchingGame alloc] initWithCardCount:self.defaultInitialCardNumber usingDeck:[self createDeck] usingGameMode:gameMode];
}

- (void)resetGame{
  self.chosenCardViews = [[NSMutableArray alloc] init];
  [self animateRemovingCards:self.backgroundView.subviews];
  _game = [[CardMatchingGame alloc] initWithCardCount:DEFAULT_INIT_CARDS usingDeck:[self createDeck] usingGameMode:gameMode];
  self.scorelabel.text = [NSString stringWithFormat:@"Score: %lli",
                          (long long)self.game.score];
}

- (Deck *)createDeck{
  return nil; //abstract!
}

- (void)setGridBounds:(NSUInteger)numCards {
  _grid.size = CGSizeMake(self.backgroundView.bounds.size.width, self.backgroundView.bounds.size.height);
  _grid.cellAspectRatio = 0.6;
  _grid.minimumNumberOfCells = numCards;
  assert(_grid.inputsAreValid);
}

- (Grid *)grid {
  if (!_grid) _grid = [[Grid alloc] init];
  return _grid;
}



@end
