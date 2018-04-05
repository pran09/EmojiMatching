//
//  MatchingGame.m
//  EmojiMatching
//
//  Created by Praneet Chakraborty on 4/4/18.
//  Copyright © 2018 Praneet CSSE484. All rights reserved.
//

#import "MatchingGame.h"

@implementation MatchingGame

NSArray* allCardBacks;
NSArray* allEmojiCharacters;


- (id) initWithNumPairs:(NSInteger) numPairs {
    self = [super init];
    if (self) {
        firstIndex = -1;
        secondIndex = -1;
        self.numPairs = numPairs;
        self.gameState = firstSelection;
        
        allCardBacks = [@"🎆,🎇,🌈,🌅,🌇,🌉,🌃,🌄,⛺,⛲,🚢,🌌,🌋,🗽" componentsSeparatedByString:@","];
        allEmojiCharacters = [@"🚁,🐴,🐇,🐢,🐱,🐌,🐒,🐞,🐫,🐠,🐬,🐩,🐶,🐰,🐼,⛄,🌸,⛅,🐸,🐳,❄,❤,🐝,🌺,🌼,🌽,🍌,🍎,🍡,🏡,🌻,🍉,🍒,🍦,👠,🐧,👛,🐛,🐘,🐨,😃,🐻,🐹,🐲,🐊,🐙" componentsSeparatedByString:@","];
        
//        // Randomly select emojiSymbols
//        NSMutableArray* emojiSymbolsUsed = [[NSMutableArray alloc] init];
//        while (emojiSymbolsUsed.count < numPairs) {
//            NSString* symbol = allEmojiCharacters[arc4random_uniform((UInt32) allEmojiCharacters.count)];
//            if (![emojiSymbolsUsed containsObject:symbol]) {
//                [emojiSymbolsUsed addObject:symbol];
//            }
//        }
//        [emojiSymbolsUsed addObjectsFromArray:emojiSymbolsUsed];
//        // Shuffle the NSMutableArray before converting it to an NSArray.
//        for (int i = 0; i < emojiSymbolsUsed.count; ++i) {
//            UInt32 j = arc4random_uniform((UInt32) emojiSymbolsUsed.count - i) + i;
//            [emojiSymbolsUsed exchangeObjectAtIndex:i withObjectAtIndex:j];
//        }
//        self.cards = [NSArray arrayWithArray:emojiSymbolsUsed];

        [self newGame:numPairs];
        // Randomly select a card back.
        self.cardBack = allCardBacks[arc4random_uniform((UInt32) allCardBacks.count)];
        
        // Reset cardStates to ensure default values.
        for (int i = 0; i < self.cards.count; ++i) {
            cardStates[i] = hidden;
        }
    }
    return self;
}

- (void) newGame:(NSInteger) numPairs {
    NSMutableArray* emojiSymbolsUsed = [[NSMutableArray alloc] init];
    while (emojiSymbolsUsed.count < numPairs) {
        NSString* symbol = allEmojiCharacters[arc4random_uniform((UInt32) allEmojiCharacters.count)];
        if (![emojiSymbolsUsed containsObject:symbol]) {
            [emojiSymbolsUsed addObject:symbol];
        }
    }
    [emojiSymbolsUsed addObjectsFromArray:emojiSymbolsUsed];
    for (int i = 0; i < emojiSymbolsUsed.count; ++i) { //shuffle
        UInt32 j = arc4random_uniform((UInt32) emojiSymbolsUsed.count - i) + i;
        [emojiSymbolsUsed exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    self.cards = [NSArray arrayWithArray:emojiSymbolsUsed];
}

- (void) pressedCard:(NSInteger) atIndex {
    switch (cardStates[atIndex]) {
        case hidden:
            cardStates[atIndex] = shown;
            if ([self checkEnumEquality] == 1) {
                _gameState = secondSelection;
                firstIndex = atIndex;
            } else if ([self checkEnumEquality] == 2) {
                cardStates[atIndex] = shown;
                secondIndex = atIndex;
                _gameState = turnComplete;
            }
            break;
        default:
            break;
    }
}

- (NSInteger) checkEnumEquality {
    switch (_gameState) {
        case firstSelection:
            return 1;
        case secondSelection:
            return 2;
        case turnComplete:
            return 3;
    }
}

- (void) startNewTurn {
    _gameState = firstSelection;
    if (_cards[firstIndex] == _cards[secondIndex]) {
        cardStates[firstIndex] = removed;
        cardStates[secondIndex] = removed;
    } else {
        cardStates[firstIndex] = hidden;
        cardStates[secondIndex] = hidden;
    }
}

- (CardState) getCardState:(NSInteger) atIndex {
    return cardStates[atIndex];
}

-(NSString*) description {
    NSMutableString* toReturn = [[NSMutableString alloc] initWithCapacity: [_cards count]];
    for (int i = 0; i < [_cards count]; i++) {
        if (i % 4 == 3) {
            NSString* toAdd = [NSString stringWithFormat: @"%@\r", _cards[i]];
            [toReturn appendFormat: @"%@", toAdd];
        } else {
            NSString* toAdd = [NSString stringWithFormat:@"%@", _cards[i]];
            [toReturn appendFormat: @"%@", toAdd];
        }
    }
    return toReturn;
}


@end
