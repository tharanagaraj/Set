//
//  ViewController.swift
//  SetGame
//
//  Created by Thara Nagaraj on 10/28/18.
//  Copyright © 2018 Thara Nagaraj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //MARK: Properties
    
    private var setGame = SetGame()
    @IBOutlet var cardButtons: [UIButton]!{
        didSet{
            _ = setGame.dealCards(cards: 12)
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var matchedLabel: UILabel!
    
    @IBOutlet weak var dealMore: UIButton!
    
    @IBOutlet weak var newGame: UIButton!
    
    private let symbolToText : [Symbol : String] = [
        .squiggle : "■",
        .oval : "●",
        .diamond : "▲"
    ]
    
    private let colorToText: [Color : UIColor] = [
        .red : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),
        .purple : #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1),
        .green : #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
    ]
    
    //MARK: Lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayCards()
    }
    
    
    //MARK: Imperatives
    private func displayCards(){
        //reset cards to original state
        
        for cardButton in cardButtons{
            cardButton.alpha = 0
            cardButton.setAttributedTitle(nil, for:.normal)
            cardButton.setTitle(nil, for: .normal)
        }
        
        setGame.tableCards.enumerated().forEach{[unowned self](index, card) in
            let cardButton = self.cardButtons[index]
            if let card = card {
                cardButton.alpha = 1
                cardButton.setAttributedTitle(self.getAttributedText(forCard: card)!, for: .normal)
                
                // if card is selected, put a border on it.
                if self.setGame.selectedCards.contains(card){
                    cardButton.layer.borderColor = UIColor.blue.cgColor
                    cardButton.layer.borderWidth = 3
                    cardButton.layer.cornerRadius = 8
                } else {
                    cardButton.layer.cornerRadius = 0
                    cardButton.layer.borderWidth = 0
                }
                
                if self.setGame.matchedCards.contains(card){
                    cardButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                } else {
                    cardButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
            } else {
                cardButton.alpha = 0
            }
        }
        scoreLabel.text = "Score: \(setGame.score)"
        matchedLabel.text = "Matches : \(setGame.matchedDeck.count)"
        handleDealMoreButton()
    }
    
    
    private func getAttributedText(forCard card: SetCard) -> NSAttributedString?{
        guard card.combination.color != .none else {return nil}
        guard card.combination.number != .none else {return nil}
        guard card.combination.shading != .none else {return nil}
        guard card.combination.symbol != .none else {return nil}
        
        let number = card.combination.number
        let symbol = card.combination.symbol
        let color = card.combination.color
        let shading = card.combination.shading
        
        if let symbolChar = symbolToText[symbol]{
            let cardText = String(repeating: symbolChar, count: number.rawValue + 1)
            var attributes = [NSAttributedString.Key : Any]()
            let cardColor = colorToText[color]!
            switch shading{
            case .outlined :
                attributes[NSAttributedString.Key.strokeWidth] = 10
                fallthrough
            case .solid:
                attributes[NSAttributedString.Key.foregroundColor] = cardColor
            case .striped:
                attributes[NSAttributedString.Key.foregroundColor] = cardColor.withAlphaComponent(0.3)
            default:
                break
            }
            
            let attributedText = NSAttributedString(string: cardText, attributes: attributes)
            return attributedText
            
        } else {return nil}
        
    }
    
    /// Checks if it's possible to deal more cards and
    /// enables or disables the deal more button accordingly.
    private func handleDealMoreButton(){
        if setGame.deck.count > 3,
            setGame.tableCards.count < cardButtons.count || setGame.matchedCards.count > 0{
            dealMore.isEnabled = true
        } else {
            dealMore.isEnabled = false
        }
    }
    
    @IBAction func didTapDealMore(_ sender: UIButton) {
        if setGame.matchedCards.count > 0{
            setGame.removeMatchedCardsFromTable()
        }
        _ = setGame.dealCards()
        displayCards()
    }
    
    @IBAction func didTapNewGame(_ sender: UIButton) {
        setGame.reset()
        _ = setGame.dealCards(cards: 12)
        displayCards()
    }
    @IBAction func didTapCard(_ sender: UIButton) {
        guard let index = cardButtons.index(of : sender) else {return}
        guard let _ = setGame.tableCards[index] else {return}
        setGame.selectCard(at: index)
        displayCards()
    }
    
}

