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
    let rewardTreasures: [Card]  // pass this in if we have one
    
    @Environment(\.dismiss) var dismiss
    @State private var selectedPage = 0
    
    var body: some View {
        TabView(selection: $selectedPage) {
            // PAGE 1: the Encounter itself
            ScrollView (showsIndicators: false) {
                VStack {
                    FlippableEncounterCard(cardData: encounter, outcomeType: outcomeType)
                        .padding(.horizontal)
                    
                    // Possibly details, "Done" button, etc.
                    Button("Done") {
                        dismiss()
                    }
                    .padding()
                   
                }
                .tag(0)
            }
            
            // PAGE 2: the reward treasure (if any)
            if rewardTreasures.isEmpty {
                              // If no treasures, optionally show a "no reward" page
                              VStack {
                                  Text("No extra reward for this encounter.")
                                  //Spacer()
                              }
                              .tag(1)
                          } else {
                              // Add a page for each treasure
                              ForEach(0..<rewardTreasures.count, id: \.self) { i in
                                  VStack {
                                      FlippableEncounterCard(
                                          cardData: rewardTreasures[i],
                                          outcomeType: .treasure
                                      )
                                      Spacer()
                                  }
                                  .tag(i + 1)
                              }
                          }
        }
        .tabViewStyle(.page) // This gives you a horizontal swipe between pages
        .navigationTitle("Encounter View")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
                   selectedPage = 0
               }
    }
}
