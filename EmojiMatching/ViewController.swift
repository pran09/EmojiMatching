//
//  ViewController.swift
//  EmojiMatching
//
//  Created by CSSE Department on 3/25/18.
//  Copyright © 2018 Praneet CSSE484. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var blockingUIIntentionally = false
    var game = MatchingGame(numPairs: 10)
    @IBOutlet var gameButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    @IBAction func pressedNewGame(_ sender: Any) {
        game = MatchingGame(numPairs: 10)
        updateView()
    }
    
    @IBAction func pressedCard(_ sender: Any) {
        if blockingUIIntentionally {
            return
        }
        let cardButton = sender as! UIButton
        let cardIndex = cardButton.tag
        switch game.gameState {
        case .turnComplete:
            blockingUIIntentionally = true
            delay(1.2) {
                self.game.startNewTurn()
                self.blockingUIIntentionally = false
                self.updateView()
            }
        default:
            game.pressedCard(atIndex: cardIndex)
            updateView()
        }
    }
    
    func updateView() {
        for i in 0..<game.cardStates.count {
            switch game.cardStates[i] {
            case .shown:
                gameButtons[i].setTitle(String(game.cards[i]), for: UIControlState.normal)
            case .hidden:
                gameButtons[i].setTitle(String(game.cardBack), for: UIControlState.normal)
            case .removed:
                gameButtons[i].setTitle("", for: UIControlState.normal)
            }
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

