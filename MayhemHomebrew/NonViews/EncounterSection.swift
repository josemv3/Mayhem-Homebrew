//
//  EncounterSection.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/23/25.
//

import SwiftUI

struct EncounterSection {
    let difficulty: Difficulty
    let location: Card
    let outcomeType: EncounterOutcome
    let outcomeCard: Card?
    let rewardTreasures: [Card]
}


func pickOutcomeCard(for outcome: EncounterOutcome, difficulty: Difficulty) -> Card? {
    switch outcome {
    case .treasure:
        // 1) pick from [JSONTreasure]
        if let rawT = GameData.shared.treasures.randomElement() {
            // 2) choose correct difficulty text
            let finalDescription: String
            switch difficulty {
            case .easy:   finalDescription = rawT.easy
            case .medium: finalDescription = rawT.medium
            case .hard:   finalDescription = rawT.hard
            }
            // 3) build the final `SimpleTreasureCard`
            return SimpleTreasureCard(
                title: rawT.title,
                rarity: rawT.rarity,
                difficultyText: finalDescription, imageName: rawT.title
            )
        } else {
            return nil
        }
        
    case .trap:
        // Similar process
        if let rawTrap = GameData.shared.traps.randomElement() {
            let finalDescription: String
            switch difficulty {
            case .easy:   finalDescription = rawTrap.easy
            case .medium: finalDescription = rawTrap.medium
            case .hard:   finalDescription = rawTrap.hard
            }
            return SimpleTrapCard(
                title: rawTrap.title,
                difficultyText: finalDescription, imageName: rawTrap.title
            )
        } else {
            return nil
        }
        
    case .puzzle:
        // Puzzles are already stored as final `PuzzleCard`.
        return GameData.shared.puzzles.randomElement()
        
    // etc. for enemies, which are final `EnemyCard` in GameData
    case .fightCritters:
        return GameData.shared.critters.randomElement()
    case .fightMobs:
        return GameData.shared.mobs.randomElement()
    case .miniBoss:
        return GameData.shared.miniBosses.randomElement()
    case .boss:
        return GameData.shared.bosses.randomElement()
    }
}


func getEncounterOutcome(for difficulty: Difficulty) -> EncounterOutcome {
    switch difficulty {
    case .easy:   return getEasyEncounterOutcome()
    case .medium: return getMediumEncounterOutcome()
    case .hard:   return getHardEncounterOutcome()
    }
}

func pickTreasureCard(for difficulty: Difficulty) -> Card? {
    // This is basically the same logic you use for `.treasure` in pickOutcomeCard
    if let rawT = GameData.shared.treasures.randomElement() {
        let finalDescription: String
        switch difficulty {
        case .easy:   finalDescription = rawT.easy
        case .medium: finalDescription = rawT.medium
        case .hard:   finalDescription = rawT.hard
        }
        
        return SimpleTreasureCard(
            title: rawT.title,
            rarity: rawT.rarity,
            difficultyText: finalDescription, imageName: rawT.title
        )
    }
    return nil
}


func generateEncounterSection() -> EncounterSection {
    let difficulty = rollDifficulty()
    let location = pickLocation()
    let outcome = getEncounterOutcome(for: difficulty)
    let outcomeCard = pickOutcomeCard(for: outcome, difficulty: difficulty)
    
    // Determine how many treasure cards to give based on the fight type
    let rewardCount: Int
    switch outcome {
    case .fightCritters:
        rewardCount = 1
    case .fightMobs:
        rewardCount = 2
    case .miniBoss:
        rewardCount = 3
    case .boss:
        rewardCount = 4
    default:
        rewardCount = 0
    }
    
    // Build an array of treasure cards (if any)
    var rewardTreasures: [Card] = []
    for _ in 0..<rewardCount {
        if let treasure = pickTreasureCard(for: difficulty) {
            rewardTreasures.append(treasure)
        }
    }
    
    return EncounterSection(
        difficulty: difficulty,
        location: location,
        outcomeType: outcome,
        outcomeCard: outcomeCard,
        rewardTreasures: rewardTreasures
    )
}



