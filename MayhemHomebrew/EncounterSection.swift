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
                difficultyText: finalDescription
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
                difficultyText: finalDescription
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

func generateEncounterSections(count: Int, difficulty: Difficulty) -> [EncounterSection] {
    var sections: [EncounterSection] = []
    
    for _ in 0..<count {
        let locationCard = pickLocation()
        let outcome: EncounterOutcome
        
        // Roll outcome by difficulty
        switch difficulty {
        case .easy:
            outcome = getEasyEncounterOutcome()
        case .medium:
            outcome = getMediumEncounterOutcome()
        case .hard:
            outcome = getHardEncounterOutcome()
        }
        
        // Pick a matching outcome card (if any)
        let outcomeCard = pickOutcomeCard(for: outcome, difficulty: difficulty)
        
        let newSection = EncounterSection(difficulty: difficulty, location: locationCard,
                                          outcomeType: outcome,
                                          outcomeCard: outcomeCard)
        sections.append(newSection)
    }
    
    return sections
}

func generateEncounterSection() -> EncounterSection {
    // 1) Roll difficulty
    let difficulty = rollDifficulty()
    
    // 2) Pick corridor or room
    let location = pickLocation()
    
    // 3) Get an outcome
    let outcome = getEncounterOutcome(for: difficulty)
    
    // 4) Grab an outcome card if relevant
    let outcomeCard = pickOutcomeCard(for: outcome, difficulty: difficulty)
    
    // 5) Return the final struct
    return EncounterSection(difficulty: difficulty,
                           location: location,
                           outcomeType: outcome,
                           outcomeCard: outcomeCard)
}

