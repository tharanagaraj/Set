//
//  SetCard.swift
//  SetGame
//
//  Created by Thara Nagaraj on 10/28/18.
//  Copyright © 2018 Thara Nagaraj. All rights reserved.
//

import Foundation

struct SetCard{
    //MARK : Properties
    private(set) var combination : FeatureCombination
    
    //MARK: Initializers
    init(combination: FeatureCombination){
        self.combination = combination
    }
}

protocol Feature {
    static var values: [Feature] {get}
    static func getNextFeature() -> [Feature]?
}

struct FeatureCombination{
    var number : Number = .none
    var color : Color = .none
    var symbol : Symbol = .none
    var shading : Shading = .none
    
    mutating func add(feature: Feature){
        if feature is Number{
            number = feature as! Number
        } else if feature is Color{
            color = feature as! Color
        } else if feature is Symbol{
            symbol = feature as! Symbol
        }else{
            shading = feature as! Shading
        }
    }
}

enum Number : Int, Feature {
    case one
    case two
    case three
    case none
    
    static var values : [Feature]{
        return [Number.one, Number.two, Number.three]
    }
    
    static func getNextFeature() -> [Feature]? {
        return Color.values
    }
}

enum Symbol: Int, Feature {
    case diamond
    case squiggle
    case oval
    case none
    
    static var values : [Feature]{
        return [Symbol.diamond, Symbol.oval, Symbol.squiggle]
    }
    
    static func getNextFeature() -> [Feature]? {
        return Shading.values
    }
}

enum Color : Int, Feature {
    case red
    case green
    case purple
    case none
    
    static var values : [Feature]{
        return [Color.red, Color.purple, Color.green]
    }
    static func getNextFeature() -> [Feature]? {
        return Symbol.values
    }
}

enum Shading: Int, Feature{
    case striped
    case solid
    case outlined
    case none
    
    static var values: [Feature]{
        return [Shading.outlined, Shading.solid, Shading.striped]
    }
    
    static func getNextFeature() -> [Feature]? {
        return nil
    }
}


extension FeatureCombination : Equatable{
    static func ==(lhs:FeatureCombination, rhs: FeatureCombination) -> Bool{
        return lhs.color == rhs.color && lhs.number == rhs.number &&
        lhs.shading == rhs.shading && lhs.symbol == rhs.symbol
    }
    
}

extension SetCard : Hashable{
    var hashValue : Int{
        return Int("\(combination.number.rawValue)\(combination.color.rawValue)\(combination.shading.rawValue)\(combination.symbol.rawValue)")!
    }
    
    static func==(cardOne: SetCard, cardTwo: SetCard)->Bool{
        return cardOne.combination == cardTwo.combination
    }
}
