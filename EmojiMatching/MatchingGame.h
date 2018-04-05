//
//  MatchingGame.h
//  EmojiMatching
//
//  Created by Praneet Chakraborty on 4/4/18.
//  Copyright © 2018 Praneet CSSE484. All rights reserved.
//

#import <Foundation/Foundation.h>
#define cardStateSize 20

typedef NS_ENUM(NSInteger, GameState){
    
    firstSelection, secondSelection, turnComplete

};

typedef NS_ENUM(NSInteger, CardState){
  
    hidden, shown, removed
    
};

@interface MatchingGame : NSObject {
    NSInteger firstIndex;
    NSInteger secondIndex;
    CardState cardStates[cardStateSize];
}

@property (nonatomic) NSArray* cards;
@property (nonatomic) NSInteger numPairs;
@property (nonatomic) NSString* cardBack;
@property (nonatomic) GameState gameState;


- (id) initWithNumPairs:(NSInteger) numPairs;
- (void) newGame:(NSInteger) numPairs;
- (void) pressedCard:(NSInteger) atIndex;
- (NSInteger) checkEnumEquality;
- (void) startNewTurn;
- (CardState) getCardState:(NSInteger) atIndex;
-(NSString*) description;

@end
