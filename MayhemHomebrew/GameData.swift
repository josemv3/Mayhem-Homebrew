//
//  GameData.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/20/25.
//

import SwiftUI

final class GameData {
    static let shared = GameData()
    
    // Corridors/rooms can stay as final Card if you like,
    // because they have no difficulty text.
    private(set) var corridors: [CorridorCard] = []
    private(set) var rooms: [RoomCard] = []
    
    // BUT store the raw JSON data for trap/treasure:
    private(set) var traps: [JSONTrap] = []
    private(set) var treasures: [JSONTreasure] = []
    
    // Puzzles can remain as `PuzzleCard` if you want just one format.
    private(set) var puzzles: [PuzzleCard] = []
    
    // Similarly for enemies: if they have no difficulty tiers,
    // we can store them as final EnemyCard.
    private(set) var critters: [EnemyCard] = []
    private(set) var mobs: [EnemyCard] = []
    private(set) var miniBosses: [EnemyCard] = []
    private(set) var bosses: [EnemyCard] = []
    
    private init() {
        loadAndMapJSON()
    }
    
    private func loadAndMapJSON() {
        guard let url = Bundle.main.url(forResource: "GameData", withExtension: "json") else {
            fatalError("Could not find GameData.json in bundle.")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let rawData = try decoder.decode(RawGameData.self, from: data)
            
            // Convert corridors to final "CorridorCard" (because they have no easy/med/hard)
            self.corridors = rawData.corridors.map {
                CorridorCard(title: $0.title, description: $0.flavor)
            }
            
            // Convert rooms to final "RoomCard"
            self.rooms = rawData.rooms.map {
                RoomCard(title: $0.title, description: $0.flavor)
            }
            
            // **Store raw traps** directly, so we can pick difficulty text later
            self.traps = rawData.traps
            
            // **Store raw treasures** likewise
            self.treasures = rawData.treasures
            
            // Puzzles: if you only have one puzzle text, you can convert to final:
            self.puzzles = rawData.puzzles.map { rawPuzzle in
                let combined = """
                SETUP: \(rawPuzzle.setupFlavor)

                MECHANIC: \(rawPuzzle.mechanic)

                RANDOMIZE: \(rawPuzzle.randomize)
                """
                return PuzzleCard(title: rawPuzzle.title, description: combined)
            }
            
            // Enemies have no difficulty text, so we can map them to final `EnemyCard`
            self.critters = rawData.critters.map {
                EnemyCard(title: $0.title, description: $0.flavor)
            }
            self.mobs = rawData.mobs.map {
                EnemyCard(title: $0.title, description: $0.flavor)
            }
            self.miniBosses = rawData.miniBosses.map {
                EnemyCard(title: $0.title, description: $0.flavor)
            }
            self.bosses = rawData.bosses.map {
                EnemyCard(title: $0.title, description: $0.flavor)
            }
            
        } catch {
            fatalError("Failed to decode GameData.json: \(error)")
        }
    }
}
