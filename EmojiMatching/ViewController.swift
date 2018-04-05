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
        print("\n")
        print(game!)
    }
    
    @IBAction func pressedNewGame(_ sender: Any) {
        blockingUIIntentionally = false
        game = MatchingGame(numPairs: 10)
        viewDidLoad()
    }
    
    @IBAction func pressedCard(_ sender: Any) {
        if blockingUIIntentionally {
            return
        }
        let cardButton = sender as! UIButton
        let cardIndex = cardButton.tag
        game?.pressedCard(cardIndex)
        updateView()
        switch game?.gameState {
        case .turnComplete?:
            blockingUIIntentionally = true
            delay(1.2) {
                self.game?.startNewTurn()
                self.blockingUIIntentionally = false
                self.updateView()
            }
        default:
            updateView()
        }
    }
    
    func updateView() {
        for i in 0..<20 {
            switch game?.getCardState(i) {
            case .shown?:
                gameButtons[i].setTitle((game?.cards[i] as! String), for: UIControlState.normal)
            case .hidden?:
                gameButtons[i].setTitle(game?.cardBack, for: UIControlState.normal)
            case .removed?:
                gameButtons[i].setTitle("", for: UIControlState.normal)
            default:
                break
            }
        }
        
        var gameDone: Bool = true
        for j in 0..<20 {
            switch game?.getCardState(j) {
            case .removed?:
                continue
            default:
                gameDone = false //card state is still on screen so still at least one pair left
            }
        }
        if gameDone {
            blockingUIIntentionally = true
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

