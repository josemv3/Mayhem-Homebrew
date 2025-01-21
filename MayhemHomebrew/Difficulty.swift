//
//  Difficulty.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/20/25.
//

import SwiftUI

enum Difficulty: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

func rollDifficulty() -> Difficulty {
    let roll = Int.random(in: 1...6)
    switch roll {
    case 1, 2:
        return .easy
    case 3, 4:
        return .medium
    default:
        return .hard
    }
}

func getEasyRoomOutcome() -> RoomOutcome {
    let roll = Int.random(in: 1...6)
    switch roll {
    case 1, 2, 3:
        return .treasure
    case 4:
        return .fightCritters
    case 5:
        return .trap
    default:
        return .puzzle
    }
}

func getMediumRoomOutcome() -> RoomOutcome {
    let roll = Int.random(in: 1...10)
    switch roll {
    case 1, 2:
        return .treasure
    case 3, 4:
        return .fightCritters
    case 5, 6:
        return .trap
    case 7,8:
        return .puzzle
    case 9:
        return .secretPassage
    default:
        return .miniBoss
    }
}

func getHardRoomOutcome() -> RoomOutcome {
    let roll = Int.random(in: 1...10)
    switch roll {
    case 1:
        return .treasure
    case 2, 4:
        return .miniBoss
    case 5, 6:
        return .trap
    case 7,8:
        return .puzzle
    default:
        return .boss
    }
}

enum RoomOutcome {
    case treasure
    case fightCritters
    case trap
    case puzzle
    case secretPassage
    case miniBoss
    case boss
    // etc.
}

