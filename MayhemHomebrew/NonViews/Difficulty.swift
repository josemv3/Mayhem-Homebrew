//
//  Difficulty.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/20/25.
//

import SwiftUI

import SwiftUI

// Example enum for difficulty
enum Difficulty: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

enum EncounterOutcome {
    case treasure
    case fightCritters
    case trap
    case puzzle
    case miniBoss
    case boss
    case fightMobs
    // etc.
}

func rollDifficulty() -> Difficulty {
    let roll = Int.random(in: 1...6)
    switch roll {
    case 1, 2: return .easy
    case 3, 4: return .medium
    default:   return .hard
    }
}

func getEasyEncounterOutcome() -> EncounterOutcome {
    let roll = Int.random(in: 1...6)
    switch roll {
    case 1,2,3: return .treasure
    case 4:     return .fightCritters
    case 5:     return .trap
    default:    return .puzzle
    }
}

func getMediumEncounterOutcome() -> EncounterOutcome {
    let roll = Int.random(in: 1...10)
    switch roll {
    case 1,2:   return .treasure
    case 3,4:   return .fightCritters
    case 5,6:   return .trap
    case 7,8:   return .fightMobs
    case 9:     return .treasure // or .secretPassage, etc.
    default:    return .miniBoss     // or mini-boss
    }
}

func getHardEncounterOutcome() -> EncounterOutcome {
    let roll = Int.random(in: 1...10)
    switch roll {
    case 1:     return .treasure
    case 2,3,4: return .miniBoss
    case 5,6:   return .trap
    case 7,8:   return .puzzle
    case 9:     return .boss // or boss
    default:    return .fightMobs      // or hidden treasure
    }
}

func pickLocation() -> Card {
    let coinFlip = Bool.random() // 50% true, 50% false
    if coinFlip {
        return GameData.shared.corridors.randomElement()!
    } else {
        return GameData.shared.rooms.randomElement()!
    }
}
