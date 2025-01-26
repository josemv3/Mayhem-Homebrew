//
//  StartScreen.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/24/25.
//

import SwiftUI

struct StartScreen: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Text("Welcome to Homebrew Mayhem")
                    .font(.largeTitle)

                Text("Press Start to begin your adventure.\nEach new location re-rolls the difficulty.")
                    .multilineTextAlignment(.center)
                    .padding()

                NavigationLink("Start Adventure") {
                    // Go to MainScreen (no difficulty param, because we re-roll each time)
                    MainScreen()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
