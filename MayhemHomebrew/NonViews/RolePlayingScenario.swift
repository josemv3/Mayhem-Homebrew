//
//  RolePlayingScenario.swift
//  MayhemHomebrew
//
//  Created by Joey Rubin on 2/19/25.
//

import SwiftUI

struct RolePlayingScenario: Codable, Identifiable {
    let id: Int
    let title: String
    let quest: String
    let scenes: [RolePlayingScene]
    let questDescription: String?
    let epilogue: String?
}

struct RolePlayingScene: Codable, Identifiable {
    var id: Int { sceneNumber }
    let sceneNumber: Int
    let sceneName: String
    let imageUrl: String
    let expandedDescription: String
    let checks: [RolePlayingCheck]
    let tokenMechanic: RolePlayingTokenMechanic?  // may be nil
    let treasureTwist: String?                    // may be nil
}

struct RolePlayingCheck: Codable, Identifiable {
    // Using UUID for simplicity
    let id = UUID()
    let skill: String
    let skillCheck: String
    let successTitle: String
    let failTitle: String
    let failDescription: String
}

struct RolePlayingTokenMechanic: Codable {
    let name: String
    let description: String
}

final class RolePlayingData: ObservableObject {
    static let shared = RolePlayingData()
    @Published var scenarios: [RolePlayingScenario] = []
    
    private init() {
        loadScenarios()
    }
    
    private func loadScenarios() {
        guard let url = Bundle.main.url(forResource: "storyRPData", withExtension: "json") else {
            print("storyRPData.json not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let wrapper = try decoder.decode(StoryRPWrapper.self, from: data)
            self.scenarios = wrapper.scenarios
        } catch {
            print("Error loading storyRPData.json: \(error)")
        }
    }
}

struct StoryRPWrapper: Codable {
    let scenarios: [RolePlayingScenario]
}



struct RolePlayingScenarioListView: View {
    @ObservedObject var rpData = RolePlayingData.shared
    
    var body: some View {
        List(rpData.scenarios) { scenario in
            NavigationLink(destination: RolePlayingScenarioView(scenario: scenario)) {
                VStack(alignment: .leading) {
                    Text(scenario.title)
                        .font(.headline)
                    Text(scenario.quest)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Story Adventures")
    }
}

import SwiftUI

struct RolePlayingSceneCard: View {
    let scene: RolePlayingScene
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // 1) The image (or a gray placeholder)
            if let uiImage = UIImage(named: scene.imageUrl) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .overlay(Text("No Image"))
            }
            
            // 2) A gradient or a solid rectangle at the bottom
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]),
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(height: 400) // Adjust height as you wish
            
            // 3) The scene name text
            Text(scene.sceneName)
                .font(.title2)
                .foregroundColor(.white)
                .bold()
                .padding(.leading, 16)
                .padding(.bottom, 8)
        }
        .frame(height: 500) // Adjust as needed
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}



struct RolePlayingScenarioView: View {
    let scenario: RolePlayingScenario
    
    @State private var showIntro = true
    @State private var currentSceneIndex: Int = 0
    
    var body: some View {
        VStack {
            if showIntro {
                // Show the intro view
                ScenarioIntroView(scenario: scenario) {
                    // Once the user is done, hide the intro
                    showIntro = false
                }
            } else {
                // Show the actual scenes
                if currentSceneIndex < scenario.scenes.count {
                    RolePlayingSceneView(scene: scenario.scenes[currentSceneIndex]) {
                        currentSceneIndex += 1
                    }
                } else {
                    // Scenes finished; show epilogue if you have one
                    if let epilogue = scenario.epilogue {
                        Text("Epilogue")
                            .font(.title)
                            .padding()
                        Text(epilogue)
                            .padding()
                    }
                    Button("Finish Adventure") {
                        // Dismiss or pop back
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
        }
        .navigationTitle(scenario.title)
    }
}




struct ScenarioIntroView: View {
    let scenario: RolePlayingScenario
    let onStartScenes: () -> Void  // Called when the user taps "Start Adventure"
    
    // The images you want to display in the slideshow
    private let images = [
        "tul_intro1", "tul_intro2", "tul_intro3",
        "tul_intro4", "tul_intro5", "tul_intro6"
    ]
    
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            // 1) ZStack that displays only the current image with a fade
            ZStack {
                ForEach(images.indices, id: \.self) { i in
                    if i == currentIndex {
                        Image(images[i])
                            .resizable()
                            .scaledToFit()
                            .transition(.opacity)
                            .id(i) // helps SwiftUI know which image is active
                    }
                }
            }
            .animation(.easeInOut, value: currentIndex)
            .frame(height: 400)
            // 2) Add a drag gesture to manually swipe left or right
            .gesture(
                DragGesture()
                    .onEnded { value in
                        // if user swiped left, go to next; if swiped right, go to previous
                        if value.translation.width < 0 {
                            nextImage()
                        } else if value.translation.width > 0 {
                            previousImage()
                        }
                    }
            )
            // 3) Auto-randomly switch images every 5 seconds
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                    withAnimation {
                        currentIndex = Int.random(in: 0..<images.count)
                    }
                }
            }
            
            // 4) The extended quest description
            ScrollView {
                Text(scenario.questDescription ?? "")
                    .padding()
            }
            
            // 5) Button to start the actual scenes
            Button("Start Adventure") {
                onStartScenes()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle(scenario.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Helper to move forward or backward in the array
    private func nextImage() {
        currentIndex = (currentIndex + 1) % images.count
    }
    private func previousImage() {
        currentIndex = (currentIndex - 1 + images.count) % images.count
    }
}

struct RolePlayingSceneView: View {
    let scene: RolePlayingScene
    let onComplete: () -> Void  // Called when the scene is finished
    
    /// Which check was chosen (if any)
    @State private var resolvedCheckIndex: Int? = nil
    /// Whether the chosen check was passed (true) or failed (false)
    @State private var resolvedPass: Bool? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // --- Existing scene image & title (if you want to keep them) ---
                if let uiImage = UIImage(named: scene.imageUrl) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(Text("No Image"))
                        .cornerRadius(10)
                }
                
                Text(scene.sceneName)
                    .font(.title)
                    .bold()
                
                Text(scene.expandedDescription)
                    .padding()
                
                Divider()
                
                // --- Display all checks simultaneously ---
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(scene.checks.enumerated()), id: \.element.id) { index, check in
                        VStack(alignment: .leading, spacing: 8) {
                            
                            // 1) Show skill + difficulty
                            Text("Skill: \(check.skill) (Roll: \(check.skillCheck))")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                            
                            // 2) Always show successTitle
                            //    - Gray if not resolved or if it was failed
                            //    - Green if passed
                            if resolvedCheckIndex == index {
                                // This is the chosen check
                                if let didPass = resolvedPass, didPass == true {
                                    // PASSED
                                    Text(check.successTitle)
                                        .foregroundColor(.green)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                            .multilineTextAlignment(.leading)
                                } else {
                                    // Not passed (either not decided yet or fail)
                                    Text(check.successTitle)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                            .multilineTextAlignment(.leading)
                                }
                            } else {
                                // Not chosen check => show in gray
                                Text(check.successTitle)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                        .multilineTextAlignment(.leading)
                                    //.padding(.vertical, 5)
                            }
                            
                            // 3) Pass/Fail buttons or results
                            if resolvedCheckIndex == index {
                                // If we have chosen THIS check, see if we failed
                                if let didPass = resolvedPass, didPass == false {
                                    // Show the failTitle + failDescription in red
                                    Text("Fail: \(check.failTitle)\n\(check.failDescription)")
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                            .multilineTextAlignment(.leading)
                                }
                            } else {
                                // No check chosen yet, or a different check was chosen
                                // Only enable these buttons if no check is resolved
                                HStack(spacing: 20) {
                                    Button("Pass") {
                                        resolvedCheckIndex = index
                                        resolvedPass = true
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .disabled(resolvedCheckIndex != nil)
                                    
                                    Button("Fail") {
                                        resolvedCheckIndex = index
                                        resolvedPass = false
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .disabled(resolvedCheckIndex != nil)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.orange.opacity(0.2))
                        )
                    }
                }
                .padding(.horizontal, 5)
                
                // --- Once one check is resolved, show any token or treasure info + Complete button ---
                if resolvedCheckIndex != nil {
                    if let token = scene.tokenMechanic {
                        VStack {
                            Text("Token Mechanic:")
                                .font(.headline)
                            Text("\(token.name): \(token.description)")
                                .padding()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green.opacity(0.2))
                        )
                        .padding(.horizontal)
                    }
                    
                    if let treasure = scene.treasureTwist {
                        VStack {
                            Text("Treasure Twist:")
                                .font(.headline)
                            Text(treasure)
                                .padding()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.purple.opacity(0.2))
                        )
                        .padding(.horizontal)
                    }
                    
                    Button("Complete Scene") {
                        onComplete()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
            .padding()
        }
        // Reset the state each time a new scene is displayed
        .onAppear {
            resolvedCheckIndex = nil
            resolvedPass = nil
        }
    }
}


