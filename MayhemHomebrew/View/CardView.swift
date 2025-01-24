//
//  CardView.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/21/25.
//

import SwiftUI

struct CardView: View {
    // Instead of `T: Card`, use an existential property:
    let cardData: any Card

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = width * (3.5 / 2.5)
            
            ZStack {
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
