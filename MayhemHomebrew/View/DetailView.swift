//
//  DetailView.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/21/25.
//

import SwiftUI

struct DetailScreen<T: Card>: View {
    let card: T

    var body: some View {
        VStack(alignment: .leading) {
            Text(card.title)
                .font(.largeTitle)
                .padding(.bottom, 8)
            
            Text(card.description)
                .font(.body)
            
            // Additional UI for flavor text, effect scaling, etc.
            
            Spacer()
        }
        .padding()
        .navigationTitle("Detail View")
    }
}

