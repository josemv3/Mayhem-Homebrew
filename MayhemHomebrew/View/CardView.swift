//
//  CardView.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/21/25.
//

import SwiftUI

struct CardView<T: Card>: View {
    let cardData: T
    
    var body: some View {
        // Force a 3.5 : 2.5 ratio
        GeometryReader { geo in
            let width = geo.size.width
            let height = width * (3.5 / 2.5)  // ensures the ratio
            
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.orange.opacity(0.2))
                
                VStack {
                    Text(cardData.title)
                        .font(.headline)
                        .padding(.top)
                    
                    Spacer()
                    
                    Text(cardData.description)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .frame(width: width, height: height)
        }
    }
}

