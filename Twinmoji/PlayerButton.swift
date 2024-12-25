//
//  PlayerButton.swift
//  Twinmoji
//
//  Created by Sharan Thakur on 24/12/24.
//

import SwiftUI

struct PlayerButton: View {
    let gameState: GameState
    let score: Int
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Rectangle()
                .fill(color)
                .frame(minWidth: 60)
                .overlay(alignment: .center) {
                    Text(score.description)
                        .fixedSize()
                        .foregroundStyle(.white)
                        .font(.system(size: 48).bold())
                        .contentTransition(.numericText())
                }
        }
        .disabled(gameState != .waiting)
    }
}

#Preview {
    PlayerButton(
        gameState: .player1Answering,
        score: 0,
        color: .blue,
        action: {}
    )
}
