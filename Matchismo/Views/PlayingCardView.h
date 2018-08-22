//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 15/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface PlayingCardView : CardView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;
@property (nonatomic, getter=isMatched) BOOL matched;

@end
