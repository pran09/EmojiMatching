 //
//  MatchingGame.swift
//  Emoji Matching Exam
//
//  Code snippets and free hints


import Foundation

// Here are the card backs and emoji symbols you shoud use.
let allCardBacks = Array("🎆🎇🌈🌅🌇🌉🌃🌄⛺⛲🚢🌌🌋🗽")
let allEmojiCharacters = Array("🚁🐴🐇🐢🐱🐌🐒🐞🐫🐠🐬🐩🐶🐰🐼⛄🌸⛅🐸🐳❄❤🐝🌺🌼🌽🍌🍎🍡🏡🌻🍉🍒🍦👠🐧👛🐛🐘🐨😃🐻🐹🐲🐊🐙")


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

/* ------ Code snippet #2 --------- */
// Helper method to create a time delay. Copied from:
// http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861
// See answer with most votes for usage examples (VERY easy) delay(1.2) { ... }
// Copy this snippet to your ViewController file (not realy useful in the model).
// This is *one* way to solve the 1.2 second delay requirement.
func delay(_ delay:Double, closure:@escaping ()->()) {
  let when = DispatchTime.now() + delay
  DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

/* ------ Code snippet #3 --------- */
// Examples of getting random cards from the emoji symbol array (could go into init)
var cards : [Character]
var cardBack : Character

// Randomly select emojiSymbols
var emojiSymbolsUsed = [Character]()
while emojiSymbolsUsed.count < 4 {
  let index = Int(arc4random_uniform(UInt32(allEmojiCharacters.count)))
  let symbol = allEmojiCharacters[index]
  if !emojiSymbolsUsed.contains(symbol) {
    emojiSymbolsUsed.append(symbol)
  }
}
cards = emojiSymbolsUsed + emojiSymbolsUsed //need two of each card for matches
cards.shuffle()

// Randomly select a card back for this round
var index = Int(arc4random_uniform(UInt32(allCardBacks.count)))
cardBack = allCardBacks[index]

 
 
 
 // My personal Playground Code
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
 

// ------------------------------------------------
//  Completely optional test code if you choose to
//  use a Playground to develop the model object.
// ------------------------------------------------

//// Real game to see random values
var game = MatchingGame(numPairs: 10)
game.cards
game.cards[0]
game.cardStates
game.cardStates[0].rawValue
game.cardBack
game.gameState.simpleDescription()
game.description

// Playing with non-random cards (better for testing)
game.cards = Array("01234567890123456789")

// Making a match
game.cards[2]
game.cards[12]
game.cardStates[2].rawValue
game.cardStates[12].rawValue
game.gameState.simpleDescription()
game.pressedCard(atIndex: 2)
game.cardStates[2].rawValue
game.cardStates[12].rawValue
game.gameState.simpleDescription()
game.pressedCard(atIndex: 12)
game.cardStates[2].rawValue
game.cardStates[12].rawValue
game.gameState.simpleDescription()
game.startNewTurn()
game.cardStates[2].rawValue
game.cardStates[12].rawValue
game.gameState.simpleDescription()

// Non-match
game.cards[1]
game.cards[15]
game.cardStates[1].rawValue
game.cardStates[15].rawValue
game.gameState.simpleDescription()
game.pressedCard(atIndex: 1)
game.cardStates[1].rawValue
game.cardStates[15].rawValue
game.gameState.simpleDescription()
game.pressedCard(atIndex: 15)
game.cardStates[1].rawValue
game.cardStates[15].rawValue
game.gameState.simpleDescription()
game.startNewTurn()
game.cardStates[1].rawValue
game.cardStates[15].rawValue
game.gameState.simpleDescription()
