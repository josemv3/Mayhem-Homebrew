//
//  MainView.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/21/25.
//

import SwiftUI

struct MainScreen: View {
    @State private var currentEncounter: EncounterSection? = nil
    @State private var encounterCount = 0
    let maxEncounters = 6
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Homebrew Mayhem")
                .font(.largeTitle)
                .padding(.top)
            
            // Show the current encounter if we have one
            if let encounter = currentEncounter {
                // Display the difficulty each time
                Text("Difficulty Rolled: \(encounter.difficulty.rawValue)")
                    .font(.title3)
                    .foregroundColor(colorForDifficulty(encounter.difficulty))
                
                // Top Card: corridor or room
                CardView(cardData: encounter.location)
                    .frame(width: 150)
                
                // Indicate corridor or room
                Text("Location: \(encounter.location.cardType == .corridor ? "Corridor" : "Room")")
                
                Divider()
                    .padding()
                
                // Bottom card: the outcome
                if let outcomeCard = encounter.outcomeCard {
                    CardView(cardData: outcomeCard)
                        .frame(width: 150)
                    Text("Encounter: \(encounterLabel(encounter.outcomeType))")
                } else {
                    // If outcome has no card, e.g. a fight you handle manually
                    Text("Encounter: \(encounterLabel(encounter.outcomeType))")
                    Text("No specific card for this type of fight.")
                        .font(.footnote)
                }
                
            } else {
                Text("Press 'Next' to begin the 1st encounter.")
            }
            
            // Keep track of how many we've done
            Text("Encounter \(encounterCount) of \(maxEncounters)")
            
            // If we've done 6, show "Complete" else show Next button
            if encounterCount < maxEncounters {
                Button("Next") {
                    // Generate a new encounter
                    currentEncounter = generateEncounterSection()
                    encounterCount += 1
                }
                .padding()
            } else {
                Text("All done! You've completed \(maxEncounters) encounters.")
                    .font(.headline)
                    //.padding()
                
                Button("Start New Adventure") {
                       restartAdventure()
                   }
                   //.padding()
            }
        }
        .padding()
    }
    
    // Helper
    func colorForDifficulty(_ diff: Difficulty) -> Color {
        switch diff {
        case .easy: return .green
        case .medium: return .yellow
        case .hard: return .red
        }
    }
    
    func encounterLabel(_ outcome: EncounterOutcome) -> String {
        switch outcome {
        case .treasure:     return "Treasure"
        case .trap:         return "Trap"
        case .puzzle:       return "Puzzle"
        case .fightCritters:return "Fight (Critters)"
        case .fightMobs:    return "Fight (Mobs)"
        case .miniBoss:     return "Mini-Boss"
        case .boss:         return "Boss"
        }
    }
    
    func restartAdventure() {
        encounterCount = 0
        currentEncounter = nil
    }
}
