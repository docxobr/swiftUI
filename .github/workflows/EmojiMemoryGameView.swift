//
//  EmojiMemoryGameView.swift
//  JogoDaMemoria
//
//  Created by Douglas Bridi Rosa on 19/07/21.
//

// essa é a VIEW

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
            
    var NovoJogo: some View {
        VStack{
            Button {
                game.startNewGame()
            } label: {Text("Novo Jogo")
                .foregroundColor(.white)
                .padding(.all)
                .background(Color.blue)
                .cornerRadius(10)
            }
            Text("Pontos: \(game.score)")
        }
    }
    
    var body: some View {
        VStack{
            Text("Jogo da Memória")
                .font(.largeTitle)
            Spacer()
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]){
                    ForEach(game.cards) { card in
                        CardView(card: card)
                                .aspectRatio(2/3, contentMode: .fit)
                                .onTapGesture{
                                    game.choose(card)
                                }
                    }
                }
            }
            .foregroundColor(Color(red: 0, green: 0.5, blue: 0.8, opacity: 1.0))
            .padding(.horizontal)
            Spacer()
            NovoJogo
        }
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
               
               if card.isFaceUp {
                   shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                Text(card.content).font(font(in: geometry.size))
               } else if card.isMatched{
                   shape.opacity(0)
               }
               else {
                   shape.fill()
               }
           }
        })
    }
    
    private func font(in size: CGSize) ->Font {
        Font.system(size: min(size.width, size.height)*DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.8
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}
