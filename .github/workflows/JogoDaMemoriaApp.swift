//
//  JogoDaMemoriaApp.swift
//  JogoDaMemoria
//
//  Created by Douglas Bridi Rosa on 19/07/21.
//

import SwiftUI

@main
struct JogoDaMemoriaApp: App {
    private let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
