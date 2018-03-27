//
//  MatchingGame.swift
//  EmojiMatching
//
//  Created by CSSE Department on 3/27/18.
//  Copyright © 2018 Praneet CSSE484. All rights reserved.
//

import Foundation

/* ------ Code snippet #1 --------- */
// Helper method to randomize the order of an Array. See usage later.  Copied from:
// http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            self.swapAt(i, j)
        }
    }
}

class MatchingGame: CustomStringConvertible {
    
    enum CardState: String {
        case hidden = "Hidden"
        case shown = "Shown"
        case removed = "Removed"
    }
    
    enum GameState {
        case firstSelection
        case secondSelection(Int)
        case turnComplete(Int, Int)
        
        func simpleDescription() -> String {
            switch self {
            case .firstSelection:
                return "Waiting on first selection"
            case .secondSelection(let firstClick):
                return "Waiting on second selection: first click = \(firstClick)"
            case .turnComplete(let firstClick, let secondClick):
                return "Turn complete: first click = \(firstClick) second click = \(secondClick)"
            }
        }
    }
    
    let allCardBacks = Array("🎆🎇🌈🌅🌇🌉🌃🌄⛺⛲🚢🌌🌋🗽")
    let allEmojiCharacters = Array("🚁🐴🐇🐢🐱🐌🐒🐞🐫🐠🐬🐩🐶🐰🐼⛄🌸⛅🐸🐳❄❤🐝🌺🌼🌽🍌🍎🍡🏡🌻🍉🍒🍦👠🐧👛🐛🐘🐨😃🐻🐹🐲🐊🐙")
    
    var cards: [Character]
    var cardBack: Character
    var gameState: GameState
    var cardStates: [CardState]
    var firstIndex: Int
    var secondIndex: Int
    
    init(numPairs: Int) {
        self.cards = [Character]()
        self.gameState = .firstSelection
        self.cardStates = [CardState](repeating: .hidden, count: numPairs*2)
        let index = Int(arc4random_uniform(UInt32(allCardBacks.count)))
        self.cardBack = allCardBacks[index]
        self.firstIndex = -1
        self.secondIndex = -1
        newGame(numPairs: numPairs)
    }
    
    var description: String {
        var toReturn: String = ""
        for i in 0..<cards.count {
            if i % 4 == 3 {
                toReturn += "\(cards[i]) \n"
            } else {
                toReturn += "\(cards[i])"
            }
        }
        return toReturn
    }
    
    func newGame(numPairs: Int){
        var emojiSymbolsUsed = [Character]()
        
        while emojiSymbolsUsed.count < numPairs {
            let index = Int(arc4random_uniform(UInt32(allEmojiCharacters.count)))
            let symbol = allEmojiCharacters[index]
            if !emojiSymbolsUsed.contains(symbol) {
                emojiSymbolsUsed.append(symbol)
            }
        }
        cards = emojiSymbolsUsed + emojiSymbolsUsed //need two of each card for matches
        cards.shuffle()
    }
    
    func pressedCard(atIndex: Int) {
        cardStates[atIndex] = .shown
        if checkEnumEquality() == 1 { //gameState is first turn
            gameState = .secondSelection(atIndex)
            firstIndex = atIndex
        } else if checkEnumEquality() == 2 { //gameState is second turn
            cardStates[atIndex] = .shown
            secondIndex = atIndex
            gameState = .turnComplete(firstIndex, secondIndex)
        }
    }
    
    func checkEnumEquality() -> Int {
        switch gameState {
        case .firstSelection:
            return 1
        case .secondSelection:
            return 2
        case .turnComplete:
            return 3
        }
    }
    
    func startNewTurn() {
        gameState = .firstSelection
        if cards[firstIndex] == cards[secondIndex] {
            cardStates[firstIndex] = .removed
            cardStates[secondIndex] = .removed
        } else {
            cardStates[firstIndex] = .hidden
            cardStates[secondIndex] = .hidden
        }
    }
    
}
