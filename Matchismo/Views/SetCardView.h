//
//  SetCardView.h
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 19/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "CardView.h"

@interface SetCardView : CardView

@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;
@property (nonatomic) NSUInteger number;


@end
