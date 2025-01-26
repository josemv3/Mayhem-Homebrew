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
    @State private var unusedCorridors = GameData.shared.corridors
    @State private var unusedRooms = GameData.shared.rooms
    let maxEncounters = 6
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Homebrew Mayhem")
                    .font(.largeTitle)
                
                if let e = currentEncounter {
                    
                    Text("Difficulty Roll: \(e.difficulty.rawValue)")
                        .font(.title3)
                        .foregroundColor(colorForDifficulty(e.difficulty))
                    
                    // The location card
                    LocationCardView(cardData: e.location)
                    
                    Text("Encounter \(encounterCount) of \(maxEncounters)")
                    
                    // If we have NOT reached the 6th, show Next + Encounter
                    if encounterCount < maxEncounters {
                        HStack(spacing: 40) {
                            Button("Next") {
                                nextEncounter()
                            }
                            // The user can still check the encounter
                            if let outcomeCard = e.outcomeCard {
                                NavigationLink("Encounter") {
                                    EncounterView(
                                             encounter: outcomeCard,   // use the local constant
                                             outcomeType: e.outcomeType,
                                             rewardTreasures: e.rewardTreasures
                                         )
                                }
                            } else {
                                Text("Encounter").foregroundColor(.gray)
                            }
                        }
                    }
                    // ELSE if we ARE on the 6th (encounterCount == maxEncounters):
                    else {
                        // No Next button, but show final encounter link if available
                        if let outcomeCard = e.outcomeCard {
                            NavigationLink("Encounter") {
                                EncounterView(
                                         encounter: outcomeCard,   // use the local constant
                                         outcomeType: e.outcomeType,
                                         rewardTreasures: e.rewardTreasures
                                     )
                            }
                        } else {
                            Text("Encounter").foregroundColor(.gray)
                        }
                        
                        // Then show a Finish/Restart button
                        Button("Finish Adventure") {
                            // We can do a small confirm alert or just restart
                            restart()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Text("This was your final location!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                } else {
                    // If no currentEncounter, prompt user to start or auto-generate
                    Text("Tap 'Next' to begin.")
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Auto-generate the first if needed
            if currentEncounter == nil && encounterCount == 0 {
                nextEncounter()
            }
        }
    }
    
    func nextEncounter() {
        // Only generate if we haven't exceeded the max
        if encounterCount < maxEncounters {
            currentEncounter = generateEncounterSection()
            encounterCount += 1
        }
    }
    
    func restart() {
        // Reset everything to start fresh
        encounterCount = 0
        currentEncounter = nil
        // Optionally generate the first encounter automatically
        nextEncounter()
    }
    
    func colorForDifficulty(_ diff: Difficulty) -> Color {
        switch diff {
        case .easy: return .green
        case .medium: return .yellow
        case .hard: return .red
        }
    }
    
    func pickLocation() -> Card {
           // Decide corridor vs room at random
           let isCorridor = Bool.random()
           
           // If corridor was chosen but we ran out, fall back to a room.
           if isCorridor, !unusedCorridors.isEmpty {
               let index = Int.random(in: 0..<unusedCorridors.count)
               let corridor = unusedCorridors.remove(at: index)
               return corridor
           } else if !unusedRooms.isEmpty {
               let index = Int.random(in: 0..<unusedRooms.count)
               let room = unusedRooms.remove(at: index)
               return room
           } else if !unusedCorridors.isEmpty {
               // If we ran out of rooms, but have corridors left
               let index = Int.random(in: 0..<unusedCorridors.count)
               let corridor = unusedCorridors.remove(at: index)
               return corridor
           }
           
           // If both are empty, we can't pick. You might want to handle that gracefully:
           fatalError("No more corridors or rooms available!")
       }
}

