//
//  GameSession.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/29/25.
//

import SwiftUI

final class GameSession: ObservableObject {
    @Published var collectedTreasures: [Card] = []
    
    // You can store more session data here, e.g. total gold, party HP, etc.
    
    func addTreasure(_ card: Card) {
        // In case you want special logic, you can do it here
        collectedTreasures.append(card)
    }
}
