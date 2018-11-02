//
//  SetGame.swift
//  SetGame
//
//  Created by Thara Nagaraj on 10/28/18.
//  Copyright © 2018 Thara Nagaraj. All rights reserved.
//

import Foundation

typealias SetDeck = [SetCard]
typealias SetTrio = [SetCard]


class SetGame{
    //MARK : Properties
    //main deck of cards
    private(set) var deck = SetDeck()
    
    //matched deck of cards
    private(set) var matchedDeck = [SetTrio]()
    
    //cards being displayed currently
    private(set) var tableCards = [SetCard?]()
    
    //cards selected currently
    private(set) var selectedCards = [SetCard]()
    
    //cards matched currently
    private(set) var matchedCards = [SetCard](){
        didSet{
            if matchedCards.count == 3{
                matchedDeck.append(matchedCards)
            }
        }
    }
    
    
    //players score
    //match : +4; wrong match : -2; score can't drop below 0
    private(set) var score = 0 {
        didSet{
            if score < 0 {
                score = 0
            }
        }
    }
    
    //MARK: Initializers
    init(){
        deck = makeDeck()
    }
    
    //MARK: Imperatives
    func selectCard(at index: Int){
        guard let card = tableCards[index] else {return}
        guard !matchedCards.contains(card) else {return}
        
        if matchedCards.count > 0{
            removeMatchedCardsFromTable()
            _ = dealCards()
        }
        
        if selectedCards.count == 3{
            guard !selectedCards.contains(card) else {return}
            if !currentSelectionMatches(){
                score -= 2
            }
            selectedCards = []
        }
        if let index = selectedCards.index(of: card){
            selectedCards.remove(at: index)
        } else{
            selectedCards.append(card)
        }
        
        if selectedCards.count == 3, currentSelectionMatches(){
            matchedCards = selectedCards
            selectedCards = []
            score += 4
        }
    }
    
    private func currentSelectionMatches() -> Bool{
        guard selectedCards.count == 3 else {return false}
        return matches(selectedCards)
    }
    
    
    private func matches(_ selectedCards : SetTrio) -> Bool{
        let first = selectedCards[0]
        let second = selectedCards[1]
        let third = selectedCards[2]
        
        let numberFeatures = Set([first.combination.number, second.combination.number, third.combination.number])
        let colorFeatures = Set([first.combination.color, second.combination.color, third.combination.color])
        let symbolFeatures = Set([first.combination.symbol, second.combination.symbol, third.combination.symbol])
        let shadingFeatures = Set([first.combination.shading, second.combination.shading, third.combination.shading])
        
        return (numberFeatures.count == 1 || numberFeatures.count == 3) &&
        (shadingFeatures.count == 1 || shadingFeatures.count == 3) &&
        (symbolFeatures.count == 1 || symbolFeatures.count == 3) &&
        (colorFeatures.count == 1 || colorFeatures.count == 3)
    }
    
    
    
    func removeMatchedCardsFromTable(){
        guard matchedCards.count == 3 else {return}
        for index in tableCards.indices{
            if let card = tableCards[index], matchedCards.contains(card){
                tableCards[index] = nil
            }
        }
        matchedCards = []
    }
    
    
    func dealCards(cards numberOfCards :Int = 3) -> [SetCard]{
        guard numberOfCards > 0 else{return []}
        guard deck.count >= numberOfCards else {return []}
        
        var cardsToDeal = [SetCard]()
        for _ in 0..<numberOfCards{
            cardsToDeal.append(deck.removeFirst())
        }
        
        for (index, card) in tableCards.enumerated() {
            if card == nil {
                tableCards[index] = cardsToDeal.removeFirst()
            }
        }
        
        if !cardsToDeal.isEmpty {
            tableCards += cardsToDeal as [SetCard?]
        }
        return cardsToDeal
    }
    
    func reset(){
        deck = makeDeck()
        matchedCards = []
        tableCards = []
        selectedCards = []
        matchedDeck = []
        score = 0
    }
    
    
    
    private func makeDeck(features: [Feature] = Number.values,
                          currentCombination: FeatureCombination = FeatureCombination(),
                          deck: SetDeck = SetDeck()) -> SetDeck{
        
        var deck = deck
        var currentCombination = currentCombination
        
        let nextFeatures = type(of: features[0]).getNextFeature()
        
        for feature in features{
            currentCombination.add(feature: feature)
            
            if let nextFeatures = nextFeatures{
                deck = makeDeck(features: nextFeatures, currentCombination: currentCombination , deck: deck)
            } else{
                deck.append(SetCard(combination: currentCombination))
            }
        }
        
        return deck.shuffled()
        
    }
}
