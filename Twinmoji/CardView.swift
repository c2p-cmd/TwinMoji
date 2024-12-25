//
//  CardView.swift
//  Twinmoji
//
//  Created by Sharan Thakur on 24/12/24.
//

import SwiftUI

struct CardView: View {
    let card: [String]
    let userCanAnswer: Bool
    let onSelect: (String) -> Void
    
    var rows: Int { card.count == 12 ? 4 : 3 }
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<rows, id: \.self) { i in
                GridRow {
                    ForEach(0..<3, id: \.self) { j in
                        let text = card[i * 3 + j]
                        
                        Button(text) { onSelect(text) }
                    }
                }
            }
        }
        .font(.system(size: 64))
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .fixedSize()
        .shadow(radius: 10)
        .disabled(userCanAnswer == false)
        .transition(.push(from: .top))
        .id(card)
    }
}

#Preview {
    CardView(
        card: GameConstants.level1.emojiList.shuffled(),
        userCanAnswer: true
    ) { _ in }
}
