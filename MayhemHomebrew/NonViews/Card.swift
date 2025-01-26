//
//  Card.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/20/25.
//

import SwiftUI

import SwiftUI

enum CardType {
    case corridor
    case room
    case trap
    case puzzle
    case treasure
    case enemy
    // etc.
}

protocol Card {
    var id: UUID { get }
    var title: String { get }
    var description: String { get }
    var cardType: CardType { get }
    var imageName: String? { get }
}

// CorridorCard
struct CorridorCard: Card {
    let id = UUID()
    let title: String
    let description: String
    let cardType: CardType = .corridor
    let imageName: String?
}

// RoomCard
struct RoomCard: Card {
    let id = UUID()
    let title: String
    let description: String
    let cardType: CardType = .room
    let imageName: String?
}

struct SimpleTreasureCard: Card {
    let id = UUID()
    let title: String
    // Provide a place to store the item’s rarity
    let rarity: String
    // The final text for whichever difficulty the player rolled:
    let difficultyText: String
    
    let cardType: CardType = .treasure
    let imageName: String?
    
    // Now the `description` can combine both
    var description: String {
        "\(rarity)\n\n\(difficultyText)"
    }
}

struct SimpleTrapCard: Card {
    let id = UUID()
    let title: String
    let difficultyText: String
    let cardType: CardType = .trap
    let imageName: String?
    
    var description: String {
        "\(difficultyText)"
    }
}


//struct SimpleTreasureCard: Card {
//    let id = UUID()
//    let title: String
//    let description: String
//    let cardType: CardType = .treasure
//}

// TrapCard
//struct TrapCard: Card {
//    let id = UUID()
//    let title: String
//    /// We'll store easy/medium/hard in one combined description or separate properties.
//    /// For now, let's just store them in a single multiline string for "description".
//    let description: String
//    let cardType: CardType = .trap
//}

// PuzzleCard
struct PuzzleCard: Card {
    let id = UUID()
    let title: String
    let description: String
    let cardType: CardType = .puzzle
    let imageName: String?
}

// TreasureCard
//struct TreasureCard: Card {
//    let id = UUID()
//    let title: String
//    let description: String
//    let cardType: CardType = .treasure
//}

struct EnemyCard: Card {
    let id = UUID()
    let title: String
    let description: String
    let cardType: CardType = .enemy
    let imageName: String?
}
