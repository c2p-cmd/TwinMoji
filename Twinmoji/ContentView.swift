//
//  ContentView.swift
//  Twinmoji
//
//  Created by Sharan Thakur on 24/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var gameStarted = false
    @State private var gameDifficulty: GameDifficulty = .medium
    
    var body: some View {
        if gameStarted {
            GameView(
                itemCount: gameDifficulty.itemCount,
                answerTime: gameDifficulty.answerTimeOut,
                isGameActive: $gameStarted
            )
            .persistentSystemOverlays(.hidden)
            .defersSystemGestures(on: .bottom)
        } else {
            MenuView(gameStarted: $gameStarted, gameDifficulty: $gameDifficulty)
        }
    }
}

#Preview {
    ContentView()
}
