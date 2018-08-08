//
//  SetCard.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 08/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (NSString *)contents
{
    return nil;
}

@synthesize symbol = _symbol;

+ (NSArray *)validSymbols
{
    return @[@"▲", @"●", @"■"];
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol]){
        _symbol = symbol;
    }
}

- (NSString *)symbol
{
    return _symbol ? _symbol : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"1", @"2", @"3"];
}

+ (NSUInteger)maxNumber {
    return [[self rankStrings] count]-1;
}

- (void)setNumber:(NSUInteger)number:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]){
        _number = number;
    }
}



- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if (otherCards.count == 2){
        BOOL match = NO;
        for (SetCard otherCard in otherCards) {
            
            match = (otherCard.number != this.number);
        }
        SetCard *otherCard = [otherCards firstObject]; // may be null!
        if (otherCard.number == self.number){
            score = 4;
        } else if ([otherCard.symbol isEqualToString:self.symbol]){
            score = 1;
        }
    }
    return score;
}

@end
