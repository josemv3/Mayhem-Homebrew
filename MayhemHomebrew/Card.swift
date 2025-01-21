//
//  Card.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/20/25.
//

import SwiftUI

protocol Card {
    var id: UUID { get }
    var title: String { get }
    var description: String { get }
    var cardType: CardType { get }
    // E.g. .corridor, .room, .trap, .puzzle, .treasure, etc.
}

enum CardType {
    case corridor
    case room
    case trap
    case puzzle
    case treasure
    case enemy
    // etc.
}

struct CorridorCard: Card {
    let id = UUID()
    let title: String
    let description: String
    let cardType: CardType = .corridor
    // Any corridor-specific properties…
}

struct RoomCard: Card {
    let id = UUID()
    let title: String
    let description: String
    let cardType: CardType = .room
    // Any room-specific properties…
}

// Similarly for TrapCard, PuzzleCard, TreasureCard, etc.

