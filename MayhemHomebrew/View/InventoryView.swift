//
//  InventoryView.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/29/25.
//

import SwiftUI

struct InventoryView: View {
    @EnvironmentObject var session: GameSession
    
    var body: some View {
        List {
            ForEach(session.collectedTreasures.indices, id: \.self) { index in
                let treasure = session.collectedTreasures[index]
                VStack (alignment: .leading) {
                    Text(treasure.title)
                        .font(.headline)
                        .foregroundStyle(.cyan)
                    Text(treasure.description).font(.subheadline)
                }
            }
            .onDelete { offsets in
                session.collectedTreasures.remove(atOffsets: offsets)
            }
        }
        .navigationTitle("Your Treasures")
    }
}

