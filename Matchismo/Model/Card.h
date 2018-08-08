//
//  Card.h
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 05/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
