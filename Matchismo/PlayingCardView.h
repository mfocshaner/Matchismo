//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 15/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

@end
