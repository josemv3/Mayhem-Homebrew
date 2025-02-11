//
//  LocationCardView.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/24/25.
//

import SwiftUI

struct LocationCardView: View {
    let cardData: Card
    @State private var showFlavorAlert = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            // 1) The image (or placeholder)
            if let imageName = cardData.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.frame(height: 500)      // or however tall you want
                    .frame(maxWidth: .infinity, minHeight: 400, maxHeight: 800)
                    .scaledToFill()
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 800)
                    //.frame(height: 500)
                    .overlay(Text("No Image").foregroundColor(.black))
            }
            
            // 2) An optional gradient, so text is more readable
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                startPoint: .center,
                endPoint: .bottom
            )
            
            // 3) The text overlay
            VStack(alignment: .center, spacing: 4) {
                
                Text(cardData.title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                // Show "Corridor" or "Room" (or whatever type) in smaller text
                Text(cardData.cardType == .corridor ? "Corridor" : "Room")
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
        
            .padding()
        }
        .cornerRadius(10)
        .shadow(radius: 4)
        .onTapGesture {
            showFlavorAlert = true
        }
        .alert("Flavor", isPresented: $showFlavorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            // Show your flavor text
            Text(cardData.description)
        }
    }
}
