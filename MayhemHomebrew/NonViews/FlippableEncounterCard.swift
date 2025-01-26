//
//  FlippableEncounterCard.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/26/25.
//

import SwiftUI

struct FlippableEncounterCard: View {
    let cardData: Card
    let outcomeType: EncounterOutcome
    
    var body: some View {
        FlipView(
            front: frontSide,
            back: backSide
        )
        .frame(height: 500) // or however tall you want the card
    }
    
    // Front side (image, title, etc.)
    private var frontSide: some View {
        EncounterCardView(cardData: cardData, outcomeType: outcomeType)
    }
    
    // Back side (scrollable text or details)
    private var backSide: some View {
        ZStack {
            // A background shape
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(radius: 4)
            
            ScrollView {
                Text(cardData.description)
                    .padding()
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(.horizontal)
    }
}

import SwiftUI

/// A reusable "flip" container that shows `front` when angle < 90, `back` otherwise.
struct FlipView<Front: View, Back: View>: View {
    @State private var angle: Double = 0
    let front: Front
    let back: Back

    var body: some View {
        ZStack {
            // FRONT
            if angle < 90 {
                front
                    // Rotate from 0°..90° around Y axis
                    .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0))
            } else {
                // BACK
                back
                    // The backside is rotated 180°..90° (which is 180 - angle)
                    .rotation3DEffect(.degrees(angle - 180), axis: (x: 0, y: 1, z: 0))
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.6)) {
                angle = (angle < 90) ? 180 : 0
            }
        }
    }
}
