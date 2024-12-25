//
//  MenuView.swift
//  Twinmoji
//
//  Created by Sharan Thakur on 24/12/24.
//

import SwiftUI

struct MenuView: View {
    @Binding var gameStarted: Bool
    @Binding var gameDifficulty: GameDifficulty
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Grid Rivals!")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .fontDesign(.rounded)
            
            Text("Select a difficulty")
                .font(.title)
                .fontWeight(.semibold)
            
            Rectangle()
                .frame(height: 1)
            
            HStack(alignment: .top) {
                difficultyInfo("Easy", difficulty: .easy, alignment: .center)
                
                divider
                
                difficultyInfo("Medium", difficulty: .medium, alignment: .center)
                
                divider
                
                difficultyInfo("Hard", difficulty: .hard, alignment: .center)
            }
            
            Rectangle()
                .frame(height: 1)
            
            Button("Start Game", systemImage: "play.circle") { gameStarted = true }
                .symbolEffect(.bounce, value: gameStarted)
                .font(.headline)
                .fontDesign(.rounded)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    @ViewBuilder
    func difficultyInfo(
        _ title: String,
        difficulty: GameDifficulty,
        alignment: HorizontalAlignment
    ) -> some View {
        VStack(alignment: alignment, spacing: 5) {
            Text("\(title) Settings")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 10)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(height: 1)
                }
            
            Spacer()
            
            Text("Time to answer")
                .font(.title3)
                .bold()
            
            Text("\(difficulty.answerTimeOut, format: .number) seconds")
                .font(.headline)
            
            Spacer()
            
            Text("Number of symbols:")
                .font(.title3)
                .bold()
            
            Text("\(difficulty.itemCount, format: .number)")
                .font(.headline)
            
            Spacer()
        }
        .padding()
        .background(gameDifficulty == difficulty ? Color(white: 0.9) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .transition(.slide)
        .id(difficulty)
        .onTapGesture {
            withAnimation {
                gameDifficulty = difficulty
            }
        }
    }
    
    @ViewBuilder
    var divider: some View {
        Spacer()
        Rectangle()
            .fill(.secondary)
            .frame(width: 1.5)
        Spacer()
    }
}

#Preview {
    ContentView()
}
