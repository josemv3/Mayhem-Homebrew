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
    @State private var hpStatus: [Bool]
    
    init(cardData: Card, outcomeType: EncounterOutcome) {
        self.cardData = cardData
        self.outcomeType = outcomeType
        
        if let enemyCard = cardData as? EnemyCard {
            _hpStatus = State(initialValue: Array(repeating: true, count: enemyCard.hp))
        } else {
            _hpStatus = State(initialValue: [])
        }
    }
    
    var body: some View {
        FlipView(
            front: frontSide,
            back: backSide
        )
        .frame(height: 500) // Adjust card height as needed
    }
    
    // Front side (image, title, etc.)
    private var frontSide: some View {
        EncounterCardView(cardData: cardData, outcomeType: outcomeType)
    }
    
    // Back side (flavor text + HP hearts)
    private var backSide: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(radius: 4)
            
            VStack {
                Text(cardData.title)
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                Text(cardData.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                
                heartDisplay
            }
            .padding()
        }
        .padding(.horizontal)
    }
    
    // Heart Display Logic
    // Heart Display Logic with rows of 8
    private var heartDisplay: some View {
        let maxHeartsPerRow = 8
        let rows = hpStatus.chunked(into: maxHeartsPerRow)
        
        return VStack(spacing: 10) {
            ForEach(0..<rows.count, id: \.self) { rowIndex in
                HStack {
                    ForEach(rows[rowIndex].indices, id: \.self) { index in
                        Image(systemName: rows[rowIndex][index] ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(rows[rowIndex][index] ? .red : .gray)
                            .onTapGesture {
                                hpStatus[rowIndex * maxHeartsPerRow + index].toggle()
                            }
                    }
                }
            }
        }
        .padding(.top)
    }

}


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

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
