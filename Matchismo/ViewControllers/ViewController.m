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

#define DEFAULT_INITIAL_CARD_COUNT 30
- (void)awakeFromNib {
  [super awakeFromNib];
  _game = [[CardMatchingGame alloc] initWithCardCount:self.defaultInitialCardNumber usingDeck:[self createDeck] usingGameMode:gameMode];
  _grid = [[Grid alloc] init];
  _cardViewsToRemove = [[NSMutableArray alloc] init];
  _chosenCardViews = [[NSMutableArray alloc] init];
  [self initRecognizersAndAnimator];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  if (self.piled) {
    CGPoint screenCenter = CGPointMake(self.view.bounds.size.width / 2,
                                       self.view.bounds.size.height / 2);
    [UIView animateWithDuration:0.5 animations:^{
      self.backgroundView.subviews.lastObject.center = screenCenter;
    }];
    self.attachment.anchorPoint = screenCenter;
    return;
  }
  if (self.backgroundView) {
    [self reorganizeCardViews:self.backgroundView.subviews.count];
  } else {
    [self reorganizeCardViews:self.defaultInitialCardNumber];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initGame];
  [self.backgroundView init];
  [self setGridBounds:self.defaultInitialCardNumber];
  [self createCardViews];
}

#pragma mark View manipulation

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
  [self disableButtons];
  if (sender.state == UIGestureRecognizerStateEnded){
    CGPoint gesturePoint = [sender locationInView:self.view];
    UIView *lastView = self.backgroundView.subviews.lastObject;
    self.attachment = [[UIAttachmentBehavior alloc] initWithItem:lastView attachedToAnchor:gesturePoint];
    for (int i = 0; i < self.backgroundView.subviews.count; i++) {
      CardView *view = (CardView *)self.backgroundView.subviews[i];

      [UIView animateWithDuration:0.4 animations:^{
        view.center = gesturePoint;
      } completion:^(BOOL finished) {
        if ([view isEqual:lastView]) {
          return;
        }
        CardView *viewToAttach = (CardView *)self.backgroundView.subviews[i+1];
//        UIAttachmentBehavior *viewAttachment = [[UIAttachmentBehavior alloc]  initWithItem:view attachedToItem:viewToAttach];
        UIAttachmentBehavior *viewAttachment = [UIAttachmentBehavior fixedAttachmentWithItem:lastView attachedToItem:view attachmentAnchor:gesturePoint];
        [viewAttachment setDamping:0.0];
//        [viewAttachment setLength:0];
        //        [view setAttachment:viewAttachment];
        [self.animator addBehavior:viewAttachment];
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
    self.attachment.anchorPoint = gesturePoint;
    }

    else if (sender.state == UIGestureRecognizerStateChanged){
    CGPoint gesturePoint = [sender locationInView:self.view];
    self.attachment.anchorPoint = gesturePoint;
    }
    else if (sender.state == UIGestureRecognizerStateEnded){
    }
  }
}

- (IBAction)tapOnCard:(UITapGestureRecognizer *)sender {
  if (!self.piled) {
    return;
  } else { // this method is actually used when subclass calls it to handle piling
    CGPoint tapLocation = ([sender locationInView:self.backgroundView]);
    UIView *tappedView = [self.backgroundView hitTest:tapLocation withEvent:nil];
    if (tappedView == self.backgroundView.subviews.lastObject) {
      self.piled = NO;
      [self.animator removeAllBehaviors];
      [self reorganizeCardViews:self.game.cardCount];
    }
}
}




- (IBAction)touchStartNewGameButton:(UIButton *)sender {
  sender.enabled = NO;
  [self resetGame];
}

- (void)enableButtons {
  [self.startNewGameButton setEnabled:YES];
}

- (void)disableButtons {
  [self.startNewGameButton setEnabled:NO];
}

- (CardMatchingGame *)game{
  if (!_game) {[self resetGame];};
  return _game;
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

- (Grid *)grid {
  if (!_grid) _grid = [[Grid alloc] init];
  return _grid;
}

- (void)setGridBounds:(NSUInteger)numCards {
  _grid.size = CGSizeMake(self.backgroundView.bounds.size.width, self.backgroundView.bounds.size.height);
  _grid.cellAspectRatio = 0.6;
  _grid.minimumNumberOfCells = numCards;
  assert(_grid.inputsAreValid);
}



@end
