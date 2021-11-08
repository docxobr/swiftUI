//
//  EmojiMemoryGame.swift
//  JogoDaMemoria
//
//  Created by Douglas Bridi Rosa on 21/07/21.
//

// essa é a VIEWMODEL


import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = [
        "🚗","🚕","🚑","🛻",
        "🚙","🚌","🚎","🏎",
        "🚓","🚒","🚐","🚚",
        "🚛","🚜","🛵","🏍",
        "🛺","🚔","✈️","🛩",
        "🚀","🚁","⛵️","🚃",
    ].shuffled()
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 8) { pairIndex in
            EmojiMemoryGame.emojis[pairIndex]
    
        }
    }
        
//    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    @Published private var model = createMemoryGame()

    
    var cards: Array<Card>{
        model.cards
    }
    
    // MARK: -Intents
    
    func choose(_ card: Card){
        model.choose(card)        
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func startNewGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
    
    var score: Int {
            return model.score
    }
    
    func restart () {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
