//
//  ListOfPlayers.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI
import SwiftData

// Player Model: Conforming to Identifiable



struct ListOfPlayers: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Player.id) private var players: [Player]
    
    @EnvironmentObject var audioManager: AudioManager

    @State private var newName = ""
    @State private var playerScore = 0
    @State private var showRules = false
    @State private var navigateToCategory = false

    let minPlayers = 4
    let maxPlayers = 6

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray5)
                    .ignoresSafeArea()

                VStack {
                    Image("Logo")
                        .resizable()
                        .frame(width: 296, height: 80)
                        .padding()

                    Text("Add Players")
                        .font(.largeTitle)
                        .bold()
                    Text("Minimum 4 Players")
                        .font(.headline)
                        .bold()
                        .padding(.bottom, 10)

                    List(players) { player in
                        HStack {
                            Text(player.name)
                                .bold(player.isTurn)
                            Spacer()
                            Button("x") {
                                do {
                                    context.delete(player)
                                    try context.save()
                                } catch {
                                    print("Failed to delete player.")
                                }
                            }
                            .font(.caption)
                            .foregroundStyle(Color(.background))
                        }
                    }
                    .listStyle(.sidebar)

                    Spacer()

                    TextField("Enter player name (Max: 6 Players)", text: $newName)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 350)

                    Button {
                        let trimmedName = newName.trimmingCharacters(in: .whitespaces)

                        guard !trimmedName.isEmpty else { return }
                        guard players.count < maxPlayers else {
                            print("Cannot add more than \(maxPlayers) players.")
                            return
                        }

                        let newPlayer = Player(name: trimmedName, status: "alive", score: playerScore)
                        context.insert(newPlayer)

                        do {
                            try context.save()
                        } catch {
                            print("Failed to save player: \(error)")
                        }

                        newName = ""
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.black, lineWidth: 6)
                                .frame(width: 200, height: 40)
                                .background(Color.white)
                                .cornerRadius(50)
                            Text("ADD PLAYER")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    .disabled(players.count >= maxPlayers)

                    Button {
                        do {
                            try context.delete(model: Player.self)
                            try context.save()
                        } catch {
                            print("Failed to clear players.")
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.red, lineWidth: 6)
                                .frame(width: 200, height: 40)
                                .background(Color.white)
                                .cornerRadius(50)
                            Text("CLEAR ALL")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                    }

                    Spacer()

                    NavigationLink(destination: PickACategory(players: players), isActive: $navigateToCategory) {
                        EmptyView()
                    }

                    Button {
                        navigateToCategory = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.black, lineWidth: 6)
                                .frame(width: 200, height: 40)
                                .background(Color.white)
                                .cornerRadius(50)
                            Text("START GAME")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    .disabled(players.count < minPlayers)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showRules.toggle() }) {
                        Image(systemName: "book.closed")
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
 ListOfPlayers()
    .modelContainer(for: Player.self, inMemory: true)
    .environmentObject(AudioManager())
}
