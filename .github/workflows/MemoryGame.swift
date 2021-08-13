//
//  MemoryGame.swift
//  JogoDaMemoria
//
//  Created by Douglas Bridi Rosa on 21/07/21.
//

// essa é o MODEL

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFacedUpCard: Int?{
        get{ cards.indices.filter{cards[$0].isFaceUp}.oneAndOnly }
        set{ cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue) } }
        /* Original abaixo
        get{
            var faceUpCardIndices = [Int]()
            for index in cards.indices{
                if cards[index].isFaceUp{
                    faceUpCardIndices.append(index)
                }
            }
            if faceUpCardIndices.count == 1{
                return faceUpCardIndices.first
            } else{
                return nil
            }
        }
        set{
            for index in cards.indices {
                if index != newValue {
                    cards[index].isFaceUp = false
                } else{
                    cards[index].isFaceUp = true
                }
            }
        }*/
    }
    private(set) var score = 0
    
    mutating func choose (_ card: Card){
                
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) ,
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFacedUpCard {
                cards[chosenIndex].hasBeenSeenThisManyTimes += 1
                cards[potentialMatchIndex].hasBeenSeenThisManyTimes += 1
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    // match
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else if cards[chosenIndex].hasBeenSeenThisManyTimes > 1 ||
                            cards[potentialMatchIndex].hasBeenSeenThisManyTimes > 1 {
                    // mismatch
                     score -= 1
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFacedUpCard = chosenIndex
            }
            
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
//        cards = Array<Card>()
        cards = []

        //adiciona numberOfPairsOfCars x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards=cards.shuffled()
    }
    
    struct Card: Identifiable {
//        var isFaceUp: Bool = false
//        var isMatched: Bool = false
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        let id: Int
        var hasBeenSeenThisManyTimes: Int = 0
    }
}

extension Array{
    var  oneAndOnly: Element?{
        if self.count == 1{
            return self.first
        } else{
            return nil
        }
    }
    
}
