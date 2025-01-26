//
//  jsonDataModel.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/21/25.
//

import Foundation

// MARK: - Corridor

import Foundation

// 1) For corridors in JSON
struct JSONCorridor: Codable {
    let title: String
    let flavor: String
}

// 2) For rooms in JSON
struct JSONRoom: Codable {
    let title: String
    let flavor: String
}

// 3) For traps in JSON
struct JSONTrap: Codable {
    let title: String
    let easy: String
    let medium: String
    let hard: String
}

// 4) For puzzles in JSON
struct JSONPuzzle: Codable {
    let title: String
    let setupFlavor: String
    let mechanic: String
    let randomize: String
}

// 5) For treasures in JSON
struct JSONTreasure: Codable {
    let title: String
    let rarity: String
    let easy: String
    let medium: String
    let hard: String
}

struct JSONEnemy: Codable {
    let title: String
    let flavor: String
}


// Top-level structure for the entire JSON
struct RawGameData: Codable {
    let corridors: [JSONCorridor]
    let rooms: [JSONRoom]
    let traps: [JSONTrap]
    let puzzles: [JSONPuzzle]
    let treasures: [JSONTreasure]
    let critters: [JSONEnemy]
    let mobs: [JSONEnemy]
    let miniBosses: [JSONEnemy]
    let bosses: [JSONEnemy]
}


func loadGameData() -> RawGameData {
    guard let url = Bundle.main.url(forResource: "GameData", withExtension: "json") else {
        fatalError("Could not find GameData.json in bundle.")
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let gameData = try decoder.decode(RawGameData.self, from: data)
        return gameData
    } catch {
        fatalError("Failed to decode GameData.json: \(error)")
    }
}
