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
        
    @State private var dealt = Set<Int>()
    
    @Namespace private var dealingNamespace
    
    private func deal(_ card: EmojiMemoryGame.Card){
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool{
        return !dealt.contains(card.id)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            cardView(for: card)
        })
        .foregroundColor(Color(red: 0, green: 0.5, blue: 0.8, opacity: 1.0))
    }
    
//    var body: some View {
//        VStack{
//            gameBody
//            deckBody
//            HStack {
//                shuffle
//                Spacer()
//                restart
//            }
//            .padding()
//        }
//     }
    
    var body: some View {
        ZStack(alignment: .bottom){
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                Text("Jogo da Memória")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Spacer()
                Text("Pontos: \(game.score)")
                    .foregroundColor(.white)
                Spacer()
                gameBody
                .padding(.horizontal)
                Spacer()
                HStack{
                    shuffle
                    Spacer()
                    restart
                }
                .padding()
            }
            deckBody
        }
    }
    
    private func dealAnimation (for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}){
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }

    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
        } else {
            CardView(card: card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .padding(4)
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                .zIndex(zIndex(of: card))
                .onTapGesture{
                    withAnimation(.easeInOut(duration: 1)) {
                        game.choose(card)
                    }
                }
        }
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id}) ?? 0)
    }
    

    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            for card in game.cards {
                withAnimation (dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.blue
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
    
    var shuffle: some View {
        Button {
            withAnimation(.easeInOut(duration: 1)) {
                game.shuffle()
            }
        } label: {Image(systemName: "shuffle")
            .foregroundColor(.white)
            .padding(6)
            .background(Color.green)
            .cornerRadius(10)
        }
    }
    
    var restart: some View {
        Button {
            withAnimation(.easeInOut(duration: 1)) {
                dealt = []
                game.restart()
            }
        } label: { Image(systemName: "playpause.fill")
            .foregroundColor(.white)
            .padding(7)
            .background(Color.red)
            .cornerRadius(10)
        }
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear{
                                animatedBonusRemaining=card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)){
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                    .padding(5)
                    .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360: 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
           }
            //.modifier(Cardify(isFaceUp: card.isFaceUp))
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 30
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
       return  EmojiMemoryGameView(game: game)
    }
}
