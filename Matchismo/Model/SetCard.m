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
    NSString *tempString = @"";
    for (int i = 0; i < self.number; i++) {
        tempString = [tempString stringByAppendingString:self.symbol];
    }
    return tempString;
}

@synthesize symbol = _symbol;

+ (NSArray *)validSymbols
{
    return @[@"▲", @"●", @"■"];
}

+ (NSArray *)validColors
{
    return @[@"purple", @"green", @"red"];
}

- (void)setSymbol:(NSString *)symbol{
    if ([[SetCard validSymbols] containsObject:symbol]){
        _symbol = symbol;
    }
}

- (NSString *)symbol
{
    return _symbol ? _symbol : @"?";
}

+ (NSArray *)numberStrings
{
    return @[@"?", @"1", @"2", @"3"];
}

+ (NSUInteger)maxNumber {
    return [[self numberStrings] count]-1;
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]){
        _number = number;
    }
}

+ (NSArray *)validShadings
{
    return @[@"solid", @"striped", @"open"];
}


- (void)setShading:(NSString *)shading{
    if ([[SetCard validShadings] containsObject:shading]){
        _shading = shading;
    }
}

- (int)match:(NSArray *)otherCards{
    int score = 0;
    
    if (otherCards.count == 2){
        if ([self match:@[self, otherCards[0], otherCards[1]] byProperty:@"symbol"]
            && [self match:@[self, otherCards[0], otherCards[1]] byProperty:@"shading"]
            && [self match:@[self, otherCards[0], otherCards[1]] byProperty:@"number"]
        && [self match:@[self, otherCards[0], otherCards[1]] byProperty:@"color"]){
            
            score = 3;
        }
    }
    return score;
}
        
- (BOOL)match:(NSArray *)cards byProperty:(NSString*)property{
    if (cards.count != 3) {
        return NO;
    }
    BOOL allSame = [(SetCard*)cards[0] valueForKey:property] == [(SetCard*)cards[1] valueForKey:property];
    BOOL allDifferent = !allSame;
    
    allSame = allSame && ([(SetCard*)cards[1] valueForKey:property] == [(SetCard*)cards[2] valueForKey:property]);
    
    allDifferent = allDifferent && ([(SetCard*)cards[1] valueForKey:property] != [(SetCard*)cards[2] valueForKey:property]);
    allDifferent = allDifferent && ([(SetCard*)cards[0] valueForKey:property] != [(SetCard*)cards[2] valueForKey:property]);
    
    return allSame || allDifferent;
}

@end
