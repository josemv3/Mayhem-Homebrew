//
//  MainView.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/21/25.
//

import SwiftUI

struct MainScreen: View {
    @State private var difficulty: Difficulty? = nil
    @State private var sections: [DungeonSection] = []
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            Text("Homebrew Mayhem")
                .font(.largeTitle)
                .padding()
            
            // Difficulty
            if let diff = difficulty {
                Text("Current Difficulty: \(diff.rawValue)")
                    .font(.title2)
                    .foregroundColor(colorForDifficulty(diff))
            } else {
                Button("Roll Difficulty") {
                    let roll = rollDifficulty()
                    difficulty = roll
                    sections = generateDungeonSections(count: 6, difficulty: roll)
                    currentIndex = 0
                }
            }
            
            Spacer()
            
            // Show current corridor/room if we have them
            if !sections.isEmpty {
                let corridor = sections[currentIndex].corridor
                let room = sections[currentIndex].room
                let outcome = sections[currentIndex].outcome
                
                // Example layout: corridor card on top, room outcome below
                VStack {
                    CardView(cardData: corridor)
                        .frame(width: 150) // The geometry inside sets height ratio
                    Text("Corridor")
                    
                    Divider().padding()
                    
                    CardView(cardData: room)
                        .frame(width: 150)
                    Text("Outcome: \(outcomeLabel(outcome))")
                }
            }
            
            Spacer()
            
            // Navigation to next section
            Button("Next") {
                if currentIndex < sections.count - 1 {
                    currentIndex += 1
                } else {
                    // Possibly wrap around or show "Dungeon complete"
                }
            }
            .padding()
        }
    }
    
    func colorForDifficulty(_ diff: Difficulty) -> Color {
        switch diff {
        case .easy: return .green
        case .medium: return .yellow
        case .hard: return .red
        }
    }
    
    func outcomeLabel(_ outcome: RoomOutcome) -> String {
        switch outcome {
        case .treasure: return "Treasure"
        case .fightCritters: return "Fight (Critters)"
        case .trap: return "Trap"
        case .puzzle: return "Puzzle"
        // etc.
        default: return "Other"
        }
    }
}
