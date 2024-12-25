//
//  Constants.swift
//  Twinmoji
//
//  Created by Sharan Thakur on 24/12/24.
//

import Foundation

enum GameConstants: String {
    case level1 = "😎🥹🥰😔😂😳🧐🙂😇😅😆😙😬🙃😍🥸😣😶🙄🤨😩😉🥲😋😛🤓😏😭😯😵😐😘😢😠"
    
    var emojiList: [String] {
        Array(rawValue).map(String.init)
    }
}

enum GameDifficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var itemCount: Int {
        switch self {
        case .easy:
            9
        default:
            12
        }
    }
    
    var answerTimeOut: Double {
        switch self {
        case .easy:
            3.0
        case .medium:
            2.0
        case .hard:
            1.0
        }
    }
}

enum GameState: Int, CustomStringConvertible {
    case waiting = -1
    case player1Answering = 1
    case player2Answering = 2
    
    var description: String {
        switch self {
        case .waiting:
            "Waiting"
        case .player1Answering:
            "Player 1 Answering"
        case .player2Answering:
            "Player 2 Answering"
        }
    }
}
