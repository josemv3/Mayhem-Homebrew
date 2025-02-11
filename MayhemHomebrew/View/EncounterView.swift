//
//  EncounterView.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/24/25.
//

import SwiftUI

struct EncounterView: View {
    let encounter: Card
    let outcomeType: EncounterOutcome
    let rewardTreasures: [Card]
    
    @EnvironmentObject var session: GameSession
    @Environment(\.dismiss) var dismiss
    @State private var selectedPage = 0
    @State private var addedTreasureIndices = Set<Int>()
    @State private var mainEncounterAdded = false
    
    var body: some View {
        VStack(spacing: 0) {
            // The TabView up top
            TabView(selection: $selectedPage) {
                
                // PAGE 0: The main encounter card
                VStack {
                    FlippableEncounterCard(cardData: encounter, outcomeType: outcomeType)
                        .onAppear {
                            // If the main outcome is a treasure, add it once user sees it
                            if outcomeType == .treasure, !mainEncounterAdded {
                                session.addTreasure(encounter)
                                mainEncounterAdded = true
                            }
                        }
                }
                .tag(0)
                
                // PAGE 1..N: Treasures
                if rewardTreasures.isEmpty {
                    // Single page with "no extra reward"
                    VStack {
                        Text("No extra reward for this encounter.")
                            .padding()
                        //Spacer()
                    }
                    .tag(1)
                } else {
                    // One page per treasure
                    ForEach(0..<rewardTreasures.count, id: \.self) { i in
                        VStack {
                            FlippableEncounterCard(cardData: rewardTreasures[i], outcomeType: .treasure)
                                .onAppear {
                                    // Only add it once
                                    if !addedTreasureIndices.contains(i) {
                                        session.addTreasure(rewardTreasures[i])
                                        addedTreasureIndices.insert(i)
                                    }
                                }
                        }
                        
                        .tag(i + 1)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            // DONE button below the TabView
            Button("Done") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Encounter View")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedPage = 0
            
        }
     

    }
}

