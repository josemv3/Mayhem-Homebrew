//
//  DungeonSection.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/21/25.
//

import SwiftUI

struct DungeonSection {
    let corridor: CorridorCard
    let room: RoomCard
    let outcome: RoomOutcome
}

func generateDungeonSections(count: Int, difficulty: Difficulty) -> [DungeonSection] {
    var sections: [DungeonSection] = []
    for _ in 0..<count {
        let randomCorridor = GameData.shared.corridors.randomElement()!
        let randomRoom = GameData.shared.rooms.randomElement()!
        
        let outcome: RoomOutcome
        switch difficulty {
        case .easy:
            outcome = getEasyRoomOutcome()
        case .medium:
            outcome = getMediumRoomOutcome()
        case .hard:
            outcome = getHardRoomOutcome()
        }
        
        sections.append(DungeonSection(
            corridor: randomCorridor,
            room: randomRoom,
            outcome: outcome
        ))
    }
    return sections
}

