//
//  DungeonSection.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/21/25.
//

import SwiftUI

// The container for each "section" of the dungeon
struct DungeonSection {
    let corridor: CorridorCard
    let room: RoomCard
    let outcome: EncounterOutcome
}

// This references GameData.shared:
func generateDungeonSections(count: Int, difficulty: Difficulty) -> [DungeonSection] {
    var sections: [DungeonSection] = []
    
    for _ in 0..<count {
        let randomCorridor = GameData.shared.corridors.randomElement()!
        let randomRoom = GameData.shared.rooms.randomElement()!
        
        let outcome: EncounterOutcome
        switch difficulty {
        case .easy:
            outcome = getEasyEncounterOutcome()
        case .medium:
            outcome = getMediumEncounterOutcome()
        case .hard:
            outcome = getHardEncounterOutcome()
        }
        
        sections.append(DungeonSection(
            corridor: randomCorridor,
            room: randomRoom,
            outcome: outcome
        ))
    }
    
    return sections
}
