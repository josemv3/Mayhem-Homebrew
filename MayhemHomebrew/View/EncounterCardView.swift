//
//  EncounterCardView.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/24/25.
//

import SwiftUI

struct EncounterCardView: View {
    let cardData: Card       // e.g. Pit Trap, Treasure, etc.
    let outcomeType: EncounterOutcome
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            // 1) The main image (or a gray placeholder if no imageName)
            if let imageName = cardData.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 500)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 500)
                    .overlay(Text("No Image"))
            }
            
            // 2) Optional gradient overlay for better text contrast
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                startPoint: .center,
                endPoint: .bottom
            )
            
            // 3) The text overlay (title + subheading)
            VStack(alignment: .leading, spacing: 4) {
                Text(cardData.title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                Text(encounterTypeLabel(outcomeType))
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.8))
            }
            .padding()
        }
        .cornerRadius(10)
        .shadow(radius: 4)
    }
    
    // Helper to display the outcome type as text
    func encounterTypeLabel(_ outcome: EncounterOutcome) -> String {
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
}
