//
//  GameData.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/20/25.
//

import SwiftUI

final class GameData {
    static let shared = GameData()

    let corridors: [CorridorCard] = [
        CorridorCard(
            title: "Dusty Hallway",
            description: "Cobwebs drape ... ancient breeze stirs the dust."
        ),
        CorridorCard(
            title: "Flooded Passage",
            description: "Ankle-deep water ripples ..."
        ),
        // etc. for all 10 corridors
    ]

    let rooms: [RoomCard] = [
        RoomCard(title: "Arcane Workshop",
                 description: "Tables cluttered with half-finished potions..."),
        RoomCard(title: "Statue Chamber",
                 description: "Four statues line the walls..."),
        // etc. for 15 rooms
    ]

    //let traps: [TrapCard] = [
        // e.g. TrapCard(title: "Swinging Blades", description: "...", etc.)
   // ]
    
    //let puzzles: [PuzzleCard] = [ /* ... */ ]
    //let treasures: [TreasureCard] = [ /* ... */ ]
    // and so on...
}

