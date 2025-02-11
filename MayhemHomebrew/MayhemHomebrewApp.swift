//
//  MayhemHomebrewApp.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 1/20/25.
//

import SwiftUI

@main
struct MayhemHomebrewApp: App {
    @StateObject private var session = GameSession()
    
    var body: some Scene {
        WindowGroup {
            //NavigationStack {
                       StartScreen()
                        .environmentObject(session)
                   //}
        }
    }
}
