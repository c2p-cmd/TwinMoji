//
//  GameView.swift
//  Twinmoji
//
//  Created by Sharan Thakur on 24/12/24.
//

import SwiftUI

struct GameView: View {
    @State private var vm: ViewModel
    
    init(itemCount: Int, answerTime: TimeInterval, isGameActive: Binding<Bool>) {
        self._vm = State(
            initialValue: ViewModel(
                itemCount: itemCount,
                answerTime: answerTime,
                isGameActive: isGameActive
            )
        )
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 0) {
                PlayerButton(
                    gameState: vm.gameState,
                    score: vm.player1Score,
                    color: .blue,
                    action: vm.selectPlayer1
                )
                
                ZStack {
                    vm.answerColor
                        .scaleEffect(x: vm.answerScale, anchor: vm.answerAnchor)
                    
                    if vm.leftCard.isEmpty {
                        ProgressView()
                    } else {
                        cards
                    }
                }
                
                PlayerButton(
                    gameState: vm.gameState,
                    score: vm.player2Score,
                    color: .red,
                    action: vm.selectPlayer2
                )
            }
            
            Button("End Game", systemImage: "xmark.circle") {
                vm.isGameActive.wrappedValue = false
            }
            .symbolVariant(.fill)
            .font(.largeTitle)
            .labelStyle(.iconOnly)
            .tint(.white)
            .padding(40)
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.9))
        .onAppear(perform: vm.createLevel)
        .alert("Game Over!", isPresented: $vm.playerHasWon) {
            Button("Play Again") {
                vm.player1Score = 0
                vm.player2Score = 0
                vm.isGameActive.wrappedValue = false
            }
        } message: {
            Text("Player \(vm.player1Score > vm.player2Score ? 1 : 2) has won!")
            let winner = vm.player1Score > vm.player2Score ? vm.player1Score : vm.player2Score
            let loser = vm.player1Score < vm.player2Score ? vm.player1Score : vm.player2Score
            Text("Final Score: **\(winner)** - **\(loser)**")
        }
    }
    
    var cards: some View {
        HStack {
            CardView(
                card: vm.leftCard,
                userCanAnswer: vm.gameState == .player1Answering,
                onSelect: vm.checkAnswer(_:)
            )
            .phaseAnimator([0, -0.5, -1.0, 1.0, -0.5, 0.5, 0], trigger: vm.penalizePlayer1Trigger) { content, phase in
                content.offset(x: phase * 10)
            } animation: { _ in
                Animation.spring(duration: 0.1, bounce: 0.6)
            }
            
            CardView(
                card: vm.rightCard,
                userCanAnswer: vm.gameState == .player2Answering,
                onSelect: vm.checkAnswer(_:)
            )
            .phaseAnimator([0, -1.0, 1.0, -0.5, 0.5, 0], trigger: vm.penalizePlayer2Trigger) { content, phase in
                content.offset(x: phase * 10)
            } animation: { _ in
                Animation.spring(duration: 0.1, bounce: 0.6)
            }
        }
        .padding(.horizontal, 10)
    }
}

extension GameView {
    @Observable
    final class ViewModel {
        let itemCount: Int
        let answerTime: TimeInterval
        
        init(itemCount: Int, answerTime: TimeInterval, isGameActive: Binding<Bool>) {
            self.itemCount = itemCount
            self.answerTime = answerTime
            self.isGameActive = isGameActive
        }
        
        var isGameActive: Binding<Bool>
        var currentEmoji: [String] = []
        
        var leftCard: [String] = []
        var rightCard: [String] = []
        
        var gameState: GameState = .waiting
        
        var player1Score = 0
        var player2Score = 0
        
        var penalizePlayer1Trigger = 0
        var penalizePlayer2Trigger = 0
        
        var answerColor: Color = .clear
        var answerScale: CGFloat = 1
        var answerAnchor: UnitPoint = .center
        
        var playerHasWon = false
        
        func penalizePlayer1() {
            withAnimation(.bouncy) {
                player1Score -= 1
                penalizePlayer1Trigger += 1
            }
        }
        
        func penalizePlayer2() {
            withAnimation(.smooth) {
                player2Score -= 1
                penalizePlayer2Trigger += 1
            }
        }
        
        func createLevel() {
            currentEmoji = GameConstants.level1.emojiList.shuffled()
            
            withAnimation(.spring(duration: 0.75)) {
                leftCard = Array(currentEmoji[0 ..< itemCount])//.shuffled()
                rightCard = Array(currentEmoji[itemCount+1 ..< itemCount+itemCount] + [currentEmoji[0]])//.shuffled()
            }
        }
        
        func selectPlayer1() {
            guard gameState == .waiting else { return }
            
            answerColor = .blue
            answerAnchor = .leading
            gameState = .player1Answering
            
            runClock()
        }
        
        func selectPlayer2() {
            guard gameState == .waiting else { return }
            
            answerColor = .red
            answerAnchor = .trailing
            gameState = .player2Answering
            
            runClock()
        }
        
        func timeOut(for emoji: [String]) {
            guard emoji == currentEmoji else { return }
            
            switch gameState {
            case .player1Answering:
                penalizePlayer1()
            case .player2Answering:
                penalizePlayer2()
            default:
                break
            }
            
            gameState = .waiting
        }
        
        func runClock() {
            let currentEmoji = self.currentEmoji
            answerScale = 1
            
            withAnimation(.linear(duration: answerTime)) {
                answerScale = 0
            } completion: {
                self.timeOut(for: currentEmoji)
            }
        }
        
        func checkAnswer(_ text: String) {
            if text == currentEmoji[0] {
                switch gameState {
                case .player1Answering:
                    player1Score += 1
                case .player2Answering:
                    player2Score += 1
                default:
                    break
                }
                
                if player1Score == 5 || player2Score == 5 {
                    playerHasWon = true
                } else {
                    createLevel()
                }
            } else {
                switch gameState {
                case .player1Answering:
                    penalizePlayer1()
                case .player2Answering:
                    penalizePlayer2()
                default:
                    break
                }
            }
            
            answerColor = .clear
            answerScale = 0
            gameState = .waiting
        }
    }
}

#Preview {
    ContentView()
}
