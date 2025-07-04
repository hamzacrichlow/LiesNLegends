//
//  RevealImposter.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI
import AVFoundation


struct RevealImposterView: View {
    @Environment(\.modelContext) private var context

    let imposter: Player
    let roundPlayers: [Player]
    let playerSelections: [Player: Player?]
    @EnvironmentObject var audioManager: AudioManager
    @State private var showRules = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("The Imposter was:")
                    .font(.title)
                    .padding()

                Text(imposter.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding()

                Text("Players' Guesses:")
                    .font(.title2)
                    .padding(.top)

                ForEach(roundPlayers, id: \.id) { player in
                    HStack {
                        Text("\(player.name) guessed: ")
                            .font(.headline)

                        if let guessedImposter = playerSelections[player] {
                            Text(guessedImposter?.name ?? "No Selection")
                                .font(.headline)
                                .foregroundColor(guessedImposter == imposter ? .green : .red)
                        } else {
                            Text("No Selection")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                }

                NavigationLink(destination: ListOfPlayers()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.black, lineWidth: 6)
                            .frame(width: 200, height: 40)
                            .background(Color.white)
                            .cornerRadius(50)

                        Text("NEXT ROUND")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
                .padding()
            }
            .navigationTitle("Imposter Revealed")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showRules.toggle() }) {
                        Image(systemName: "text.page.badge.magnifyingglass")
                            .font(.title3)
                            .foregroundStyle(.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { audioManager.toggleMusic() }) {
                        Image(systemName: audioManager.isPlaying ? "speaker.wave.2" : "speaker.slash")
                            .font(.title2)
                            .foregroundStyle(audioManager.isPlaying ? .primary : .secondary)
                    }
                }
            }
            .sheet(isPresented: $showRules) {
                RulesScreen()
            }
        }
    }
}

#Preview {
    RevealImposterView(
        imposter: mockImposter,
        roundPlayers: mockPlayers,
        playerSelections: mockPlayerSelections
    )
    .environmentObject(AudioManager())
}

// Mock Data
let mockPlayers: [Player] = [
    Player(name: "Alice", status: "True", score: 0, isImposter: false),
    Player(name: "Bob", status: "True", score: 0, isImposter: false),
    Player(name: "Charlie", status: "True", score: 0, isImposter: true),
    Player(name: "David", status: "True", score: 0, isImposter: false)
]

let mockImposter = mockPlayers[2] // Charlie is the imposter

let mockPlayerSelections: [Player: Player?] = [
    mockPlayers[0]: mockPlayers[2], // Alice guessed Charlie
    mockPlayers[1]: mockPlayers[2], // Bob guessed Charlie
    mockPlayers[3]: mockPlayers[1]  // David guessed Bob (wrong guess)
]
