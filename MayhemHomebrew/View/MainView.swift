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
    @EnvironmentObject var session: GameSession  // to see collected treasures if needed

    
    // Keep track of total survived rooms/corridors
    @State private var survivedCount = 0
    
    @State private var unusedCorridors = GameData.shared.corridors
    @State private var unusedRooms = GameData.shared.rooms
    let maxEncounters = 6
    
    // This environment dismiss lets us pop back to StartScreen
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Homebrew Mayhem")
                    .font(.largeTitle)
                
                // Show difficulty & survived
                if let e = currentEncounter {
                    HStack {
                        Text("Difficulty: \(e.difficulty.rawValue)")
                            .foregroundColor(colorForDifficulty(e.difficulty))
                            .padding(.horizontal)
                        
                        //Spacer()
                        
                        Text("Survived: \(survivedCount)")
                            .foregroundColor(.blue)
                            .padding(.horizontal)
                    }
                    .font(.title3)
                    
                    // Location card
                    LocationCardView(cardData: e.location)
                    Spacer()
                    
                    Text("Encounter \(encounterCount) of \(maxEncounters)")
                    
                    if encounterCount < maxEncounters {
                        // Not at final location
                        HStack(spacing: 16) {
                            Button("Next") {
                                nextEncounter()
                            }
                            
                            if let outcomeCard = e.outcomeCard {
                                NavigationLink("Encounter") {
                                    EncounterView(
                                        encounter: outcomeCard,
                                        outcomeType: e.outcomeType,
                                        rewardTreasures: e.rewardTreasures
                                    )
                                }
                            } else {
                                Text("Encounter").foregroundColor(.gray)
                            }
                            
                            // End button to end game immediately
                            Button("End") {
                                endGame()
                            }
                            .foregroundColor(.red)
                        }
                    } else {
                        // We've reached the 6th
                        if let outcomeCard = e.outcomeCard {
                            NavigationLink("Encounter") {
                                EncounterView(
                                    encounter: outcomeCard,
                                    outcomeType: e.outcomeType,
                                    rewardTreasures: e.rewardTreasures
                                )
                            }
                        } else {
                            Text("Encounter").foregroundColor(.gray)
                        }
                        
                        HStack {
                            Button("New Dungeon") {
                                restart()
                            }
                            .buttonStyle(.borderedProminent)
                            
                            // Also show an "End" button if they want to exit mid-late
                            Button("End") {
                                endGame()
                            }
                            .foregroundColor(.red)
                            .padding(.leading)
                        }
                    }
                    
                } else {
                    // if no currentEncounter, let them begin
                    Text("Tap 'Next' to begin.")
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: InventoryView()) {
                                    Text("Inventory (\(session.collectedTreasures.count))")
                                }
                            }
                        }
        .onAppear {
            // If brand new, generate the first
            if currentEncounter == nil && encounterCount == 0 {
                nextEncounter()
            }
        }
    }
    
    func nextEncounter() {
         if encounterCount < maxEncounters {
             // Generate a new location & outcome
             currentEncounter = generateEncounterSection()
             encounterCount += 1
             
             // Each time we press "Next," we consider that we've survived the previous location
             survivedCount += 1
         }
     }
    
    func restart() {
        // Reset everything to start fresh
        encounterCount = 0
        currentEncounter = nil
        // Optionally generate the first encounter automatically
        nextEncounter()
    }
    
    func endGame() {
          // The entire party dies => go back to StartScreen and clear the survived count
          survivedCount = 0
          encounterCount = 0
          currentEncounter = nil
          
          // We assume StartScreen is the previous view in the Nav stack
          // so this dismiss will pop back to StartScreen
          dismiss()
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

